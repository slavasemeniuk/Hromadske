//
//  RemoteManager.h
//  Hromadske
//
//  Created by Admin on 19.03.15.
//  Copyright (c) 2015 Semeniuk Sviatoslav. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RemoteManager : NSObject


+ (RemoteManager *)sharedManager;

- (void)dicrtionaryForPath:(NSString *)path attributes:(NSDictionary *)attributes success:(void (^)(NSDictionary *))success fail:(void (^)(void))fail;

- (void)objectsForPath:(NSString *)path attributes:(NSDictionary *)attributes success:(void (^)(NSArray *))success fail:(void (^)(void))fail;

@end
