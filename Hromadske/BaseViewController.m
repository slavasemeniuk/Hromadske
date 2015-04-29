//
//  BaseViewController.m
//  Hromadske
//
//  Created by Admin on 30.03.15.
//  Copyright (c) 2015 Semeniuk Sviatoslav. All rights reserved.
//

#import "BaseViewController.h"
#import <SWRevealViewController/SWRevealViewController.h>


@interface BaseViewController ()
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpMenuButton];
    UIView *addStatusBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.navigationController.navigationBar.frame.size.width, 20)];
    addStatusBar.backgroundColor = [UIColor colorWithRed:253.0f/255.0f green:123.0f/255.0f blue:40.0f/255.0f alpha:1];
    [self.navigationController.navigationBar.window addSubview:addStatusBar];

}

-(void)setUpMenuButton
{
    self.navigationController.navigationBar.barTintColor=[UIColor whiteColor];
    self.navigationController.navigationBar.tintColor=[UIColor blackColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu-icon"] style:UIBarButtonItemStyleDone target:self.revealViewController action:@selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}


@end
