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

- (void) parsedTeam:(void (^)(NSArray *parsedTeam))successCallback
{
    static NSString * const urlSrting = @"http://hromadske.cherkasy.ua/?option=com_hromadskeapi&category=team";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlSrting]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess: ^(AFHTTPRequestOperation *operation, id responseObject) {
        
        successCallback([NSArray arrayWithArray:responseObject[@"result"]]);
        
    }failure:^(AFHTTPRequestOperation *operation,NSError *error){
        
        UIAlertView *allertView = [[UIAlertView alloc]initWithTitle:@"Error Retrieving" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [allertView show];
        
    }];
    [operation start];
}

- (void) parseHelpData:(void (^)(NSArray *parsedHelpData))successCallback
{
    static NSString * const urlSrting = @"/api/v1/info/donate.json";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlSrting]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess: ^(AFHTTPRequestOperation *operation, id responseObject) {
        
        successCallback([NSArray arrayWithArray:responseObject[@"result"]]);
        
    }failure:^(AFHTTPRequestOperation *operation,NSError *error){
        
        UIAlertView *allertView = [[UIAlertView alloc]initWithTitle:@"Error Retrieving" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [allertView show];
        
    }];
    [operation start];
}
@end
