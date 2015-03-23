//
//  ControllersManager.m
//  Hromadske
//
//  Created by Admin on 16.03.15.
//  Copyright (c) 2015 Semeniuk Sviatoslav. All rights reserved.
//

#import "ControllersManager.h"
#import "TeamViewController.h"
#import "NewsViewController.h"
#include "HelpProjectViewController.h"
#import "ContactsViewController.h"

@interface ControllersManager ()
{
//offset.x for newsViewController
}

@end

@implementation ControllersManager

+(ControllersManager *)sharedManager
{
    static ControllersManager *__manager =nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        __manager = [[ControllersManager alloc] init];
    });
    
    return __manager;
}

-(UINavigationController *)createTeamViewController
{
    TeamViewController *teamViewController = [[self createStoryboard] instantiateViewControllerWithIdentifier:@"Team"];
    return [self controllersWithRoot:teamViewController];
}

-(UINavigationController *)createNewsViewController
{
    NewsViewController *newsViewController = [[self createStoryboard] instantiateViewControllerWithIdentifier:@"News"];
    return [self controllersWithRoot: newsViewController];
}

-(UINavigationController *)createContactsViewController
{
    ContactsViewController *contactViewController = [[self createStoryboard] instantiateViewControllerWithIdentifier:@"Contacts"];
    return [self controllersWithRoot:contactViewController];
}

-(UINavigationController *)createHelpViewController
{
    HelpProjectViewController *helpProjectViewController = [[self createStoryboard] instantiateViewControllerWithIdentifier:@"HelpProject"];
    return [self controllersWithRoot:helpProjectViewController];
}

-(MenuViewController *)createMenuViewController
{
    MenuViewController *menuViewController = [[self createStoryboard] instantiateViewControllerWithIdentifier:@"Menu"];
    return menuViewController;
}

-(UIStoryboard *)createStoryboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    return storyboard;
}

-(UINavigationController *)controllersWithRoot:(UIViewController *)controller
{
    return [[UINavigationController alloc] initWithRootViewController:controller];
}



@end
