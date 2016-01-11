//
//  BaseViewController.m
//  Hromadske
//
//  Created by Admin on 30.03.15.
//  Copyright (c) 2015 Semeniuk Sviatoslav. All rights reserved.
//

#import "BaseViewController.h"
#import "ControllersManager.h"
#import <SWRevealViewController/SWRevealViewController.h>

@interface BaseViewController () <SWRevealViewControllerDelegate>

@end

@implementation BaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpMenuButton];
    [ControllersManager sharedManager].revealController.delegate = self;
}

- (void)setUpMenuButton
{
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu-icon"] style:UIBarButtonItemStyleDone target:self.revealViewController action:@selector(revealToggle:)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor blackColor]];
}


- (BOOL)shouldAutorotate
{
    return NO;
}


#if __IPHONE_OS_VERSION_MAX_ALLOWED < 90000
- (NSUInteger)supportedInterfaceOrientations
#else
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
#endif
{
    return UIInterfaceOrientationMaskPortrait;
}

//Should be overriden in subclasses
- (void)disableUserInteractionInViews {}

-(void)enableUserInteractionInViews {}

#pragma mark RevealControllerDelegate
- (void)revealController:(SWRevealViewController *)revealController willMoveToPosition:(FrontViewPosition)position{
    if(position == FrontViewPositionLeft) {
         [self enableUserInteractionInViews];
   
    } else {
            [self disableUserInteractionInViews];
    }

}

- (void) revealController:(SWRevealViewController *)revealController didMoveToPosition:(FrontViewPosition)position{
    if(position == FrontViewPositionLeft) {
        [self enableUserInteractionInViews];
        
    } else {
        [self disableUserInteractionInViews];
    }
}




@end
