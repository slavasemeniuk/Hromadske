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
    NSString* currentSubtitle;
    
    BOOL _isShowingList;
    BOOL _showRotateAnimation;
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
    
    currentSubtitle = @"Всі новини";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //    [[DataManager sharedManager] fetchRemoteDigestWithCompletion:^{
    //        [self refreshData];
    //    } fail:nil];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}

- (void)setUpViewController
{
    NSString* appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    _version.text = [NSString stringWithFormat:@"Версія %@", appVersion];
    
    [_tableView registerNib:[UINib nibWithNibName:@"MenuItemCell" bundle:nil] forCellReuseIdentifier:@"menu_cell"];
    
    _newsCatagorySec = [NSMutableArray arrayWithArray:@[ @"Новини", @"Всі новини" ]];
    
    [_newsCatagorySec addObjectsFromArray:[DataManager getCategories]];
    
    
    _menuItems = @[ @"Допомогти проекту", @"Команда", @"Контакти", @"Оцінити" ];
    _listOfMenuIcon = @[ @"menu-donate", @"menu-items-team", @"menu-contacts", @"menu-item-rate" ];
    _arrayOfIdentifier = @[ @"HelpProjectViewController", @"TeamViewController", @"ContactsViewController" ];
}

- (void)refreshData
{
    NSString* format = [NSString stringWithFormat:@"%.02f", [[[DataManager sharedManager] rateAndWeather].rateUSD floatValue]];
    [_usdRate setText:format];
    format = [NSString stringWithFormat:@"%.02f", [[[DataManager sharedManager] rateAndWeather].rateEUR floatValue]];
    [_eurRate setText:format];
    [_temperature setText:[NSString stringWithFormat:@"%@", [[DataManager sharedManager] rateAndWeather].weather]];
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

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section == 0 && indexPath.row != 0) {
        return 35;
    }
    return 45;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    
    MenuItemCell* cell = [tableView dequeueReusableCellWithIdentifier:@"menu_cell" forIndexPath:indexPath];
    if (indexPath.section != 0) {
        [cell.title setText:[_menuItems objectAtIndex:indexPath.row]];
        [cell.icon setImage:[UIImage imageNamed:[_listOfMenuIcon objectAtIndex:indexPath.row]]];
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!_isShowingList) {
                    UIImage* toImage = [UIImage imageNamed:@"arrow_down"];
                    [UIView transitionWithView:cell.rightImageView
                                      duration:0.35
                                       options:UIViewAnimationOptionTransitionFlipFromBottom
                                    animations:^{
                                        cell.rightImageView.image = toImage;
                                    }
                                    completion:NULL];
                }
                else {
                    UIImage* toImage = [UIImage imageNamed:@"arrow_up"];
                    [UIView transitionWithView:cell.rightImageView
                                      duration:0.35
                                       options:UIViewAnimationOptionTransitionFlipFromTop
                                    animations:^{
                                        cell.rightImageView.image = toImage;
                                    }
                                    completion:NULL];
                }
                
            });
            [cell.icon setImage:[UIImage imageNamed:@"menu-items-news"]];
            [cell.title setText:[_newsCatagorySec objectAtIndex:indexPath.row]];
            [cell.subTitle setText:currentSubtitle];
        }
        else {
            [cell.icon setImage:[UIImage imageNamed:@"white_dot"]];
            [cell.subTitle setText:[_newsCatagorySec objectAtIndex:indexPath.row]];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    MenuItemCell* cell = (MenuItemCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        _isShowingList = !_isShowingList;
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        return;
    }
    
    if (indexPath.section == 0 && indexPath.row != 0) {
        [DataManager sharedManager].articleCategory = currentSubtitle = cell.subTitle.text;
        [tableView reloadRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:0 inSection:0] ] withRowAnimation:UITableViewRowAnimationTop];
        _isShowingList = false;
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        [[ControllersManager sharedManager] showTopViewControllerWithIdentefier:@"NewsViewController"];
    }
    if (_isShowingList) {
        _isShowingList = !_isShowingList;
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    }
    if (indexPath.section == 1) {
        if (indexPath.row != 3) {
            NSString* identefier = [_arrayOfIdentifier objectAtIndex:indexPath.row];
            [[ControllersManager sharedManager] showTopViewControllerWithIdentefier:identefier];
        }
        else {
            [[iRate sharedInstance] openRatingsPageInAppStore];
            [iRate sharedInstance].ratedThisVersion = YES;
        }
    }
}
@end
