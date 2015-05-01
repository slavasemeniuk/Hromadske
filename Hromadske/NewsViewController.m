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


@interface NewsViewController ()<UITableViewDataSource, UITableViewDelegate, DataManangerDelagate>
{
    NSMutableArray *_tableViewsData;
    NSString *_stream;
    NewArticlesView *_newArticles;
    NSInteger _countNewArticles;
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIRefreshControl *pullToReferesh;
@end

@implementation NewsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[DataManager sharedManager] setDelegate:self];
    [self setUpViews];
    [self setUpData];
    [self setUpStreamView];
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_tableViewsData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsTableViewCell *newsCell = [tableView dequeueReusableCellWithIdentifier:@"NewsCell" forIndexPath:indexPath];
    Articles *article = [_tableViewsData objectAtIndex:indexPath.row];
    [newsCell.title setText:article.title];
    [newsCell.shortDescription setText:article.short_description];
    [newsCell.viewsCount setText:[article.views_count stringValue]];
    [newsCell.createdAt setText:[[DateFormatter sharedManager] timeIntervalFromDate:article.created_at]];
    
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[article getImageUrl]]
                                                  cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                              timeoutInterval:60];
    [newsCell.image_view setImageWithURLRequest:imageRequest placeholderImage:[UIImage imageNamed:@"placeholder"] success:nil failure:nil];
    
    
    if (indexPath.row<_countNewArticles) {
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
    Articles *article = [_tableViewsData objectAtIndex:indexPath.row];
    if ([NetworkTracker isReachable]||(article.content)) {
        [self.navigationController pushViewController:[[ControllersManager sharedManager] createNewsDetailsViewControllerWithArticle:article] animated:YES];
    }
    else{
        UIAlertView *noConnection = [[UIAlertView alloc]initWithTitle:@"З'єднання відсутнє" message:nil delegate:self cancelButtonTitle:@"ОК" otherButtonTitles: nil];
        [noConnection show];
    }
    [_tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(void)setUpData
{
    _tableViewsData = [NSMutableArray arrayWithArray:[DataManager sharedManager].listOfArticles];
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

-(void)setUpViews{
    [_tableView registerNib:[UINib nibWithNibName:@"NewsTableViewCell" bundle:nil] forCellReuseIdentifier:@"NewsCell"];
    _pullToReferesh = [[UIRefreshControl alloc] init];
    [_pullToReferesh addTarget:[DataManager sharedManager] action:@selector(fetchRemoteArticles) forControlEvents:UIControlEventValueChanged];
    [_tableView addSubview:_pullToReferesh];
    
}
-(void)showNewArticleBage:(NSInteger)count{
    if (!_newArticles) {
        _newArticles =[[NewArticlesView alloc]init];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_newArticles];
    }
    [_newArticles setHidden:NO];
    [_newArticles newArticles:count];
}

-(void)hideNewArticlesBage{
    [_newArticles setHidden:YES];
}

- (void) dataManagerDidStartUpadating:(DataManager *)manager
{
    if (![_pullToReferesh isRefreshing]) {
         [_pullToReferesh beginRefreshing];
    }
}
- (void) dataManager:(DataManager *)manager didFinishUpdatingArticles:(NSArray *)listOfArticles{
    _countNewArticles = [listOfArticles count];
    if (_countNewArticles>0 && _tableView.contentOffset.y>0)
    {
        [self showNewArticleBage:_countNewArticles];
    }
    else
    {
        [self hideNewArticlesBage];
    }
    [_tableViewsData addObjectsFromArray:listOfArticles];
    [_tableView reloadData];
    [_pullToReferesh endRefreshing];
}


- (void) dataManagerDidFaildUpadating:(DataManager *)manager{
    [_pullToReferesh endRefreshing];
}


@end
