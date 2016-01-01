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
#import "RestKitManager.h"
#import "NewArticlesView.h"
#import "StreamView.h"
#import "ControllersManager.h"
#import "DataManager.h"
#import "NewsTableViewCell.h"
#import "Articles.h"
#import "Categories.h"

@interface NewsViewController () <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate> {
    NewArticlesView* _newArticlesView;
    NSString* _currentCategory;
}
@property (strong, nonatomic)  NSFetchedResultsController* fetchedResultsController;
@property (weak, nonatomic) IBOutlet UITableView* tableView;
@property (strong, nonatomic) UIRefreshControl* pullToReferesh;
@end

@implementation NewsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpViews];
    [self setUpData];
//    _currentCategory = [[DataManager sharedManager] articleCategory];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    if (![[DataManager sharedManager].articleCategory isEqualToString:_currentCategory]) {
//        _currentCategory = [[DataManager sharedManager] articleCategory];
//        [self setUpData];
//        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
//    }
}

#pragma mark Views
- (void)setUpStreamView
{
//    if ([[DataManager sharedManager] streamingURL]) {
//        StreamView* streamView = [[StreamView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
//        [streamView loadVideoStreamWithUrl:[[DataManager sharedManager] streamingURL]];
//        self.tableView.tableHeaderView = streamView;
//    }
//    else {
//        self.tableView.tableHeaderView = nil;
//    }
}

- (void)setUpViews
{
    [self setUpStreamView];
    [_tableView registerNib:[UINib nibWithNibName:@"NewsTableViewCell" bundle:nil] forCellReuseIdentifier:@"NewsCell"];
    _pullToReferesh = [[UIRefreshControl alloc] init];
    [_pullToReferesh addTarget:self action:@selector(fetchRemoteArticles) forControlEvents:UIControlEventValueChanged];
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

- (void)goToTop
{
    [_tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
     [_newArticlesView setHidden:YES];
}

#pragma mark DATA

- (void)setUpData
{
    NSError *error = nil;
    [self.fetchedResultsController performFetch:&error];
    
    if (error) {
        NSLog(@"Unable to perform fetch.");
        NSLog(@"%@, %@", error, error.localizedDescription);
        return;
    }
    [self fetchRemoteArticles];
}

- (void)fetchRemoteArticles
{
    if (![_pullToReferesh isRefreshing]) {
        [_pullToReferesh beginRefreshing];
    }
    NSDate* date;
    NSNumber* count;
    if ([[[self.fetchedResultsController sections] objectAtIndex: 0] numberOfObjects] == 0) {
        count = [NSNumber numberWithInt:30];
    } else {
        date = [(Articles*)[[[self.fetchedResultsController sections] objectAtIndex:0] objects].firstObject created_at];
    }
    
    [DataManager fetchRemoteArticlesFromDate:date andCount:count success:^(NSUInteger countOfNews) {
        if (countOfNews>0) {
            [self showNewArticleBage:countOfNews];
        } else {
            [_newArticlesView setHidden:YES];
        }

        [_pullToReferesh endRefreshing];
    } fail:^{
        [_pullToReferesh endRefreshing];
    }];
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
    return [[[self.fetchedResultsController sections] objectAtIndex: section] numberOfObjects];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    NewsTableViewCell* newsCell = [tableView dequeueReusableCellWithIdentifier:@"NewsCell" forIndexPath:indexPath];
    Articles* article = [self.fetchedResultsController objectAtIndexPath:indexPath];
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
    Articles* article = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if ([NetworkTracker isReachable] || (article.viewed)) {
        NewsDetailsViewController* details = (NewsDetailsViewController*)[[ControllersManager sharedManager] viewControllerWithIdentefier:NSStringFromClass([NewsDetailsViewController class])];
        details.article = article;
        [self.navigationController pushViewController:details animated:YES];
    }
    else {
        UIAlertView* noConnection = [[UIAlertView alloc] initWithTitle:@"Помилка" message:@"Перевірте підключення до мережі" delegate:self cancelButtonTitle:@"Добре" otherButtonTitles:nil];
        [noConnection show];
    }
    [_tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - FetchedResultController

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:NSStringFromClass([Articles class]) inManagedObjectContext:[RestKitManager managedObkjectContext]];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setFetchLimit:10];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                              initWithKey:@"created_at" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    NSFetchedResultsController *theFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:[RestKitManager managedObkjectContext] sectionNameKeyPath:nil
                                                   cacheName:nil];
    
    self.fetchedResultsController = theFetchedResultsController;
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
    
}

#pragma mark - FetchedResultControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [_tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [_tableView endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    switch (type) {
        case NSFetchedResultsChangeInsert: {
            [_tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeDelete: {
            [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeUpdate: {
            [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeMove: {
            if(![indexPath isEqual:newIndexPath]){
                [_tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
            }
            break;
        }
    }
}


@end
