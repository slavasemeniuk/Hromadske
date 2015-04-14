//
//  NewsViewController.m
//  Hromadske
//
//  Created by Admin on 16.03.15.
//  Copyright (c) 2015 Semeniuk Sviatoslav. All rights reserved.
//

#import "NewsViewController.h"
#import "DataManager.h"
#import "NewsTableViewCell.h"
#import "Articles.h"


@interface NewsViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *_tableViewsData;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) UIRefreshControl *refresh;

@end

@implementation NewsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUpCell];
    [self setUpRefresh];
    [self refreshData];
    
    _tableViewsData = [[DataManager sharedManager] fetchListOfArticles];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_tableViewsData count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsTableViewCell *newsCell = [tableView dequeueReusableCellWithIdentifier:@"NewsCell" forIndexPath:indexPath];
    Articles *article = [_tableViewsData objectAtIndex:indexPath.row];
    [newsCell.title setText:article.title];
    [newsCell.shortDescription setText:article.short_description];
    
//    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:article.]
//                                                  cachePolicy:NSURLRequestReturnCacheDataElseLoad
//                                              timeoutInterval:60];
//    [cell.imageview setImageWithURLRequest:imageRequest placeholderImage:[UIImage imageNamed:@"placeholder"] success:nil failure:nil];
    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
//    
//    [newsCell.createdAt setText:[dateFormatter stringFromDate: article.created_at]];
     return newsCell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsTableViewCell *prototypecell = [tableView dequeueReusableCellWithIdentifier:@"NewsCell"];
//    Articles *article = [_tableViewsData objectAtIndex:indexPath.row];
//    
//    [prototypecell.shortDescription setText:article.short_description];
//    //prototypecell.imagesView ;
//    
//    [prototypecell setNeedsLayout];
//    [prototypecell layoutIfNeeded];
    
    return [prototypecell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height+1.0f;
}


-(void)setUpCell
{
    [_tableView registerNib:[UINib nibWithNibName:@"NewsTableViewCell" bundle:nil] forCellReuseIdentifier:@"NewsCell"];
}

-(void)setUpRefresh
{
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    _refresh=refresh;
    [_tableView addSubview:_refresh];
}

-(void)refreshData {
    [_refresh beginRefreshing];
    [[DataManager sharedManager] newsWithCompletion:^(NSArray *articles){
       // _tableViewsData = articles;
        [_refresh endRefreshing];
        _refresh=nil;
        [_refresh removeFromSuperview];
        [_tableView reloadData];
    }];
}

@end
