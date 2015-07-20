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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpMenuButton];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)setUpMenuButton
{
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu-icon"] style:UIBarButtonItemStyleDone target:self.revealViewController action:@selector(revealToggle:)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor blackColor]];
}

@end
