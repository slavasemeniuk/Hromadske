//
//  TeamViewController.m
//  Hromadske
//
//  Created by Admin on 16.03.15.
//  Copyright (c) 2015 Semeniuk Sviatoslav. All rights reserved.
//

#import "TeamViewController.h"
#import "TeamViewCell.h"
#import "Employe.h"
#import "DataManager.h"
#import <UIImageView+AFNetworking.h>

@interface TeamViewController () <UITableViewDataSource, UITableViewDelegate> {
    NSArray* _tableViewsData;
    __weak IBOutlet UITableView* _tableView;
    TeamViewCell* _prototypecell;
}

@end

@implementation TeamViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpCell];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateData) name:@"refreshTeamNotification" object:nil];
    _tableView.estimatedRowHeight = 171.f;
    _prototypecell = [_tableView dequeueReusableCellWithIdentifier:@"TeamCell"];
    [[DataManager sharedManager] teamWithCompletion:^() {
        [self updateData];
    }];
}

- (void)updateData
{
    _tableViewsData = [[DataManager sharedManager] listOfEmployes];
    [_tableView reloadData];
}

#pragma mark - HandleUserInteratcionAccordingMenu

-(void)disableUserInteractionInViews{
    _tableView.userInteractionEnabled = NO;
}

-(void)enableUserInteractionInViews{
    _tableView.userInteractionEnabled = YES;
}

#pragma mark - TableViewDelegates
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_tableViewsData count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    TeamViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"TeamCell" forIndexPath:indexPath];

    Employe* employe = [_tableViewsData objectAtIndex:indexPath.row];
    [cell.label setText:employe.name];
    [cell.bio setText:employe.bio];
    NSURLRequest* imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:employe.image]
                                                  cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                              timeoutInterval:60];
    [cell.imageview setImageWithURLRequest:imageRequest placeholderImage:[UIImage imageNamed:@"avatar"] success:nil failure:nil];
    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    [_prototypecell.bio setText:[(Employe*)[_tableViewsData objectAtIndex:indexPath.row] bio]];

    [_prototypecell layoutIfNeeded];

    return [_prototypecell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
}

- (void)setUpCell
{
    [_tableView registerNib:[UINib nibWithNibName:@"TeamViewCell" bundle:nil] forCellReuseIdentifier:@"TeamCell"];
}


@end
