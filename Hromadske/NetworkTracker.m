//
//  NetworkTracker.m
//  Hromadske
//
//  Created by Admin on 24.04.15.
//  Copyright (c) 2015 Semeniuk Sviatoslav. All rights reserved.
//

#import "NetworkTracker.h"
#import "Constants.h"
#import "Reachability.h"

@interface NetworkTracker()
{
    NetworkStatus _networkStatus;
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
        [self startNetworkTracker];
    }
    return self;
}

- (void)startNetworkTracker
{
    Reachability* reach = [Reachability reachabilityWithHostname:base_URL];
    
    reach.reachableBlock = ^(Reachability* reach) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _networkStatus = reach.currentReachabilityStatus;
            NSLog(@"REACHABLE!");
        });
    };
    
    reach.unreachableBlock = ^(Reachability* reach) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"UNREACHABLE!");
            _networkStatus = reach.currentReachabilityStatus;
        });
    };
    [reach startNotifier];
}

- (NetworkStatus)status
{
    return _networkStatus;
}

+ (BOOL)isReachable
{
    NetworkStatus status = [[NetworkTracker sharedManager] status];
    if (status != 0) {
        return YES;
    }
    return NO;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
