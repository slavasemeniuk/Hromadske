//
//  NetworkTracker.h
//  Hromadske
//
//  Created by Admin on 24.04.15.
//  Copyright (c) 2015 Semeniuk Sviatoslav. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkTracker : NSObject

+ (NetworkTracker *)sharedManager;

+ (BOOL)isReachable;

@end
