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


-(UINavigationController *)createNavigationViewControllerWithIdentifier:(NSString *)identifier
{
    return [self controllersWithRoot:[[self createStoryboard] instantiateViewControllerWithIdentifier:identifier]];

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
