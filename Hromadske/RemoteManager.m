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


- (void) parsedJsonWithEndOfURL:(NSString *)urlEnd :(void (^)(NSArray * parsedObject))successCallback
{
    NSString *urlForRequest = [NSString stringWithFormat:@"%@%@",API_URL,urlEnd];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlForRequest]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess: ^(AFHTTPRequestOperation *operation, id responseObject) {
        successCallback([NSArray arrayWithArray:responseObject[@"data"]]);
        
    }failure:^(AFHTTPRequestOperation *operation,NSError *error){
        
        UIAlertView *allertView = [[UIAlertView alloc]initWithTitle:@"Error Retrieving" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [allertView show];
        
    }];
    [operation start];
}

- (void) parsedJsonWithTimeSync:(NSString *)date andUrlEnd:(NSString * )urlEnd :(void (^)(NSArray *))successCallback
{
    NSString *urlForRequest = [NSString stringWithFormat:@"%@%@",API_URL,urlEnd];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlForRequest parameters:@{@"sync_date":date} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        successCallback([NSArray arrayWithArray:responseObject[@"data"]]);
    }
         failure:^(AFHTTPRequestOperation *operation,NSError *error){
             
             UIAlertView *allertView = [[UIAlertView alloc]initWithTitle:@"Error Retrieving" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
             [allertView show];
             
         }];
}

- (void) parsedArticleWithId:(NSNumber *)identifire :(void (^)(NSDictionary *))successCallback
{
    NSString *urlEnd = [NSString stringWithFormat:@"articles/%d",[identifire intValue]];
    NSString *urlForRequest = [NSString stringWithFormat:@"%@%@",API_URL,urlEnd];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlForRequest parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        successCallback([NSDictionary dictionaryWithDictionary:responseObject[@"data"]]);
    }
         failure:^(AFHTTPRequestOperation *operation,NSError *error){
             
             UIAlertView *allertView = [[UIAlertView alloc]initWithTitle:@"Error Retrieving" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
             [allertView show];
             
         }];
}



@end
