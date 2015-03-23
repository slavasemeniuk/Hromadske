//
//  ControllersManager.h
//  Hromadske
//
//  Created by Admin on 16.03.15.
//  Copyright (c) 2015 Semeniuk Sviatoslav. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MenuViewController.h"

@interface ControllersManager : NSObject
{
}

+(ControllersManager *)sharedManager;

-(UINavigationController *)createNewsViewController;
-(UINavigationController *)createTeamViewController;
-(UINavigationController *)createContactsViewController;
-(UINavigationController *)createHelpViewController;

-(MenuViewController *)createMenuViewController;

-(UINavigationController *)controllersWithRoot: (UIViewController *)controller;

@end
