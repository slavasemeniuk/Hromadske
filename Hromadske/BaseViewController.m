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
}

-(void)setUpMenuButton
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"itemsButtonIcon.png"] style:UIBarButtonItemStyleDone target:self.revealViewController action:@selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}


@end