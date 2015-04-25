//
//  DataManager.h
//  Hromadske
//
//  Created by Admin on 20.03.15.
//  Copyright (c) 2015 Semeniuk Sviatoslav. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataManager : NSObject

+ (DataManager *)sharedManager;

- (void) updateDigest;
- (void) updateArticleWithId: (NSNumber*) identifire;

- (void) teamWithCompletion:(void (^)(NSArray *team)) completion;
- (void) helpProjectDataWithCompletion:(void (^)(id helpProjectData)) completion;
- (void) contactsDataWithCompletion:(void (^)(id contacts)) completion;

- (id) getRateAndWeather;

@property (nonatomic, strong) NSArray *listOfArticles;
@property (nonatomic, strong) NSString *streaming;
@property  NSInteger new_entries_count;

@end
