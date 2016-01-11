//
//  DataManager.h
//  Hromadske
//
//  Created by Admin on 20.03.15.
//  Copyright (c) 2015 Semeniuk Sviatoslav. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "RateAndWeather.h"
#import "Articles.h"

@interface DataManager : NSObject

@property (nonatomic, strong) RateAndWeather* rateAndWeather;
@property NSString* articleCategory;
@property NSDate* latestArticleDate;
@property NewsDetailsMode newsDetailsMode;

+ (DataManager*)sharedManager;
- (void)fetchRemoteDigestWithCompletion: (void (^)(void))success fail:(void (^)(void))fail;
+ (void)fetchRemoteArticlesWithCount: (NSNumber*)count success:(void (^)(NSUInteger))success fail:(void (^)(void))fail;
+ (void)fetchRemoterEmploye;
+ (NSArray*)getCategories;

+ (void)updateArticleWithId:(NSNumber*)identifire succes:(void (^)(Articles*))success fail:(void (^)(void))fail;



@end

