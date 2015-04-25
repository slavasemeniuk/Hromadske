//
//  NewsViewController.m
//  Hromadske
//
//  Created by Admin on 16.03.15.
//  Copyright (c) 2015 Semeniuk Sviatoslav. All rights reserved.
//

#import "NewsViewController.h"
#import <UIImageView+AFNetworking.h>
#import "NetworkTracker.h"
#import "DateFormatter.h"
#import "NewArticlesView.h"
#import "StreamView.h"
#import "ControllersManager.h"
#import "DataManager.h"
#import "NewsTableViewCell.h"
#import "Articles.h"
#import "Photo.h"


@interface NewsViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *_tableViewsData;
    NSInteger _newArticles;
    NSString *_stream;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation NewsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUpCell];
    [self setupNavBar];
    [self setUpData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"refreshDataNotification" object:nil];
    [self setUpStreamView];
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
    [newsCell.viewsCount setText:[article.views_count stringValue]];
    [newsCell.createdAt setText:[[DateFormatter sharedManager]convertDateFromTimeStamp:article.created_at]];
    
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[article getImageUrl]]
                                                  cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                              timeoutInterval:60];
    [newsCell.image_view setImageWithURLRequest:imageRequest placeholderImage:[UIImage imageNamed:@"placeholder"] success:nil failure:nil];
    
    
    if (indexPath.row<_newArticles) {
        [newsCell unviewed];
    };

     return newsCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NewsTableViewCell *prototypecell = [tableView dequeueReusableCellWithIdentifier:@"NewsCell"];
    Articles *articl = [_tableViewsData objectAtIndex:indexPath.row];
    
    [prototypecell.title setText:articl.title];
    [prototypecell.shortDescription setText:articl.short_description];
    
    
    [prototypecell setNeedsLayout];
    [prototypecell layoutIfNeeded];
    
    return [prototypecell.contentView systemLayoutSizeFittingSize:UILayoutFittingExpandedSize].height;
    
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([NetworkTracker isReachable]) {
        Articles *article = [_tableViewsData objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:[[ControllersManager sharedManager] createNewsDetailsViewControllerWithArticle:article] animated:YES];
    }
    else{
        UIAlertView *noConnection = [[UIAlertView alloc]initWithTitle:@"З'єднання відсутнє" message:nil delegate:self cancelButtonTitle:@"ОК" otherButtonTitles: nil];
        [noConnection show];
    }
    [_tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(void)setUpCell
{
    [_tableView registerNib:[UINib nibWithNibName:@"NewsTableViewCell" bundle:nil] forCellReuseIdentifier:@"NewsCell"];
}

-(void)setUpData
{
    _tableViewsData = [DataManager sharedManager].listOfArticles;
}

-(void)refreshData
{
    _tableViewsData = [DataManager sharedManager].listOfArticles;
    _newArticles=[[DataManager sharedManager] new_entries_count];
    //_stream=[[DataManager sharedManager] streaming];
     _newArticles = [[DataManager sharedManager] new_entries_count];
    [_tableView reloadData];
    [self setUpStreamView];
    [self setupNavBar];
}

-(void)setUpStreamView
{
    if (_stream) {
        StreamView *streamView = [[StreamView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
        [streamView loadVideoStreamWithUrl:_stream];
        self.tableView.tableHeaderView=streamView;
    }
    else
    {
        self.tableView.tableHeaderView = nil;
    }
}

-(void)setupNavBar{
    if (_newArticles) {
        NewArticlesView *view =[[NewArticlesView alloc]init];
        [view newArticles:_newArticles];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:view];
    }
    else{
        self.navigationItem.rightBarButtonItem = nil;
    }
}


@end
