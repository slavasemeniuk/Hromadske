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

- (void) teamWithCompletion:(void (^)(NSArray *team)) completion;

- (void) helpProjectDataWithCompletion:(void (^)(id helpProjectData)) completion;

- (void) contactsDataWithCompletion:(void (^)(id contacts)) completion;

- (void) newsWithCompletion:(void (^)(NSArray *newsList)) completion;

- (NSDate* ) getDateOfLastArticle;

- (NSArray *)fetchListOfArticles;

@end
