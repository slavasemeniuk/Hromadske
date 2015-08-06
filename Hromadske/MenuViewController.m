//
//  MenuViewController.m
//  Hromadske
//
//  Created by Admin on 16.03.15.
//  Copyright (c) 2015 Semeniuk Sviatoslav. All rights reserved.
//

#import "MenuViewController.h"
#import "ControllersManager.h"
#import "MenuItemCell.h"
#import "RateAndWeather.h"
#import "DataManager.h"
#import <iRate/iRate.h>

@interface MenuViewController () <UITableViewDelegate, UITableViewDataSource> {
    NSArray* _menuItems;
    NSArray* _arrayOfIdentifier;
    NSArray* _listOfMenuIcon;
    NSMutableArray* _newsCatagorySec;
    
    BOOL _isShowingList;
}
@property (weak, nonatomic) IBOutlet UITableView* tableView;
@property (weak, nonatomic) IBOutlet UILabel* temperature;
@property (weak, nonatomic) IBOutlet UILabel* eurRate;
@property (weak, nonatomic) IBOutlet UILabel* usdRate;
@property (weak, nonatomic) IBOutlet UILabel* version;

@end

@implementation MenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpViewController];
    [self refreshData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"DigestUpdated" object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setUpViewController
{
    NSString* appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    _version.text = [NSString stringWithFormat:@"Версія %@", appVersion];

    [_tableView registerNib:[UINib nibWithNibName:@"MenuItemCell" bundle:nil] forCellReuseIdentifier:@"menu_cell"];

    _newsCatagorySec = [NSMutableArray arrayWithArray:@[ @"Новини", @"Всі новини" ]];
    [_newsCatagorySec addObjectsFromArray:[[DataManager sharedManager] getCategories]];

    _menuItems = @[ @"Допомогти проекту", @"Команда", @"Контакти", @"Оцінити" ];
    _listOfMenuIcon = @[ @"menu-donate", @"menu-items-team", @"menu-contacts", @"menu-item-rate" ];
    _arrayOfIdentifier = @[ @"HelpProjectViewController", @"TeamViewController", @"ContactsViewController" ];
}

- (void)refreshData
{
    RateAndWeather* data = [[DataManager sharedManager] getRateAndWeather];
    NSString* format = [NSString stringWithFormat:@"%.02f", [data.rateUSD floatValue]];
    [_usdRate setText:format];
    format = [NSString stringWithFormat:@"%.02f", [data.rateEUR floatValue]];
    [_eurRate setText:format];
    [_temperature setText:[NSString stringWithFormat:@"%@", data.weather]];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 && _isShowingList) {
        return _newsCatagorySec.count;
    }
    else if (section == 0 && !_isShowingList)
        return 1;
    else
        return _menuItems.count;
}

- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"";
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{

    MenuItemCell* cell = [tableView dequeueReusableCellWithIdentifier:@"menu_cell" forIndexPath:indexPath];
    if (indexPath.section != 0) {
        [cell.title setText:[_menuItems objectAtIndex:indexPath.row]];
        [cell.icon setImage:[UIImage imageNamed:[_listOfMenuIcon objectAtIndex:indexPath.row]]];
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0)
            [cell.icon setImage:[UIImage imageNamed:@"menu-items-news"]];
        [cell.title setText:[_newsCatagorySec objectAtIndex:indexPath.row]];
    }

    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        _isShowingList = !_isShowingList;
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
    if (indexPath.section == 0 && indexPath.row != 0) {
        MenuItemCell* cell = (MenuItemCell*)[tableView cellForRowAtIndexPath:indexPath];
        [DataManager sharedManager].articleCategory = cell.title.text;
        [[ControllersManager sharedManager] showTopViewControllerWithIdentefier:@"NewsViewController"];
    }
    if (indexPath.section == 1) {
        if (indexPath.row != 3) {
            NSString* identefier = [_arrayOfIdentifier objectAtIndex:indexPath.row];
            [[ControllersManager sharedManager] showTopViewControllerWithIdentefier:identefier];
        }
        else {
            [[iRate sharedInstance] openRatingsPageInAppStore];
            [iRate sharedInstance].ratedThisVersion = YES;
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
        }
    }
}

@end
