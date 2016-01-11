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

- (void)setUp
{
    [self fetchLocalRateAndWeather];
    _articleCategory = @"Всі новини";
    _newsDetailsMode = NewsDetailsModeNone;
}

#pragma mark - FetchingLocalData

+ (NSArray*)getCategories
{
    NSError* error;
    NSFetchRequest* fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Categories class])];
    NSArray* categoryList = [[RestKitManager managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    NSMutableArray* categoryStringList = [[NSMutableArray alloc] init];
    for (Categories* category in categoryList) {
        if (![category.name isEqualToString:@"uncategorized"]) {
            [categoryStringList addObject:category.name];
        }
    }
    
    return categoryStringList;
}

- (void)fetchLocalRateAndWeather
{
    NSError* error;
    NSFetchRequest* fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([RateAndWeather class])];
    NSArray* rateAndWeatherList = [[RestKitManager managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    if (rateAndWeatherList.count > 0) {
        self.rateAndWeather = [rateAndWeatherList firstObject];
    } else {
        RateAndWeather* rateAndWeather = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([RateAndWeather class]) inManagedObjectContext:[RestKitManager managedObjectContext]];
        self.rateAndWeather = rateAndWeather;
    }
}

#pragma mark - Remote

+ (void)fetchRemoterEmploye {
    [[RKObjectManager sharedManager] getObjectsAtPath:TEAM_JSON parameters:nil success:nil failure:nil];
}

+ (void)fetchRemoteArticlesWithCount: (NSNumber*)count success:(void (^)(NSUInteger))success fail:(void (^)(void))fail
{
    NSDictionary* params;
    if (count && [[DataManager sharedManager] latestArticleDate]) {
        params = @{@"sync_date" : [[DateFormatter sharedManager] convertToTimeStamp:[[DataManager sharedManager] latestArticleDate]], @"per_page" : [NSString stringWithFormat:@"%i",count.intValue]};
    }
    
    if (count && ![[DataManager sharedManager] latestArticleDate]) {
        params = @{@"per_page" : [NSString stringWithFormat:@"%i",count.intValue]};
    }
    
    if (!count && [[DataManager sharedManager] latestArticleDate]) {
        params = @{@"sync_date" : [[DateFormatter sharedManager] convertToTimeStamp:[[DataManager sharedManager] latestArticleDate]]};
    }
    
    [[RKObjectManager sharedManager] getObjectsAtPath:ARTICKE_JSON parameters:params success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        if (success) {
            if (mappingResult.array.count > 0) {
                [[DataManager sharedManager] setLatestArticleDate:[(Articles*)mappingResult.array.firstObject created_at]];
            }
            success(mappingResult.array.count);
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        if (fail) {
            fail();
        }
    }];
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

@end
