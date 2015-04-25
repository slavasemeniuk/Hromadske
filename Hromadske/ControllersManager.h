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

@interface ControllersManager : NSObject

+(ControllersManager *)sharedManager;

-(UINavigationController *)createNavigationControllerWithIdentifier: (NSString *) indentifier;

-(NewsDetailsViewController *)createNewsDetailsViewControllerWithArticle: (id) article;
-(MenuViewController *)createMenuViewController;



@end
