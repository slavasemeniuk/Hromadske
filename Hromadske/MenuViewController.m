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
{
    NSArray *_menuItems;
    NSArray *_arrayOfIdentifier;
}

@end

@implementation MenuViewController



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
    
    cell.textLabel.text = [_menuItems objectAtIndex:indexPath.row];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.revealViewController pushFrontViewController: [[ControllersManager sharedManager] createNavigationViewControllerWithIdentifier:[_arrayOfIdentifier objectAtIndex:indexPath.row]] animated:YES];
}

-(void) setUpViewController
{
        _menuItems=@[@"Новини",@"Команда",@"Допомогти",@"Контакти"];
    _arrayOfIdentifier = @[@"News", @"Team", @"HelpProject", @"Contacts"];
}

@end
