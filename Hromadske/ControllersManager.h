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

-(UINavigationController *)createNavigationViewControllerWithIdentifier: (NSString *) indentifier;

-(MenuViewController *)createMenuViewController;



@end
