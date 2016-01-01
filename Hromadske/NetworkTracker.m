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
    Reachability* _reach;
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
    if (!_reach) {
        _reach = [Reachability reachabilityWithHostName:base_URL];
    }
    [_reach startNotifier];
}

- (NetworkStatus)status
{
    return [_reach isReachable];
}

+ (BOOL)isReachable
{
    return [[NetworkTracker sharedManager] status];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
