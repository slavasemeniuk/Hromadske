//
//  DataManager.m
//  Hromadske
//
//  Created by Admin on 20.03.15.
//  Copyright (c) 2015 Semeniuk Sviatoslav. All rights reserved.
//

#import "DataManager.h"
#import <MagicalRecord/MagicalRecord.h>
#import "DateFormatter.h"
#import "RemoteManager.h"
#import "NetworkTracker.h"
#import "Constants.h"
#import "RateAndWeather.h"
#import "Employe.h"
#import "HelpProject.h"
#import "Articles.h"
#import "Contacts.h"
#import "Categories.h"

@interface DataManager ()
@property (nonatomic, strong) NSString* dateOfLastArticle;
@property (nonatomic, strong) RateAndWeather* rateAndWeather;

@end

@implementation DataManager

+ (DataManager*)sharedManager
{
    static DataManager* _manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[DataManager alloc] init];

    });

    return _manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setUp
{
    [MagicalRecord setupSQLiteStackWithStoreNamed:@"Hromadske.sqlite"];
    [self fetchLocalData];
    _articleCategory = @"Всі новини";
    _newsDetailsMode = NewsDetailsModeNone;
}

#pragma mark SAVING
- (void)saveRatesAndWeatherToContext:(NSArray*)data
{
    RateAndWeather* rateAndWeather = [RateAndWeather MR_findFirst];
    [rateAndWeather updateRateAndWeather:data];
    [rateAndWeather.managedObjectContext MR_saveOnlySelfAndWait];
}

- (void)saveTeamToContext:(NSArray*)arrayOfTeam
{
    NSManagedObjectContext* context = nil;
    for (int i = 0; i < [arrayOfTeam count]; i++) {
        Employe* employe = [Employe MR_createEntity];
        [employe convertDataToEmployeModel:[arrayOfTeam objectAtIndex:i]];
        context = employe.managedObjectContext;
    }
    [context MR_saveToPersistentStoreAndWait];
}

- (void)teamWithCompletion:(void (^)())completion
{
    if ([Employe MR_countOfEntities]) {
        completion();
        [self upDateTeam];
    }
    else {
        if ([NetworkTracker isReachable]) {
            [[RemoteManager sharedManager] objectsForPath:TEAM_JSON
                attributes:nil
                success:^(NSArray* parsedTeam) {
                    [self saveTeamToContext:parsedTeam];
                    [self fetchListOfEmployes];
                    completion();

                }
                fail:^() {
                    completion();
                }];
        }
    }
}

#pragma mark - FetchingLocalData
- (void)fetchLocalData
{
    [self fetchListOfArticles];
    [self fetchListOfEmployes];
    [self fetchLocalRateAndWeather];

    if ([_listOfArticles count]) {
        _dateOfLastArticle = [[DateFormatter sharedManager] convertToTimeStamp:[(Articles*)[_listOfArticles firstObject] created_at]];
    }
    else {
        _dateOfLastArticle = @"1";
    }
}

- (void)fetchListOfArticles
{
    _listOfArticles = [Articles MR_findAllSortedBy:@"created_at" ascending:NO];
}

- (void)fetchListOfEmployes
{
    _listOfEmployes = [NSArray arrayWithArray:[Employe MR_findAllSortedBy:@"identifire" ascending:YES]];
}

- (void)fetchCategories
{
    _categories = [Categories MR_findAll];
}

- (NSArray*)getCategories
{
    [self fetchCategories];
    NSMutableArray* categoryStringList = [NSMutableArray array];
    for (Categories* category in _categories) {
        if (![category.name isEqualToString:@"uncategorized"]) {
            [categoryStringList addObject:category.name];
        }
    }
    return categoryStringList;
}

- (NSArray*)getArticlesWithCurrentCategories
{
    if ([[DataManager sharedManager].articleCategory isEqualToString:@"Всі новини"]) {
        return _listOfArticles;
    }
    else {
        return [_listOfArticles filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"category.name==%@", _articleCategory]];
    }
}

- (id)getRateAndWeather
{
    return _rateAndWeather;
}

- (void)fetchLocalRateAndWeather
{
    if (![RateAndWeather MR_findFirst]) {
        RateAndWeather* rateAndWeather = [RateAndWeather MR_createEntity];
        [rateAndWeather createInitialRateAndWeather];
        [rateAndWeather.managedObjectContext MR_saveOnlySelfAndWait];
    }
    _rateAndWeather = [RateAndWeather MR_findFirst];
}

#pragma mark - Remote

- (void)fetchRemoteArticles
{
    [[RemoteManager sharedManager] objectsForPath:ARTICKE_JSON
        attributes:@{ @"sync_date" : _dateOfLastArticle,
            @"per_page" : @"100" }
        success:^(NSArray* parsedArticles) {
            NSMutableArray* newArticles = [NSMutableArray array];
            NSManagedObjectContext* context = nil;
            for (int i = 0; i < [parsedArticles count]; i++) {
                Articles* article = [Articles MR_createEntity];
                [article createArticlesDataModel:[parsedArticles objectAtIndex:i]];
                context = article.managedObjectContext;
                [newArticles addObject:article];
            }
            [context MR_saveToPersistentStoreAndWait];

            [self updateViewsCount];

            if ([newArticles count]) {
                _dateOfLastArticle = [[DateFormatter sharedManager] convertToTimeStamp:[(Articles*)[newArticles firstObject] created_at]];
            }

            if ([_delegate respondsToSelector:@selector(dataManager:didFinishUpdatingArticles:)]) {
                [_delegate dataManager:self didFinishUpdatingArticles:newArticles];
            }

        }
        fail:^() {
            if ([_delegate respondsToSelector:@selector(dataManagerDidFaildUpadating:)]) {
                [_delegate dataManagerDidFaildUpadating:self];
            }
        }];
}

