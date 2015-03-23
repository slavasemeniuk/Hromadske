//
//  TeamViewController.m
//  Hromadske
//
//  Created by Admin on 16.03.15.
//  Copyright (c) 2015 Semeniuk Sviatoslav. All rights reserved.
//

#import "TeamViewController.h"
#import "TeamViewCell.h"
#import "DataManager.h"
#import <SWRevealViewController/SWRevealViewController.h>

@interface TeamViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *_team;
}
@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuButton;

@end

@implementation TeamViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpMenu];
    [self getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



-(void)setUpMenu
{
    [self.menuButton setTarget:self.revealViewController];
    [self.menuButton setAction:@selector(revealToggle:)];
    [self.view addGestureRecognizer: self.revealViewController.panGestureRecognizer];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_team count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TeamViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TeamCell" forIndexPath:indexPath];
    return cell;
}

-(void)getData
{
    _team = [[DataManager sharedManager] getTeam];
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
