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

- (void) parsedTeam:(void (^)(id jsonResponse)) successCallback
{
    __block NSArray *parsedObject =[[NSArray alloc]init];
    static NSString * const urlSrting = @"http://hromadske.cherkasy.ua/?option=com_hromadskeapi&category=team";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlSrting]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess: ^(AFHTTPRequestOperation *operation, id responseObject) {
        
        parsedObject = [NSArray arrayWithArray:responseObject[@"result"]];
        successCallback(parsedObject);
        
    }failure:^(AFHTTPRequestOperation *operation,NSError *error){
        
        UIAlertView *allertView = [[UIAlertView alloc]initWithTitle:@"Error Retrieving" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [allertView show];
        
    }];
    [operation start];
}

@end