- (void)fetchRemoteDigest
{
    if ([_delegate respondsToSelector:@selector(dataManagerDidStartUpadating:)]) {
        [_delegate dataManagerDidStartUpadating:self];
    }

    [[RemoteManager sharedManager] objectsForPath:DIGEST_JSON
        attributes:@{ @"sync_date" : _dateOfLastArticle }
        success:^(NSArray* parsedDigest) {

            [self saveRatesAndWeatherToContext:parsedDigest];
            [self fetchLocalRateAndWeather];

            NSNull* null = [[NSNull alloc] init];
            if ([[parsedDigest valueForKey:@"streaming"] firstObject] != null) {
                _streamingURL = [[parsedDigest valueForKey:@"streaming"] firstObject];
            }
            else {
                _streamingURL = nil;
            }

            if (![[[parsedDigest valueForKey:@"new_entries_count"] firstObject] isEqual:@"0"]) {
                [self fetchRemoteArticles];
            }
            else {
                [self updateViewsCount];
                if ([_delegate respondsToSelector:@selector(dataManagerDidFaildUpadating:)]) {
                    [_delegate dataManagerDidFaildUpadating:self];
                }
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DigestUpdated" object:nil];

        }
        fail:^{
            if ([_delegate respondsToSelector:@selector(dataManagerDidFaildUpadating:)]) {
                [_delegate dataManagerDidFaildUpadating:self];
            }

        }];
}

#pragma mark Updating local data

- (void)updateArticleWithId:(NSNumber*)identifire
{
    Articles* article = [Articles MR_findFirstByAttribute:@"id" withValue:identifire];
    NSString* path = [NSString stringWithFormat:@"%@/%@", ARTICKE_JSON, article.id.stringValue];
    [[RemoteManager sharedManager] dicrtionaryForPath:path
        attributes:nil
        success:^(NSDictionary* updatedArticle) {

            article.views_count = [updatedArticle valueForKey:@"views_count"];

            NSNull* n = [[NSNull alloc] init];
            if (![[updatedArticle valueForKey:@"content"] isEqual:n]) {
                article.content = [updatedArticle valueForKey:@"content"];
            }

            if ([[updatedArticle valueForKey:@"content"] isEqual:n] && [article getLink]) {
                article.content = @"link";
            }

            if ([[updatedArticle valueForKey:@"content"] isEqual:n] && ![article getLink]) {
                NSDataDetector* detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:nil];
                NSArray* matches = [detector matchesInString:article.short_description options:0 range:NSMakeRange(0, [article.short_description length])];

                NSString* short_description = article.short_description;

                for (NSTextCheckingResult* match in matches) {
                    NSString* link = [[match URL] absoluteString];
                    NSString* html_link = [NSString stringWithFormat:@"<a href='%@'>%@</a>", link, link];
                    short_description = [short_description stringByReplacingOccurrencesOfString:link withString:html_link];
                }

                article.content = [NSString stringWithFormat:HTML_CONTENT_WITH_IMAGE, article.title, [article getImageUrl], short_description];
            }
            [article.managedObjectContext MR_saveOnlySelfAndWait];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshDataNotification" object:nil];
        }
        fail:^(){

        }];
}

- (void)updateViewsCount
{
    NSString* count = [NSString stringWithFormat:@"%lu", (unsigned long)[Articles MR_countOfEntities]];
    [self fetchListOfArticles];
    [[RemoteManager sharedManager] objectsForPath:ARTICKE_JSON
        attributes:@{ @"sync_date" : @"1",
            @"per_page" : count }
        success:^(NSArray* parsedArticles) {
            for (int i = 0; i < [parsedArticles count]; i++) {
                Articles* article = [_listOfArticles objectAtIndex:i];
                article.views_count = [[parsedArticles objectAtIndex:i] valueForKey:@"views_count"];
                [article.managedObjectContext MR_saveOnlySelfAndWait];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ViewsCountUpdated" object:nil];
        }
        fail:^(){

        }];
}

- (void)upDateTeam
{
    [[RemoteManager sharedManager] objectsForPath:TEAM_JSON
        attributes:nil
        success:^(NSArray* parsedTeam) {
            if ([parsedTeam count] == [_listOfEmployes count]) {
                for (int i = 0; i < [parsedTeam count]; i++) {
                    if ([[(Employe*)[_listOfEmployes objectAtIndex:i] identifire] intValue] != [[[parsedTeam objectAtIndex:i] valueForKey:@"id"] intValue]) {
                        Employe* employe = [Employe MR_findFirstByAttribute:@"identifire" withValue:[[_listOfEmployes objectAtIndex:i] identifire]];
                        [employe convertDataToEmployeModel:[parsedTeam objectAtIndex:i]];
                        [employe.managedObjectContext MR_saveOnlySelfAndWait];
                    }
                }
            }
            else {
                [Employe truncateAll];
                [self saveTeamToContext:parsedTeam];
            }
            [self fetchListOfEmployes];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTeamNotification" object:nil];
        }
        fail:^(){

        }];
}

@end
