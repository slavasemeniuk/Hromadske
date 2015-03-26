//
//  MenuViewController.m
//  Hromadske
//
//  Created by Admin on 16.03.15.
//  Copyright (c) 2015 Semeniuk Sviatoslav. All rights reserved.
//

#import "MenuViewController.h"
#import <SWRevealViewController/SWRevealViewController.h>
#import "ControllersManager.h"

@interface MenuViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation MenuViewController
{
    NSArray *_menuItems;
    NSArray *_arrayOfIdentifier;
    ControllersManager *_controllersManager;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpViewController];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _menuItems.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    cell.textLabel.textColor = [UIColor orangeColor];
    cell.textLabel.text = [_menuItems objectAtIndex:indexPath.row];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.revealViewController pushFrontViewController: [_controllersManager createNavigationViewControllerWithIdentifier:[_arrayOfIdentifier objectAtIndex:indexPath.row]] animated:YES];
}

-(void) setUpViewController
{
    _controllersManager = [[ControllersManager alloc] init];
    _menuItems=@[@"News",@"Team",@"Help",@"Contacts"];
    _arrayOfIdentifier = @[@"News", @"Team", @"HelpProject", @"Contacts"];
}

@end
