//
//  ControllersManager.m
//  Hromadske
//
//  Created by Admin on 16.03.15.
//  Copyright (c) 2015 Semeniuk Sviatoslav. All rights reserved.
//

#import "ControllersManager.h"

@implementation ControllersManager

+ (ControllersManager *)sharedManager {
    static ControllersManager *__manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __manager = [[ControllersManager alloc] init];
    });
    
    return __manager;
}


-(UINavigationController *)createNavigationControllerWithIdentifier:(NSString *)identifier
{
    return [[self createStoryboard] instantiateViewControllerWithIdentifier:identifier];
}

-(NewsDetailsViewController *)createNewsDetailsViewControllerWithArticle:(id)article
{
    NewsDetailsViewController *viewController = [[self createStoryboard] instantiateViewControllerWithIdentifier:@"NewsDetails"];
    [viewController setContent:article];
    return viewController;
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
