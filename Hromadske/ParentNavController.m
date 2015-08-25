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
- (NSUInteger)supportedInterfaceOrientations
{
    return self.topViewController.supportedInterfaceOrientations;
}

@end
