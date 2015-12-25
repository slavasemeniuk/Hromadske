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
@protocol DataManangerDelagate;

@interface DataManager : NSObject

+ (DataManager*)sharedManager;

@property (nonatomic, strong) RateAndWeather* rateAndWeather;
- (void)fetchRemoteDigestWithCompletion: (void (^)(void))success fail:(void (^)(void))fail;

+ (void)fetchRemoterEmploye;

- (void)updateArticleWithId:(NSNumber*)identifire;
- (NSArray*)getCategories;
- (NSArray*)getArticlesWithCurrentCategories;
- (void)fetchRemoteArticles;
- (id)getRateAndWeather;

@property (nonatomic, strong) NSArray* listOfArticles;
@property (nonatomic, strong) NSString* streamingURL;
@property NSString* articleCategory;
@property NewsDetailsMode newsDetailsMode;
@property (nonatomic, assign) id<DataManangerDelagate> delegate;

@end

@protocol DataManangerDelagate <NSObject>

@optional
- (void)dataManagerDidStartUpadating:(DataManager*)manager;
- (void)dataManager:(DataManager*)manager didFinishUpdatingArticles:(NSArray*)listOfArticles;
- (void)dataManagerDidFaildUpadating:(DataManager*)manager;
@end
