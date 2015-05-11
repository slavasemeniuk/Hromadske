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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableViweData) name:@"ViewsCountUpdated" object:nil];
    [[DataManager sharedManager] fetchRemoteDigest];
    
}

#pragma mark Views
- (void)setUpStreamView
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

- (void)setUpViews{
    [self setUpStreamView];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor blackColor]];
    [_tableView registerNib:[UINib nibWithNibName:@"NewsTableViewCell" bundle:nil] forCellReuseIdentifier:@"NewsCell"];
    _pullToReferesh = [[UIRefreshControl alloc] init];
    [_pullToReferesh addTarget:[DataManager sharedManager] action:@selector(fetchRemoteDigest) forControlEvents:UIControlEventValueChanged];
    [_tableView addSubview:_pullToReferesh];
    
}
- (void)showNewArticleBage:(NSInteger)count{
    if (!_newArticles) {
        _newArticles =[[NewArticlesView alloc]init];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBounds:_newArticles.frame];
        [btn addSubview:_newArticles];
        [btn addTarget:self action:@selector(goToTop) forControlEvents:UIControlEventAllEvents];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
        
    }
    [_newArticles setHidden:NO];
    [_newArticles newArticles:count];
}

- (void)hideNewArticlesBage{
    [_newArticles setHidden:YES];
}

- (void) goToTop{
    [_tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    [self hideNewArticlesBage];
}

#pragma mark DATA

-(void)setUpData
{
    _tableViewsData = [NSMutableArray arrayWithArray:[DataManager sharedManager].listOfArticles];
}

-(void)reloadTableViweData{
    _tableViewsData = [NSMutableArray arrayWithArray:[DataManager sharedManager].listOfArticles];
    [_tableView reloadData];
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
    _stream=[[DataManager sharedManager] streamingURL];
    [self setUpStreamView];
    for (int i=0; i<[listOfArticles count]; i++) {
        [_tableViewsData insertObject:[listOfArticles objectAtIndex:i] atIndex:i];
    }
    [_tableView reloadData];
    [_pullToReferesh endRefreshing];
}


- (void) dataManagerDidFaildUpadating:(DataManager *)manager{
    [_pullToReferesh endRefreshing];
}

#pragma mark - Table view delegate

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [(NewsTableViewCell *)cell performSelector:@selector(updateShadow) withObject:nil afterDelay:0];
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
    if (![article.category isEqual:@"uncategorized"]) {
        [newsCell.category setText:article.category];
    }
    
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[article getImageUrl]]
                                                  cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                              timeoutInterval:60];
    [newsCell.image_view setImageWithURLRequest:imageRequest placeholderImage:[UIImage imageNamed:@"placeholder"] success:nil failure:nil];
    
    if (article.viewed.boolValue==NO) {
        [newsCell unviewed];
    };
    
    return newsCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 356.f;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Articles *article = [_tableViewsData objectAtIndex:indexPath.row];
    if ([NetworkTracker isReachable]||(article.content)) {
        NewsDetailsViewController *details = (NewsDetailsViewController *)[[ControllersManager sharedManager] viewControllerWithIdentefier:NSStringFromClass([NewsDetailsViewController class])];
        details.article = article;
        [self.navigationController pushViewController:details animated:YES];
    }
    else{
        UIAlertView *noConnection = [[UIAlertView alloc]initWithTitle:@"Помилка" message:@"Перевірте підключення до мережі" delegate:self cancelButtonTitle:@"Добре" otherButtonTitles: nil];
        [noConnection show];
    }
    article.viewed=[NSNumber numberWithBool:YES];
    [article makeViewed];
    [_tableView reloadData];
    [_tableView deselectRowAtIndexPath:indexPath animated:NO];
}



@end
