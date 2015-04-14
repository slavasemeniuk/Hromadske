//
//  RemoteManager.m
//  Hromadske
//
//  Created by Admin on 19.03.15.
//  Copyright (c) 2015 Semeniuk Sviatoslav. All rights reserved.
//

#import "RemoteManager.h"
#import <AFNetworking/AFNetworking.h>

@interface RemoteManager()

@end

static NSString * const basicUrlSrting = @"http://178.62.205.247/v1/";

@implementation RemoteManager
{
}

+ (RemoteManager *)sharedManager {
    static RemoteManager *__manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __manager = [[RemoteManager alloc] init];
    });
    
    return __manager;
}

- (void) parsedJsonWithEndOfURL:(NSString *)urlEnd :(void (^)(NSArray * parsedObject))successCallback
{
    NSString *urlForRequest = [NSString stringWithFormat:@"%@%@",basicUrlSrting,urlEnd];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlForRequest]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess: ^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *ar = [NSArray arrayWithArray:responseObject[@"data"]];
        successCallback([NSArray arrayWithArray:responseObject[@"data"]]);
        
    }failure:^(AFHTTPRequestOperation *operation,NSError *error){
        
        UIAlertView *allertView = [[UIAlertView alloc]initWithTitle:@"Error Retrieving" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [allertView show];
        
    }];
    [operation start];
}

@end
