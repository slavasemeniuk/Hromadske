//
//  RemoteManager.m
//  Hromadske
//
//  Created by Admin on 19.03.15.
//  Copyright (c) 2015 Semeniuk Sviatoslav. All rights reserved.
//

#import "RemoteManager.h"
#import "Constants.h"
#import <AFNetworking/AFNetworking.h>


@implementation RemoteManager

+ (RemoteManager *)sharedManager {
    static RemoteManager *__manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __manager = [[RemoteManager alloc] init];
    });
    
    return __manager;
}

- (void) objectsForPath:(NSString *)path attributes:(NSDictionary *)attributes success:(void (^)(NSArray *))success fail:(void (^)(void))fail
{
   
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:path parameters:attributes success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success([NSArray arrayWithArray:responseObject[@"data"]]);
    }
         failure:^(AFHTTPRequestOperation *operation,NSError *error){
             if (fail){
                 NSLog(@"%@",error);
                 fail();
             }
         }];
}

- (void)dicrtionaryForPath: (NSString *)path attributes:(NSDictionary *)attributes success:(void (^)(NSDictionary *))success fail:(void (^)(void))fail
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:path parameters:attributes success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success([NSDictionary dictionaryWithDictionary:responseObject[@"data"]]);
    }
         failure:^(AFHTTPRequestOperation *operation,NSError *error){
             if (fail){
                 NSLog(@"%@",error);
                 fail();
             }
         }];
}

@end
