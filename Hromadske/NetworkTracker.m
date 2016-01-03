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
@property Reachability *reach;

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
    _reach = [Reachability reachabilityWithHostName:@"http://178.62.205.247"];
    [_reach startNotifier];
}

- (NetworkStatus)status
{
    return [_reach currentReachabilityStatus];
}

+ (BOOL)isReachable
{
    if([[NetworkTracker sharedManager] status] == NotReachable) {
        return NO;
    }
    return YES;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
