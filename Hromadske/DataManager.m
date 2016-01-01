//
//  DataManager.m
//  Hromadske
//
//  Created by Admin on 20.03.15.
//  Copyright (c) 2015 Semeniuk Sviatoslav. All rights reserved.
//

#import "DataManager.h"
#import "DateFormatter.h"
#import <RestKit/RestKit.h>
#import "RestKitManager.h"
#import "NetworkTracker.h"
#import "Photo.h"
#import "Constants.h"
#import "Employe.h"
#import "HelpProject.h"
#import "Contacts.h"
#import "Categories.h"

@interface DataManager ()
@property (nonatomic, strong) NSString* dateOfLastArticle;

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
    [self fetchLocalData];
    _articleCategory = @"Всі новини";
    _newsDetailsMode = NewsDetailsModeNone;
}

#pragma mark SAVING
- (void)saveRatesAndWeatherToContext:(NSArray*)data
{
//    RateAndWeather* rateAndWeather = [RateAndWeather MR_findFirst];
//    [rateAndWeather updateRateAndWeather:data];
//    [rateAndWeather.managedObjectContext MR_saveOnlySelfAndWait];
}


#pragma mark - FetchingLocalData
- (void)fetchLocalData
{
    [self fetchListOfArticles];
    [self fetchLocalRateAndWeather];

//    if ([_listOfArticles count]) {
//        _dateOfLastArticle = [[DateFormatter sharedManager] convertToTimeStamp:[(Articles*)[_listOfArticles firstObject] created_at]];
//    }
//    else {
//        _dateOfLastArticle = @"1";
//    }
}

- (void)fetchListOfArticles
{
//    _listOfArticles = [Articles MR_findAllSortedBy:@"created_at" ascending:NO];
}

//- (NSArray* )fetchCategories
//{
//    return [Categories MR_findAll];
//}

//- (NSArray*)getCategories
//{
//    NSArray *categoryList = [self fetchCategories];
//    NSMutableArray* categoryStringList = [NSMutableArray array];
//    for (Categories* category in categoryList) {
//        if (![category.name isEqualToString:@"uncategorized"]) {
//            [categoryStringList addObject:category.name];
//        }
//    }
//    return categoryStringList;
//}

//- (NSArray*)getArticlesWithCurrentCategories
//{
//    if ([[DataManager sharedManager].articleCategory isEqualToString:@"Всі новини"]) {
//        return _listOfArticles;
//    }
//    else {
//        return [_listOfArticles filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"category.name==%@", _articleCategory]];
//    }
//}

- (void)fetchLocalRateAndWeather
{
    NSError* error;
    NSFetchRequest* fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([RateAndWeather class])];
    NSArray* rateAndWeatherList = [[RestKitManager managedObkjectContext] executeFetchRequest:fetchRequest error:&error];
    if (rateAndWeatherList.count > 0) {
        self.rateAndWeather = [rateAndWeatherList firstObject];
    } else {
        RateAndWeather* rateAndWeather = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([RateAndWeather class]) inManagedObjectContext:[RestKitManager managedObkjectContext]];
        self.rateAndWeather = rateAndWeather;
    }
}

#pragma mark - Remote

+ (void)fetchRemoterEmploye {
    [[RKObjectManager sharedManager] getObjectsAtPath:TEAM_JSON parameters:nil success:nil failure:nil];
}

