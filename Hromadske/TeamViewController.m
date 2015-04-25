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

@interface TeamViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *_tableViewsData;
    __weak IBOutlet UITableView *_tableView;
}

@end

@implementation TeamViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpCell];
    
    [[DataManager sharedManager] teamWithCompletion:^(NSArray *team) {
        _tableViewsData = team;
        [_tableView reloadData];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_tableViewsData count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TeamViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TeamCell" forIndexPath:indexPath];
    
    Employe *employe = [_tableViewsData objectAtIndex:indexPath.row];
    [cell.label setText: employe.name];
    [cell.bio setText:employe.bio];
    
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:employe.image]
                                                  cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                              timeoutInterval:60];
                                  [cell.imageview setImageWithURLRequest:imageRequest placeholderImage:[UIImage imageNamed:@"placeholder"] success:nil failure:nil];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    TeamViewCell *prototypecell = [tableView dequeueReusableCellWithIdentifier:@"TeamCell"];
    Employe *employe = [_tableViewsData objectAtIndex:indexPath.row];
    
    [prototypecell.bio setText:employe.bio];
    
    [prototypecell setNeedsLayout];
    [prototypecell layoutIfNeeded];
    
    return [prototypecell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    
}


-(void)setUpCell
{
     [_tableView registerNib:[UINib nibWithNibName:@"TeamViewCell" bundle:nil] forCellReuseIdentifier:@"TeamCell"];
}



@end
