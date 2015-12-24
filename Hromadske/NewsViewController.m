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
#import "Categories.h"

@interface NewsViewController () <UITableViewDataSource, UITableViewDelegate, DataManangerDelagate> {
    NSMutableArray* _tableViewsData;
    NewArticlesView* _newArticlesView;
    NSInteger _countNewArticles;
    NSString* _currentCategory;
}
@property (weak, nonatomic) IBOutlet UITableView* tableView;
@property (strong, nonatomic) UIRefreshControl* pullToReferesh;
@end

@implementation NewsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[DataManager sharedManager] setDelegate:self];
    [self setUpViews];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableViweData) name:@"ViewsCountUpdated" object:nil];
    [self setUpData];
    _currentCategory = [[DataManager sharedManager] articleCategory];
    [[DataManager sharedManager] fetchRemoteDigest];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (![[DataManager sharedManager].articleCategory isEqualToString:_currentCategory]) {
        _currentCategory = [[DataManager sharedManager] articleCategory];
        [self setUpData];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark Views
- (void)setUpStreamView
{
    if ([[DataManager sharedManager] streamingURL]) {
        StreamView* streamView = [[StreamView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
        [streamView loadVideoStreamWithUrl:[[DataManager sharedManager] streamingURL]];
        self.tableView.tableHeaderView = streamView;
    }
    else {
        self.tableView.tableHeaderView = nil;
    }
}

- (void)setUpViews
{
    [self setUpStreamView];
    [_tableView registerNib:[UINib nibWithNibName:@"NewsTableViewCell" bundle:nil] forCellReuseIdentifier:@"NewsCell"];
    _pullToReferesh = [[UIRefreshControl alloc] init];
    [_pullToReferesh addTarget:[DataManager sharedManager] action:@selector(fetchRemoteDigest) forControlEvents:UIControlEventValueChanged];
    [_tableView addSubview:_pullToReferesh];
}
- (void)showNewArticleBage:(NSInteger)count
{
    if (!_newArticlesView) {
        _newArticlesView = [[NewArticlesView alloc] init];
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBounds:_newArticlesView.frame];
        [btn addSubview:_newArticlesView];
        [btn addTarget:self action:@selector(goToTop) forControlEvents:UIControlEventAllEvents];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    }
    [_newArticlesView setHidden:NO];
    [_newArticlesView newArticles:count];
}

- (void)hideNewArticlesBage
{
    [_newArticlesView setHidden:YES];
}

- (void)goToTop
{
    [_tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    [self hideNewArticlesBage];
}

#pragma mark DATA

- (void)setUpData
{
    _tableViewsData = [NSMutableArray arrayWithArray:[[DataManager sharedManager] getArticlesWithCurrentCategories]];
}

- (void)reloadTableViweData
{
    [_tableView reloadData];
}

- (void)dataManagerDidStartUpadating:(DataManager*)manager
{
    if (![_pullToReferesh isRefreshing]) {
        [_pullToReferesh beginRefreshing];
    }
}
- (void)dataManager:(DataManager*)manager didFinishUpdatingArticles:(NSArray*)listOfArticles
{
    [self setUpStreamView];

    _countNewArticles = [listOfArticles count];
    if (_countNewArticles > 0 && _tableView.contentOffset.y > 0) {
        [self showNewArticleBage:_countNewArticles];
    }
    else {
        [self hideNewArticlesBage];
    }

    for (int i = 0; i < [listOfArticles count]; i++) {
        [_tableViewsData insertObject:[listOfArticles objectAtIndex:i] atIndex:i];
    }

    [_tableView reloadData];
    [_pullToReferesh endRefreshing];
}

- (void)dataManagerDidFaildUpadating:(DataManager*)manager
{
    [_pullToReferesh endRefreshing];
}

#pragma mark - HandleUserInteratcionAccordingMenu

-(void)disableUserInteractionInViews{
    self.tableView.userInteractionEnabled = NO;
}

-(void)enableUserInteractionInViews{
    self.tableView.userInteractionEnabled = YES;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView*)tableView willDisplayCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
    [(NewsTableViewCell*)cell performSelector:@selector(updateShadow) withObject:nil afterDelay:0];
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_tableViewsData count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    NewsTableViewCell* newsCell = [tableView dequeueReusableCellWithIdentifier:@"NewsCell" forIndexPath:indexPath];
    Articles* article = [_tableViewsData objectAtIndex:indexPath.row];
    [newsCell.title setText:article.title];
    [newsCell.shortDescription setText:article.short_description];
    [newsCell.viewsCount setText:[article.views_count stringValue]];
    [newsCell.createdAt setText:[[DateFormatter sharedManager] timeIntervalFromDate:article.created_at]];
    if (![article.category.name isEqual:@"uncategorized"]) {
        [newsCell.category setText:article.category.name];
    }

//    NSURLRequest* imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[article getImageUrl]]
//                                                  cachePolicy:NSURLRequestReturnCacheDataElseLoad
//                                              timeoutInterval:60];
//    [newsCell.image_view setImageWithURLRequest:imageRequest placeholderImage:[UIImage imageNamed:@"placeholder"] success:nil failure:nil];

    if (article.viewed.boolValue == NO) {
        [newsCell unviewed];
    };

    return newsCell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 356.f;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    Articles* article = [_tableViewsData objectAtIndex:indexPath.row];
    if ([NetworkTracker isReachable] || (article.content)) {
        NewsDetailsViewController* details = (NewsDetailsViewController*)[[ControllersManager sharedManager] viewControllerWithIdentefier:NSStringFromClass([NewsDetailsViewController class])];
        details.article = article;
        [self.navigationController pushViewController:details animated:YES];
        if (article.viewed.boolValue == NO) {
//            [article makeViewed];
        }
    }
    else {
        UIAlertView* noConnection = [[UIAlertView alloc] initWithTitle:@"Помилка" message:@"Перевірте підключення до мережі" delegate:self cancelButtonTitle:@"Добре" otherButtonTitles:nil];
        [noConnection show];
    }
    [_tableView reloadData];
    [_tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
