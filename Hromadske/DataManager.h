//
//  DataManager.h
//  Hromadske
//
//  Created by Admin on 20.03.15.
//  Copyright (c) 2015 Semeniuk Sviatoslav. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol DataManangerDelagate;

@interface DataManager : NSObject

+ (DataManager *)sharedManager;


- (void) updateArticleWithId: (NSNumber*) identifire;

- (void) teamWithCompletion:(void (^)(NSArray *team)) completion;
- (void) helpProjectDataWithCompletion:(void (^)(id helpProjectData)) completion;
- (void) contactsDataWithCompletion:(void (^)(id contacts)) completion;


- (void) fetchRemoteArticles;
- (void) fetchRemoteDigest;

- (id) getRateAndWeather;


@property (nonatomic, strong) NSArray *listOfArticles;
@property (nonatomic, strong) NSArray *listOfEmployes;
@property (nonatomic, strong) NSString *streamingURL;
@property  NSInteger new_entries_count;
@property (nonatomic ,assign) id <DataManangerDelagate> delegate;

@end


@protocol DataManangerDelagate<NSObject>

@optional
- (void) dataManagerDidStartUpadating:(DataManager *)manager;
- (void) dataManager:(DataManager *)manager didFinishUpdatingArticles: (NSArray *)listOfArticles;
- (void) dataManagerDidFaildUpadating:(DataManager *)manager;
@end
