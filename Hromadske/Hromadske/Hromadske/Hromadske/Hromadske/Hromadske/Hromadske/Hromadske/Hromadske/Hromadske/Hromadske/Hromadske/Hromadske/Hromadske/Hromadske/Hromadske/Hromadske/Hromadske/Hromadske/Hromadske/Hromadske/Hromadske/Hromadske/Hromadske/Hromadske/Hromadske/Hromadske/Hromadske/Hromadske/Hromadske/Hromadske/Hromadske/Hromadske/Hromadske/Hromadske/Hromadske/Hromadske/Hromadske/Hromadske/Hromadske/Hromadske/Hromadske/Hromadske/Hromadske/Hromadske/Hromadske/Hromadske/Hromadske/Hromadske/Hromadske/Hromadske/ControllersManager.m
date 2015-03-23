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
    UIStoryboard *_storyboard;
    TeamViewController *_team;
    NewsViewController *_news;
    MenuViewController *_menu;
    HelpProjectViewController *_helpcontroller;
    ContactsViewController *_contacts;
    UINavigationController *_newsNavigation;
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

-(id)init
{
    self =[super init];
    if (self) {
        [self setUp];
    }
    return self;
}

-(void)setUp
{
    if (!_storyboard) {
        _storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    }
}

-(UIStoryboard *)storyboard
{
    return _storyboard;
}

-(UINavigationController *)team
{
    if (!_team) {
        _team = [_storyboard instantiateViewControllerWithIdentifier:@"Team"];
    }
    return [self controllersWithRoot:_team];
}

-(UINavigationController *)news
{
    if (!_news) {
        _news=[_storyboard instantiateViewControllerWithIdentifier:@"News"];
    }
    _newsNavigation = [self controllersWithRoot:_news];
    return _newsNavigation;
}

-(UINavigationController *)contacts
{
    if (!_contacts) {
        _news=[_storyboard instantiateViewControllerWithIdentifier:@"Contacts"];
    }
    _newsNavigation = [self controllersWithRoot:_news];
    return _newsNavigation;
}

-(UINavigationController *)helpcontroller
{
    if (!_helpcontroller) {
        _news=[_storyboard instantiateViewControllerWithIdentifier:@"HelpProject"];
    }
    _newsNavigation = [self controllersWithRoot:_news];
    return _newsNavigation;
}

-(MenuViewController *)menu
{
    if (!_menu) {
        _menu = [_storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    return _menu;
}


-(UINavigationController *)controllersWithRoot:(UIViewController *)controller
{
    return [[UINavigationController alloc] initWithRootViewController:controller];
}



@end
