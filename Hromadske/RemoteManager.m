//
//  RemoteManager.m
//  Hromadske
//
//  Created by Admin on 19.03.15.
//  Copyright (c) 2015 Semeniuk Sviatoslav. All rights reserved.
//

#import "RemoteManager.h"
#import "Constants.h"
#import <RestKit/RestKit.h>


@implementation RemoteManager

+ (RemoteManager *)sharedManager {
    static RemoteManager *__manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __manager = [[RemoteManager alloc] init];
    });
    
    return __manager;
}

+ (void)getEmployees {
    [[RKObjectManager sharedManager] getObjectsAtPath:TEAM_JSON parameters:nil success:nil failure:nil];
}

@end
