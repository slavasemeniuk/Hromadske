//
//  TeamViewController.m
//  Hromadske
//
//  Created by Admin on 16.03.15.
//  Copyright (c) 2015 Semeniuk Sviatoslav. All rights reserved.
//

#import "TeamViewController.h"
#import "TeamViewCell.h"
#import "RemoteManager.h"
#import <SWRevealViewController/SWRevealViewController.h>

@interface TeamViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *_tableViewsData;
    __weak IBOutlet UITableView *_tableView;
}


@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuButton;

@end

@implementation TeamViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpMenu];
    [self setUpCell];
    [self downloadDataAndReloadTableView];
}

-(void)setUpMenu
{
    [self.menuButton setTarget:self.revealViewController];
    [self.menuButton setAction:@selector(revealToggle:)];
    [self.view addGestureRecognizer: self.revealViewController.panGestureRecognizer];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_tableViewsData count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TeamViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TeamCell" forIndexPath:indexPath];
    [cell.label setText: [[_tableViewsData objectAtIndex:indexPath.row] valueForKey:@"title"]];
    NSURL *imageURL = [NSURL URLWithString:[[_tableViewsData objectAtIndex:indexPath.row] valueForKey:@"image"]];
    NSData *imageData = [[NSData alloc] initWithContentsOfURL:imageURL];
    cell.imageview.image = [UIImage imageWithData:imageData];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

-(void)setUpCell
{
     [_tableView registerNib:[UINib nibWithNibName:@"TeamViewCell" bundle:nil] forCellReuseIdentifier:@"TeamCell"];
}

-(void)downloadDataAndReloadTableView
{
    RemoteManager *remoteManager = [[RemoteManager alloc] init];
    [remoteManager parsedTeam:^(id jsonResponse){
        _tableViewsData = jsonResponse;
        [_tableView reloadData];
    }];
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
