//
//  MenuViewController.m
//  Hromadske
//
//  Created by Admin on 16.03.15.
//  Copyright (c) 2015 Semeniuk Sviatoslav. All rights reserved.
//

#import "MenuViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <SWRevealViewController/SWRevealViewController.h>
#import "ControllersManager.h"
#import "MenuItemCell.h"
#import "RateAndWeather.h"
#import "DataManager.h"

@interface MenuViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *_menuItems;
    NSArray *_arrayOfIdentifier;
    NSArray *_listOfIcon;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *temperature;
@property (weak, nonatomic) IBOutlet UILabel *eurRate;
@property (weak, nonatomic) IBOutlet UILabel *usdRate;

@end

@implementation MenuViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpViewController];
    [self refreshData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"refreshMenuNotification" object:nil];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _menuItems.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    MenuItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"menu_cell" forIndexPath:indexPath];
    
    [cell.title setText:[_menuItems objectAtIndex:indexPath.row]];
    [cell.icon setImage:[UIImage imageNamed:[_listOfIcon objectAtIndex:indexPath.row]]];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.revealViewController pushFrontViewController: [[ControllersManager sharedManager] createNavigationControllerWithIdentifier:[_arrayOfIdentifier objectAtIndex:indexPath.row]] animated:YES];
}

-(void) setUpViewController
{
    [self gradientBackground];
    [_tableView registerNib:[UINib nibWithNibName:@"MenuItemCell" bundle:nil] forCellReuseIdentifier:@"menu_cell"];

    _listOfIcon = @[@"menu-items-news",@"menu-items-team",@"menu-donate",@"menu-contacts"];
        _menuItems=@[@"Новини",@"Команда",@"Допомогти проекту",@"Контакти"];
    _arrayOfIdentifier = @[@"News", @"Team", @"HelpProject", @"Contacts"];
}

-(void)refreshData{
    RateAndWeather *data = [[DataManager sharedManager]getRateAndWeather];
    [_usdRate setText:[NSString stringWithFormat:@"USD %@",data.rateUSD]];
    [_eurRate setText:[NSString stringWithFormat:@"EUR %@",data.rateEUR]];
    [_temperature setText:[NSString stringWithFormat:@"%@°",data.weather]];
}

-(void)gradientBackground{
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame=self.view.bounds;
    UIColor *leftColor = [UIColor colorWithRed:74.0f/255.0f green:75.0f/255.0f blue:89.0f/255.0f alpha:1.0f];
    UIColor *rightColor = [UIColor colorWithRed:167.0f/255.0f green:157.0f/255.0f blue:161.0f/255.0f alpha:1.0f];
    gradient.startPoint = CGPointMake(0.0f, 0.5f);
    gradient.endPoint = CGPointMake(1.0f, 0.5f);    
    gradient.colors=[NSArray arrayWithObjects:(id)leftColor.CGColor,rightColor.CGColor, nil];
    [self.view.layer insertSublayer:gradient atIndex:0];
    _tableView.backgroundView.alpha = 0.0f;
    
}

@end
