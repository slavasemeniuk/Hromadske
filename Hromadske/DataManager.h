//
//  DataManager.h
//  Hromadske
//
//  Created by Admin on 20.03.15.
//  Copyright (c) 2015 Semeniuk Sviatoslav. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
@protocol DataManangerDelagate;

@interface DataManager : NSObject

+ (DataManager*)sharedManager;

- (void)updateArticleWithId:(NSNumber*)identifire;
- (void)teamWithCompletion:(void (^)())completion;
- (NSArray*)getCategories;
- (NSArray*)getArticlesWithCurrentCategories;
- (void)fetchRemoteArticles;
- (void)fetchRemoteDigest;
- (id)getRateAndWeather;

@property (nonatomic, strong) NSArray* listOfArticles;
@property (nonatomic, strong) NSArray* listOfEmployes;
@property (nonatomic, strong) NSArray* categories;
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
