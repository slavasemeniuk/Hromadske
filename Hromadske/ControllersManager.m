//
//  ControllersManager.m
//  Hromadske
//
//  Created by Admin on 16.03.15.
//  Copyright (c) 2015 Semeniuk Sviatoslav. All rights reserved.
//

#import "ControllersManager.h"

#import "NewsViewController.h"
#import "TeamViewController.h"
#import "ContactsViewController.h"
#import "HelpProjectViewController.h"

@interface ControllersManager ()

@property (strong , nonatomic) NewsViewController * newsViewController;
@property (strong , nonatomic) SWRevealViewController * revealViewController;

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

- (UIStoryboard *)storyboard
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    return storyboard;
}

- (SWRevealViewController *) revealController {
    if (!_revealViewController) {
        _revealViewController = [[SWRevealViewController alloc] initWithRearViewController:[self menu] frontViewController:nil];
        [self.revealViewController setRearViewRevealWidth:[self menu].view.frame.size.width-40.0f];

        UIViewController *news = [self topViewControllerWithIdentefier:NSStringFromClass([NewsViewController class])];
        _revealViewController.frontViewController = news;
    }
    return _revealViewController;
}

- (MenuViewController *) menu {
    return (MenuViewController *)[self viewControllerWithIdentefier:NSStringFromClass([MenuViewController class])];
}

- (UINavigationController *) topViewControllerWithIdentefier:(NSString*)identefier {
    
    UIViewController *controller = [self viewControllerWithIdentefier:identefier];
    [controller.view addGestureRecognizer: [self revealController].panGestureRecognizer];
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:controller];
    
    return navigation;
}

- (UIViewController *) viewControllerWithIdentefier:(NSString*)identefier {
    
    UIViewController *controller = nil;
    
    if ([identefier isEqual:NSStringFromClass([NewsViewController class])]) {
        
        if (!_newsViewController) {
            _newsViewController = [[self storyboard] instantiateViewControllerWithIdentifier:identefier];
        }
        controller = _newsViewController;
    } else {
        controller = [[self storyboard] instantiateViewControllerWithIdentifier:identefier];
    }
    
    return controller;
}

- (void) showTopViewControllerWithIdentefier:(NSString *)identefier {
    UIViewController *controller = [self topViewControllerWithIdentefier:identefier];
    [[self revealController] pushFrontViewController:controller animated:YES];
}



@end
