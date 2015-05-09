//
//  MenuViewController.m
//  Hromadske
//
//  Created by Admin on 16.03.15.
//  Copyright (c) 2015 Semeniuk Sviatoslav. All rights reserved.
//

#import "MenuViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ControllersManager.h"
#import "MenuItemCell.h"
#import "RateAndWeather.h"
#import "DataManager.h"
#import <iRate/iRate.h>

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
@property (weak, nonatomic) IBOutlet UILabel *version;

@end

@implementation MenuViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpViewController];
    [self refreshData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"DigestUpdated" object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}

-(void) setUpViewController
{
    [self gradientBackground];
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    _version.text = [NSString stringWithFormat:@"Версія %@",appVersion];

    [_tableView registerNib:[UINib nibWithNibName:@"MenuItemCell" bundle:nil] forCellReuseIdentifier:@"menu_cell"];
    
    _listOfIcon = @[@"menu-items-news",@"menu-items-team",@"menu-donate",@"menu-contacts", @"menu-item-rate"];
    _menuItems=@[@"Новини",@"Команда",@"Допомогти проекту",@"Контакти",@"Оцінити"];
    _arrayOfIdentifier = @[ @"NewsViewController", @"TeamViewController", @"HelpProjectViewController", @"ContactsViewController"];
}

-(void)refreshData{
    RateAndWeather *data = [[DataManager sharedManager]getRateAndWeather];
    NSString *format = [NSString stringWithFormat:@"%.02f",[data.rateUSD floatValue]];
    [_usdRate setText:format];
    format = [NSString stringWithFormat:@"%.02f",[data.rateEUR floatValue]];
    [_eurRate setText:format];
    [_temperature setText:[NSString stringWithFormat:@"%@",data.weather]];
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
    if (indexPath.row!=4) {
        NSString *identefier = [_arrayOfIdentifier objectAtIndex:indexPath.row];
        [[ControllersManager sharedManager] showTopViewControllerWithIdentefier:identefier];
    }else{
        [[iRate sharedInstance] openRatingsPageInAppStore];
        [iRate sharedInstance].ratedThisVersion=YES;
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
    
}


@end
