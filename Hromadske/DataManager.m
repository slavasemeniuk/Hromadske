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

#pragma mark - FetchingLocalData
- (void)fetchLocalData
{
    [self fetchLocalRateAndWeather];
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

//            NSNull* null = [[NSNull alloc] init];
//            if ([[parsedDigest valueForKey:@"streaming"] firstObject] != null) {
//                _streamingURL = [[parsedDigest valueForKey:@"streaming"] firstObject];
//            }
//            else {
//                _streamingURL = nil;
//            }
//
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
