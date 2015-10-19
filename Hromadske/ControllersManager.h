//
//  ControllersManager.h
//  Hromadske
//
//  Created by Admin on 16.03.15.
//  Copyright (c) 2015 Semeniuk Sviatoslav. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <SWRevealViewController/SWRevealViewController.h>
#import "MenuViewController.h"
#import "NewsDetailsViewController.h"


@interface ControllersManager : NSObject

@property (strong, nonatomic) SWRevealViewController* revealViewController;

+ (ControllersManager *)sharedManager;

- (SWRevealViewController *)revealController;

- (UIViewController *)viewControllerWithIdentefier:(NSString*)identefier;

- (void)showTopViewControllerWithIdentefier:(NSString *)identefier;

@end
