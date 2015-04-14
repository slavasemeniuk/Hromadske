//
//  DataManager.m
//  Hromadske
//
//  Created by Admin on 20.03.15.
//  Copyright (c) 2015 Semeniuk Sviatoslav. All rights reserved.
//

#import "DataManager.h"
#import <MagicalRecord.h>
#import "RemoteManager.h"
#import "Digest.h"
#import "Employe.h"
#import "HelpProject.h"
#import "Articles.h"
#import "Contacts.h"

@implementation DataManager

+ (DataManager *)sharedManager {
    static DataManager *__manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __manager = [[DataManager alloc] init];
    });
    
    return __manager;
}

- (void)saveTeamToContext:(NSArray *)arrayOfTeam
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

- (void)saveHelpDataToContext:(NSArray *)arrayOfHelpData
{
    HelpProject * helpProjectData= [HelpProject MR_createEntity];
    
    [helpProjectData convertDataToHelpProjectModel:arrayOfHelpData];
    
    [helpProjectData.managedObjectContext MR_saveOnlySelfAndWait];
   }

- (void)saveContactsDataToContext:(NSArray *)arrayOfContacts
{
    Contacts * contacts= [Contacts MR_createEntity];
    [contacts convertDataToContactsModel:arrayOfContacts];
    [contacts.managedObjectContext MR_saveOnlySelfAndWait];
}

- (void)saveArticlesToContext:(NSArray *)arrayOfArticles
{
    NSManagedObjectContext *context = nil;
    for (int i=0; i<[arrayOfArticles count]; i++)
    {
        Articles * articles = [Articles MR_createEntity];
        [articles convertDataToArticleModel:[arrayOfArticles objectAtIndex:i]];
        context=articles.managedObjectContext;
    }
    [context MR_saveToPersistentStoreAndWait];
}

-(NSArray *) fetchListOfEmployes
{
    return [Employe MR_findAll];
}

-(NSArray *)fetchListOfArticles
{
    return [Articles MR_findAll];
}

-(void) teamWithCompletion:(void (^)(NSArray *team)) completion {
    if ([Employe MR_countOfEntities]) {
        completion([self fetchListOfEmployes]);
    }
    else
    {
        [[RemoteManager sharedManager] parsedJsonWithEndOfURL:@"info/team" :^(NSArray *parsedTeam)
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
        [[RemoteManager sharedManager] parsedJsonWithEndOfURL:@"info/donate" :^(NSArray *parsedHelpData)
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
        [[RemoteManager sharedManager] parsedJsonWithEndOfURL:@"contacts" :^(NSArray *parsedContactsData)
         {
             [self saveContactsDataToContext:parsedContactsData];
             completion([Contacts MR_findFirst]);
         }];
    }
}

-(void)newsWithCompletion:(void (^)(NSArray *newsList))completion{
    //if ([[Digest sharedManager] countNewArticles]) {
        [[RemoteManager sharedManager] parsedJsonWithEndOfURL:@"articles" :^(NSArray *parsedArticlesData)
         {
             [self saveArticlesToContext:parsedArticlesData];
             //[[Digest sharedManager] setToZeroNewArticles];
             completion([Articles MR_findAll]);
         }];

  //  }
}

-(NSDate *)getDateOfLastArticle
{
    return [Articles MR_findFirst].created_at;
}
@end
