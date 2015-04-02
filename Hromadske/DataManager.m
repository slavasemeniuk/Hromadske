//
//  DataManager.m
//  Hromadske
//
//  Created by Admin on 20.03.15.
//  Copyright (c) 2015 Semeniuk Sviatoslav. All rights reserved.
//

#import "DataManager.h"
#import <MagicalRecord.h>
#import "Employe.h"
#import "HelpProject.h"
#import "RemoteManager.h"

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
        
        employe.name = [[arrayOfTeam objectAtIndex:i] valueForKey:@"title"];
        employe.image = [[arrayOfTeam objectAtIndex:i] valueForKey:@"image"];
        employe.bio = [[arrayOfTeam objectAtIndex:i] valueForKey:@"fulltext"];
        context = employe.managedObjectContext;
    }
    [context MR_saveToPersistentStoreAndWait];
    
}

- (void)saveHelpDataToContext:(NSArray *)arrayOfHelpData
{
    HelpProject * helpProjectData= [HelpProject MR_createEntity];
    helpProjectData.content = [arrayOfHelpData valueForKey:@"content"];
    helpProjectData.url = [arrayOfHelpData valueForKey:@"url"];
}


-(NSArray *) fetchListOfEmployes
{
    return [Employe MR_findAll];
}

- (void) teamWithCompletion:(void (^)(NSArray *team)) completion {
    if ([Employe MR_countOfEntities]) {
        completion([self fetchListOfEmployes]);
    }
    else
    {
        [[RemoteManager sharedManager] parsedJsonWithEndOfURL:@"team" :^(NSArray *parsedTeam)
        {
            [self saveTeamToContext:parsedTeam];
            completion([self fetchListOfEmployes]);
        }];
    }
}

- (void) helpProjectDataWithCompletion:(void (^)(id helpProjectData))completion
{
    if ([HelpProject MR_countOfEntities]) {
        completion([HelpProject MR_findFirst]);
    }
    else
    {
        [[RemoteManager sharedManager] parsedJsonWithEndOfURL:@"donate" :^(NSArray *parsedHelpData)
         {
            [self saveHelpDataToContext:parsedHelpData];
            completion([HelpProject MR_findFirst]);
        }];
    }
}

@end