+ (void)fetchRemoteArticlesFromDate:(NSDate*)date andCount: (NSNumber*)count success:(void (^)(NSUInteger))success fail:(void (^)(void))fail
{
    NSDictionary* params;
    if (count && date) {
        params = @{@"sync_date" : [[DateFormatter sharedManager] convertToTimeStamp:date], @"per_page" : [NSString stringWithFormat:@"%i",count.intValue]};
    }
    if (count && !date) {
        params = @{@"per_page" : [NSString stringWithFormat:@"%i",count.intValue]};
    }
    if (!count && date) {
        params = @{@"sync_date" : [[DateFormatter sharedManager] convertToTimeStamp:date]};
    }
    
    [[RKObjectManager sharedManager] getObjectsAtPath:ARTICKE_JSON parameters:params success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        if (success) {
            success(mappingResult.array.count);
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        if (fail) {
            fail();
        }
    }];
//    [[RemoteManager sharedManager] objectsForPath:ARTICKE_JSON
//        attributes:@{ @"sync_date" : _dateOfLastArticle,
//            @"per_page" : @"100" }
//        success:^(NSArray* parsedArticles) {
//            NSMutableArray* newArticles = [NSMutableArray array];
//            NSManagedObjectContext* context = nil;
//            for (int i = 0; i < [parsedArticles count]; i++) {
//                Articles* article = [Articles MR_createEntity];
//                [article createArticlesDataModel:[parsedArticles objectAtIndex:i]];
//                context = article.managedObjectContext;
//                [newArticles addObject:article];
//            }
//            [context MR_saveToPersistentStoreAndWait];
//
//            [self updateViewsCount];
//
//            if ([newArticles count]) {
//                _dateOfLastArticle = [[DateFormatter sharedManager] convertToTimeStamp:[(Articles*)[newArticles firstObject] created_at]];
//            }
//
//            if ([_delegate respondsToSelector:@selector(dataManager:didFinishUpdatingArticles:)]) {
//                [_delegate dataManager:self didFinishUpdatingArticles:newArticles];
//            }
//
//        }
//        fail:^() {
//            if ([_delegate respondsToSelector:@selector(dataManagerDidFaildUpadating:)]) {
//                [_delegate dataManagerDidFaildUpadating:self];
//            }
//        }];
}

- (void)fetchRemoteDigestWithCompletion: (void (^)(void))success fail:(void (^)(void))fail
{
    [[RKObjectManager sharedManager] getObjectsAtPath:DIGEST_JSON parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        self.rateAndWeather = [[mappingResult array] firstObject];
        if (success) {
            success();
        }
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        if (fail){
            NSLog(@"%@",error);
            fail();
        }
    }];

//    [[RemoteManager sharedManager] objectsForPath:DIGEST_JSON
//        attributes:@{ @"sync_date" : _dateOfLastArticle }
//        success:^(NSArray* parsedDigest) {
//
//            [self saveRatesAndWeatherToContext:parsedDigest];
//            [self fetchLocalRateAndWeather];
//
//            NSNull* null = [[NSNull alloc] init];
//            if ([[parsedDigest valueForKey:@"streaming"] firstObject] != null) {
//                _streamingURL = [[parsedDigest valueForKey:@"streaming"] firstObject];
//            }
//            else {
//                _streamingURL = nil;
//            }
//
//            if (![[[parsedDigest valueForKey:@"new_entries_count"] firstObject] isEqual:@"0"]) {
//                [self fetchRemoteArticles];
//            }
//            else {
//                [self updateViewsCount];
//                if ([_delegate respondsToSelector:@selector(dataManagerDidFaildUpadating:)]) {
//                    [_delegate dataManagerDidFaildUpadating:self];
//                }
//            }
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"DigestUpdated" object:nil];
//
//        }
//        fail:^{
//            if ([_delegate respondsToSelector:@selector(dataManagerDidFaildUpadating:)]) {
//                [_delegate dataManagerDidFaildUpadating:self];
//            }
//
//        }];
}

#pragma mark Updating local data

+ (void)updateArticleWithId:(NSNumber*)identifire succes:(void (^)(Articles*))success fail:(void (^)(void))fail
{
    NSString* path = [ARTICLE_DETAIL stringByReplacingOccurrencesOfString:@":id" withString:identifire.stringValue];
    
    [[RKObjectManager sharedManager] getObjectsAtPath:path parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        Articles* article = [[mappingResult array] firstObject];
        if (success) {
            success(article);
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        if (fail){
            NSLog(@"%@",error);
            fail();
        }

    }];
}

- (void)updateViewsCount
{
//    NSString* count = [NSString stringWithFormat:@"%lu", (unsigned long)[Articles MR_countOfEntities]];
//    [self fetchListOfArticles];
//    [[RemoteManager sharedManager] objectsForPath:ARTICKE_JSON
//        attributes:@{ @"sync_date" : @"1",
//            @"per_page" : count }
//        success:^(NSArray* parsedArticles) {
//            for (int i = 0; i < [parsedArticles count]; i++) {
//                Articles* article = [_listOfArticles objectAtIndex:i];
//                article.views_count = [[parsedArticles objectAtIndex:i] valueForKey:@"views_count"];
//                [article.managedObjectContext MR_saveOnlySelfAndWait];
//            }
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"ViewsCountUpdated" object:nil];
//        }
//        fail:^(){
//
//        }];
}

@end
