//
//  DataManager.m
//  Hromadske
//
//  Created by Admin on 20.03.15.
//  Copyright (c) 2015 Semeniuk Sviatoslav. All rights reserved.
//

#import "DataManager.h"
#import <MagicalRecord/MagicalRecord.h>
#import "RemoteManager.h"
#import "NetworkTracker.h"
#import "Constants.h"
#import "RateAndWeather.h"
#import "Employe.h"
#import "HelpProject.h"
#import "Articles.h"
#import "Contacts.h"

@interface DataManager()
@property (nonatomic, strong) NSString *dateOfLastArticle;
@property (nonatomic ,strong) RateAndWeather *rateAndWeather;
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

-(void)setUp{
    [MagicalRecord setupSQLiteStackWithStoreNamed:@"Hromadske.sqlite"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDigest) name:@"checkDigest" object:nil];
    
    [NetworkTracker sharedManager];
    
    _listOfArticles= [self fetchListOfArticles];
    [self fetchRateAndWeather];
    _new_entries_count=0;
    
    if ([_listOfArticles count]) {
        _dateOfLastArticle = [[[_listOfArticles objectAtIndex:0] valueForKey:@"created_at"] stringValue];
        
    }
    else {
        _dateOfLastArticle = @"1";
    }

}

-(void)updateDigest
{
    if ([NetworkTracker isReachable])
    {
        [[RemoteManager sharedManager] parsedJsonWithTimeSync:_dateOfLastArticle andUrlEnd:DIGEST_JSON :^(NSArray *parsedDigest)
          {
              [self saveRatesAndWeatherToContext:parsedDigest];
              [self fetchRateAndWeather];
              
              NSNull *null = [[NSNull alloc]init];
              if ([[parsedDigest valueForKey:@"streaming"] objectAtIndex:0]!=null) {
                  _streaming = [[parsedDigest valueForKey:@"streaming"] objectAtIndex:0];
              }
              else{
                  _streaming=nil;
              }
              
              [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMenuNotification" object:nil];
              
              [self updateArticlesData];
          }];
    }
}

-(void) updateArticlesData {
     ///if (!_new_entries_count)//Change when API done
     //{
         [[RemoteManager sharedManager] parsedJsonWithTimeSync:_dateOfLastArticle andUrlEnd:ARTICKE_JSON :^(NSArray *parsedArticles)
          {
              [self saveArticlesToContext:parsedArticles];
              _listOfArticles = [self fetchListOfArticles];
              if ([parsedArticles count]) {
                  _new_entries_count = [parsedArticles count];
              }
              _dateOfLastArticle = [[[_listOfArticles objectAtIndex:0] valueForKey:@"created_at"] stringValue];
              [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshDataNotification" object:nil];
          }];
    // }
}

-(void) updateArticleWithId:(NSNumber *)identifire{
    Articles *article = [Articles MR_findFirstByAttribute:@"id" withValue:identifire];
        [[RemoteManager sharedManager] parsedArticleWithId:identifire : ^(NSDictionary* updatedArticle){
            article.views_count = [updatedArticle valueForKey:@"views_count"];
            NSNull * n=[[NSNull alloc]init];
            if (![[updatedArticle valueForKey:@"content"] isEqual:n]) {
                article.content = [updatedArticle valueForKey:@"content"];
            }
            else{
                article.content = @"link";
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

-(void)fetchRateAndWeather
{
    if (![RateAndWeather MR_findFirst]) {
        RateAndWeather *rateAndWeather = [RateAndWeather MR_createEntity];
        [rateAndWeather createInitialRateAndWeather];
        [rateAndWeather.managedObjectContext MR_saveOnlySelfAndWait];
    }
    _rateAndWeather=[RateAndWeather MR_findFirst];
}

- (void)saveArticlesToContext:(NSArray *)arrayOfArticles
{
    NSManagedObjectContext *context = nil;
    for (int i=0; i<[arrayOfArticles count]; i++)
    {
        Articles *article = [Articles MR_createEntity];
        [article createArticlesDataModel:[arrayOfArticles objectAtIndex:i]];
        context=article.managedObjectContext;
    }
    [context MR_saveToPersistentStoreAndWait];
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


-(NSArray *)fetchListOfArticles
{
    return [Articles MR_findAllSortedBy:@"created_at" ascending:NO];
}

-(NSArray *) fetchListOfEmployes
{
    return [Employe MR_findAll];
}


-(id)getRateAndWeather{
    return _rateAndWeather;
}


-(void) teamWithCompletion:(void (^)(NSArray *team)) completion {
    if ([Employe MR_countOfEntities]) {
        completion([self fetchListOfEmployes]);
    }
    else
    {
        [[RemoteManager sharedManager] parsedJsonWithEndOfURL:TEAM_JSON :^(NSArray *parsedTeam)
        {
            [self saveTeamToContext:parsedTeam];
            completion([self fetchListOfEmployes]);
        }];
    }
}

-(void) helpProjectDataWithCompletion:(void (^)(id helpProjectData))completion{
    if ([HelpProject MR_countOfEntities]) {
        completion([HelpProject MR_findFirst]);
    }
    else
    {
        [[RemoteManager sharedManager] parsedJsonWithEndOfURL:DONATE_JSON :^(NSArray *parsedHelpData)
         {
            [self saveHelpDataToContext:parsedHelpData];
            completion([HelpProject MR_findFirst]);
        }];
    }
}

-(void)contactsDataWithCompletion:(void (^)(id))completion{
    if ([Contacts MR_countOfEntities]) {
        completion([Contacts MR_findFirst]);
    }
    else
    {
        [[RemoteManager sharedManager] parsedJsonWithEndOfURL:CONTACTS_JSON :^(NSArray *parsedContactsData)
         {
             [self saveContactsDataToContext:parsedContactsData];
             completion([Contacts MR_findFirst]);
         }];
    }
}

-(void) dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
