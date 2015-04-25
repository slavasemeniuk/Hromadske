//
//  NetworkTracker.m
//  Hromadske
//
//  Created by Admin on 24.04.15.
//  Copyright (c) 2015 Semeniuk Sviatoslav. All rights reserved.
//

#import "NetworkTracker.h"
#import "Constants.h"
#import <AFNetworking/AFNetworking.h>

@interface NetworkTracker()
{
    AFNetworkReachabilityStatus _networkStatus;
}

@end
@implementation NetworkTracker


+ (NetworkTracker *)sharedManager {
    static NetworkTracker *__manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __manager = [[NetworkTracker alloc] init];
    });
    
    return __manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUp];
    }
    return self;
}

-(void)setUp{
    _networkStatus = AFNetworkReachabilityStatusNotReachable;
    [self startNetworkTracker];
}

-(void)startNetworkTracker
{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:[NSURL URLWithString:API_URL]];
    
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status){
        _networkStatus=status;
        if ([NetworkTracker isReachable]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"checkDigest" object:nil];
        }
    }];
    [manager.reachabilityManager startMonitoring];
}

-(AFNetworkReachabilityStatus) status{
    return _networkStatus;
}

+ (BOOL)isReachable
{
    AFNetworkReachabilityStatus status = [[NetworkTracker sharedManager] status];
    if ((status==AFNetworkReachabilityStatusReachableViaWiFi) || (status==AFNetworkReachabilityStatusReachableViaWWAN)) {
        return YES;
    }
    return NO;
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


@end
