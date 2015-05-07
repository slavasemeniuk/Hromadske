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

@interface DataManager()
@property (nonatomic, strong) NSString * dateOfLastArticle;
@property (nonatomic ,strong) RateAndWeather * rateAndWeather;
@end

@implementation DataManager

+ (DataManager *)sharedManager {
    static DataManager *_manager = nil;
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

-(void) dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


-(void)setUp{
    [MagicalRecord setupSQLiteStackWithStoreNamed:@"Hromadske.sqlite"];
    [self fetchLocalData];
}

-(void) updateArticleWithId:(NSNumber *)identifire{
    Articles *article = [Articles MR_findFirstByAttribute:@"id" withValue:identifire];
        [[RemoteManager sharedManager] parsedArticleWithId:identifire : ^(NSDictionary* updatedArticle){
            article.views_count = [updatedArticle valueForKey:@"views_count"];
            NSNull * n=[[NSNull alloc]init];
            if (![[updatedArticle valueForKey:@"content"] isEqual:n]) {
                article.content = [updatedArticle valueForKey:@"content"];
            }
            if ([[updatedArticle valueForKey:@"content"] isEqual:n]&&[article getLink]) {
                article.content = @"link";
            }
            if ([[updatedArticle valueForKey:@"content"] isEqual:n]&&![article getLink]) {
                article.content = [NSString stringWithFormat:HTMLCONTENTWITHIMAGE,article.title,[article getImageUrl],article.short_description];
                }
            
            [article.managedObjectContext MR_saveOnlySelfAndWait];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshDataNotification" object:nil];
        }];
}


-(void)saveRatesAndWeatherToContext:(NSArray*)data{
    RateAndWeather *rateAndWeather = [RateAndWeather MR_findFirst];
    [rateAndWeather updateRateAndWeather:data];
    [rateAndWeather.managedObjectContext MR_saveOnlySelfAndWait];
}


-(void)saveTeamToContext:(NSArray *)arrayOfTeam
{
    NSManagedObjectContext *context = nil;
    for (int i=0; i<[arrayOfTeam count]; i++)
    {
        Employe *employe = [Employe MR_createEntity];
        [employe convertDataToEmployeModel:[arrayOfTeam objectAtIndex:i]];
        context = employe.managedObjectContext;
    }
    [context MR_saveToPersistentStoreAndWait];
}

-(void)saveHelpDataToContext:(NSArray *)arrayOfHelpData
{
    HelpProject * helpProjectData= [HelpProject MR_createEntity];
    
    [helpProjectData convertDataToHelpProjectModel:arrayOfHelpData];
    
    [helpProjectData.managedObjectContext MR_saveOnlySelfAndWait];
   }

-(void)saveContactsDataToContext:(NSArray *)arrayOfContacts
{
    Contacts * contacts= [Contacts MR_createEntity];
    [contacts convertDataToContactsModel:arrayOfContacts];
    [contacts.managedObjectContext MR_saveOnlySelfAndWait];
}


-(id)getRateAndWeather{
    return _rateAndWeather;
}


- (void) teamWithCompletion:(void (^)()) completion {
    if ([Employe MR_countOfEntities]) {
        completion();
        [self upDateTeam];
    
    }
    else
    {
        if ([NetworkTracker isReachable]) {
            [[RemoteManager sharedManager] objectsForPath:TEAM_JSON attributes:nil success:^(NSArray *parsedTeam){
                [self saveTeamToContext:parsedTeam];
                [self fetchListOfEmployes];
                completion();
                
            }fail:^(){
                completion();
            }];
        }
    }
}

- (void) upDateTeam{
    [[RemoteManager sharedManager] objectsForPath:TEAM_JSON attributes:nil success:^(NSArray *parsedTeam){
        if ([parsedTeam count]==[_listOfEmployes count]) {
            for (int i=0; i<[parsedTeam count]; i++) {
                if ([[(Employe *)[_listOfEmployes objectAtIndex:i] identifire] intValue] != [[[parsedTeam objectAtIndex:i] valueForKey:@"id"] intValue]) {
                    Employe * employe =[Employe MR_findFirstByAttribute:@"identifire" withValue:[[_listOfEmployes objectAtIndex:i] identifire]];
                    [employe convertDataToEmployeModel:[parsedTeam objectAtIndex:i]];
                    [employe.managedObjectContext MR_saveOnlySelfAndWait];
                }
            }
        }else{
            [Employe truncateAll];
            [self saveTeamToContext:parsedTeam];
        }
         [self fetchListOfEmployes];
         [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTeamNotification" object:nil];
    }fail:^(){
        
    }];
}

- (void) helpProjectDataWithCompletion:(void (^)(id helpProjectData))completion{
    if ([HelpProject MR_countOfEntities]) {
        completion([HelpProject MR_findFirst]);
    }
    else
    {
        //[[RemoteManager sharedManager] parsedJsonWithEndOfURL:DONATE_JSON :^(NSArray *parsedHelpData)
         //{
         //   [self saveHelpDataToContext:parsedHelpData];
         //   completion([HelpProject MR_findFirst]);
       // }];
    }
}

-(void)contactsDataWithCompletion:(void (^)(id))completion{
    if ([Contacts MR_countOfEntities]) {
        completion([Contacts MR_findFirst]);
    }
    else
    {
        //[[RemoteManager sharedManager] parsedJsonWithEndOfURL:CONTACTS_JSON :^(NSArray *parsedContactsData)
        // {
        //     [self saveContactsDataToContext:parsedContactsData];
        //     completion([Contacts MR_findFirst]);
        // }];
    }
}


#pragma mark - FetchingLocalData
-(void)fetchLocalData{
    [self fetchListOfArticles];
    [self fetchListOfEmployes];
    [self fetchLocalRateAndWeather];

    if ([_listOfArticles count]) {
        _dateOfLastArticle = [[DateFormatter sharedManager] convertToTimeStamp:[(Articles *)[_listOfArticles firstObject] created_at]];
    }
    else {
        _dateOfLastArticle = @"1";
    }

}

-(void)fetchListOfArticles
{
    _listOfArticles = [Articles MR_findAllSortedBy:@"created_at" ascending:YES];
}

-(void) fetchListOfEmployes
{
    _listOfEmployes = [NSArray arrayWithArray:[Employe MR_findAllSortedBy:@"identifire" ascending:NO]];
}

-(void)fetchLocalRateAndWeather
{
    if (![RateAndWeather MR_findFirst]) {
        RateAndWeather *rateAndWeather = [RateAndWeather MR_createEntity];
        [rateAndWeather createInitialRateAndWeather];
        [rateAndWeather.managedObjectContext MR_saveOnlySelfAndWait];
    }
    _rateAndWeather=[RateAndWeather MR_findFirst];
}

#pragma mark - Remote

-(void) fetchRemoteArticles {
        [[RemoteManager sharedManager] objectsForPath:ARTICKE_JSON attributes:@{@"sync_date":_dateOfLastArticle, @"per_page":@"100"} success:^(NSArray *parsedArticles){
            NSMutableArray *newArticles =[NSMutableArray array];
            NSManagedObjectContext *context = nil;
            for (int i=0; i<[parsedArticles count]; i++)
            {
                Articles *article = [Articles MR_createEntity];
                [article createArticlesDataModel:[parsedArticles objectAtIndex:i]];
                context=article.managedObjectContext;
                [newArticles addObject:article];
            }
            [context MR_saveToPersistentStoreAndWait];
            
            if ([newArticles count]) {
                _dateOfLastArticle = [[DateFormatter sharedManager] convertToTimeStamp:[(Articles *)[newArticles firstObject] created_at]];
            }
            
            if ( [_delegate respondsToSelector:@selector(dataManager:didFinishUpdatingArticles:)])
            {
                [_delegate dataManager:self didFinishUpdatingArticles:newArticles];
            }
            
            
        }fail:^(){
            if ( [_delegate respondsToSelector:@selector(dataManagerDidFaildUpadating:)])
            {
                [_delegate dataManagerDidFaildUpadating:self];
            }
        }];
}

-(void)fetchRemoteDigest
{
    if ( [_delegate respondsToSelector:@selector(dataManagerDidStartUpadating:)] )
    {
        [_delegate dataManagerDidStartUpadating:self];
    }
    
        [[RemoteManager sharedManager] objectsForPath:DIGEST_JSON attributes:@{@"sync_date":_dateOfLastArticle} success:^(NSArray *parsedDigest) {
            
            [self saveRatesAndWeatherToContext:parsedDigest];
            [self fetchLocalRateAndWeather];
            
            NSNull *null = [[NSNull alloc]init];
            if ([[parsedDigest valueForKey:@"streaming"] firstObject]!=null) {
                _streamingURL = [[parsedDigest valueForKey:@"streaming"] firstObject];
            }else{
                _streamingURL=nil;
            }
            
            if ([[parsedDigest valueForKey:@"new_entries_count"] firstObject]!=[NSNumber numberWithInt:0]){
            [self fetchRemoteArticles];
            }else{
                if ( [_delegate respondsToSelector:@selector(dataManagerDidFaildUpadating:)])
                {
                    [_delegate dataManagerDidFaildUpadating:self];
                }
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DigestUpdated" object:nil];
            
        } fail:^{
            if ( [_delegate respondsToSelector:@selector(dataManagerDidFaildUpadating:)])
            {
                [_delegate dataManagerDidFaildUpadating:self];
            }

        }];
}

@end
