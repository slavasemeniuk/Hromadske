//
//  ControllersManager.h
//  Hromadske
//
//  Created by Admin on 16.03.15.
//  Copyright (c) 2015 Semeniuk Sviatoslav. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MenuViewController.h"
#import "NewsDetailsViewController.h"
#import "NewsDetailsLocalViewController.h"

@interface ControllersManager : NSObject

+(ControllersManager *)sharedManager;

-(UINavigationController *)createNavigationControllerWithIdentifier: (NSString *) indentifier;

-(NewsDetailsViewController *)createNewsDetailsViewControllerWithArticle: (id) article;

-(NewsDetailsLocalViewController *)createLocalNewsDetailsViewControllerWithArticle:(id) article;

-(MenuViewController *)createMenuViewController;

- (UINavigationController *) newsNavigationController;

@end
