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
#import "HelpProjectViewController.h"
#import "ContactsViewController.h"

@interface ControllersManager ()
{
}

@end

@implementation ControllersManager

+ (ControllersManager *)sharedManager {
    static ControllersManager *__manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __manager = [[ControllersManager alloc] init];
    });
    
    return __manager;
}


-(UINavigationController *)createNavigationViewControllerWithIdentifier:(NSString *)identifier
{
    return [[self createStoryboard] instantiateViewControllerWithIdentifier:identifier];

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



@end
