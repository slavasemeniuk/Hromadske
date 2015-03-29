//
//  EmployerDeteilsViewController.m
//  Hromadske
//
//  Created by Admin on 28.03.15.
//  Copyright (c) 2015 Semeniuk Sviatoslav. All rights reserved.
//

#import "EmployerDetailsViewController.h"

@interface EmployerDetailsViewController ()

@end

@implementation EmployerDetailsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpBar];
    // Do any additional setup after loading the view.
}


-(void)setUpBar
{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStyleDone target:nil action:@selector(goToRootViewController)];
    self.navigationItem.backBarButtonItem=backButton;
}

-(void) goToRootViewController
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
