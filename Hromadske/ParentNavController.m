//
//  ParentNavController.m
//  Greg Boyd
//
//  Created by Device Ekreative on 20/08/2015.
//  Copyright (c) 2015 eKreative. All rights reserved.
//

#import "ParentNavController.h"

@implementation ParentNavController

- (BOOL)shouldAutorotate
{
    return self.topViewController.shouldAutorotate;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED < 90000
- (NSUInteger)supportedInterfaceOrientations
#else
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
#endif
{
    return self.topViewController.supportedInterfaceOrientations;
}

@end
