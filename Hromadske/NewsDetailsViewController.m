//
//  NewsDetailsViewController.m
//  Hromadske
//
//  Created by Admin on 17.04.15.
//  Copyright (c) 2015 Semeniuk Sviatoslav. All rights reserved.
//

#import "NewsDetailsViewController.h"
#import <PQFCustomLoaders/PQFCirclesInTriangle.h>
#import "DataManager.h"
#import "ControllersManager.h"
#import "Constants.h"
#import "Link.h"
#import "Articles.h"
#import "UIViewController+ScrollingNavbar.h"
#import <WebKit/WebKit.h>

@interface NewsDetailsViewController () <UIWebViewDelegate, UIScrollViewDelegate> {
    NewsDetailsMode _mode;
    PQFCirclesInTriangle* _loader;
}
@property (weak, nonatomic) IBOutlet UIWebView* webView;
@end

@implementation NewsDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self followScrollView:_webView];
    [self setUseSuperview:YES];
    
    [self setUpViewController];
    [self updateCurrentMode];
    if (_article.viewed) {
        [self loadWebViewContent];
    }
    else {
        [self loadData];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [DataManager sharedManager].newsDetailsMode = _mode;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self showNavBarAnimated:NO];
    if (_webView.isLoading) {
        [_webView stopLoading];
    }
    _webView.delegate = nil;
    _webView.scrollView.delegate = nil;
    _webView = nil;
}

#pragma mark - VIEWCONTROLLER
- (void)setUpViewController
{
    if ([DataManager sharedManager].newsDetailsMode != NewsDetailsModeNone) {
        _mode = [DataManager sharedManager].newsDetailsMode;
    }
    else {
        NSDate* date = [NSDate date];
        NSCalendar* calendar = [NSCalendar currentCalendar];
        NSDateComponents* components = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit)fromDate:date];
        NSInteger hour = [components hour];
        if (hour > 18 || hour < 8) {
            _mode = NewsDetailsModeNight;
        }
        else {
            _mode = NewsDetailsModeDay;
        }
    }
    [self setUpNavigationBar];
    _webView.delegate = self;
    _webView.scrollView.delegate = self;
    _webView.alpha = 0;
}

- (void)setUpNavigationBar
{
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hromadske-logo"]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"news-moon"] style:UIBarButtonItemStyleDone target:self action:@selector(toggleMode)];
    self.navigationController.navigationBar.topItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Назад" style:UIBarButtonItemStyleDone target:self action:nil];
}

#pragma mark - DATA
- (void)loadData
{
    [self showLoader:YES];
    [DataManager updateArticleWithId:_article.id succes:^(Articles *article) {
        _article = article;
        [self showLoader:NO];
        [self loadWebViewContent];
    } fail:nil];
}

- (void)loadWebViewContent
{
    NSString* content = [_article getContent];
    if (![content isEqual:@"link"]) {
        NSString* template = _mode == NewsDetailsModeDay ? HTMLDETAILS_DAY : HTMLDETAILS_NIGHT;
        NSString* htmlContent = [NSString stringWithFormat:@"%@%@%@", template, content, HTMLDETAILS_WRAP];
        [_webView loadHTMLString:htmlContent baseURL:[NSURL URLWithString:HROMADSKE_URL]];
    }
    else if (_article.links.allObjects.firstObject) {
        NSString* url = [[NSString alloc] initWithString:[(Link*)_article.links.allObjects.firstObject url]];
        NSURLRequest* request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
        [_webView loadRequest:request];
    }
}

#pragma mark - MODE
- (void)toggleMode
{
    if (_mode == NewsDetailsModeDay) {
        _mode = NewsDetailsModeNight;
    }
    else {
        _mode = NewsDetailsModeDay;
    }
    [self updateCurrentMode];
    [self loadWebViewContent];
}

- (void)updateCurrentMode
{
    if (_mode == NewsDetailsModeDay) {
        self.navigationItem.rightBarButtonItem.image = [UIImage imageNamed:@"news-moon"];
        self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
        self.navigationController.navigationBar.tintColor = [UIColor blackColor];
        _webView.backgroundColor = [UIColor colorWithRed:232.0f / 255.0f green:232.0f / 255.0f blue:232.0f / 255.0f alpha:_webView.alpha];
        self.view.backgroundColor = [UIColor colorWithRed:232.0f / 255.0f green:232.0f / 255.0f blue:232.0f / 255.0f alpha:1.0f];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        _loader.loaderColor = [UIColor grayColor];
    }
    else {
        self.navigationItem.rightBarButtonItem.image = [UIImage imageNamed:@"news-sun"];
        self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        _webView.backgroundColor = [UIColor colorWithRed:30.0f / 255.0f green:30.0f / 255.0f blue:30.0f / 255.0f alpha:_webView.alpha];
        self.view.backgroundColor = [UIColor colorWithRed:30.0f / 255.0f green:30.0f / 255.0f blue:30.0f / 255.0f alpha:1.0f];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        _loader.loaderColor = [UIColor whiteColor];
    }
}

- (void)showLoader:(BOOL)yes
{
    if (!_loader) {
        _loader = [PQFCirclesInTriangle createLoaderOnView:self.view];
        _loader.layer.cornerRadius = 4.f;
        _loader.layer.borderColor = [UIColor clearColor].CGColor;
        _loader.layer.borderWidth = .5f;
        _loader.layer.backgroundColor = [UIColor clearColor].CGColor;
        _loader.center = CGPointMake(self.view.frame.size.width / 2, 100);
        if (_mode == NewsDetailsModeDay) {
            _loader.loaderColor = [UIColor grayColor];
        }
        else {
            _loader.loaderColor = [UIColor whiteColor];
        }
    }
    
    if (yes) {
        [_loader showLoader];
    }
    else {
        [_loader removeLoader];
    }
}

#pragma mark - DELEGATE
- (void)webViewDidStartLoad:(UIWebView*)webView
{
    _webView.alpha = 0;
    [self showLoader:YES];
}
- (void)webViewDidFinishLoad:(UIWebView*)webView
{
    [UIView animateWithDuration:0.3
                          delay:0.2
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         _webView.alpha = 1;
                         [self showLoader:NO];
                     }
                     completion:nil];
}
- (void)webView:(UIWebView*)webView didFailLoadWithError:(NSError*)error
{
    [self showLoader:NO];
    _webView.alpha = 1;
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    [self showNavbar];
    
    return YES;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (void)dealloc {
    [self stopFollowingScrollView];
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED < 90000
- (NSUInteger)supportedInterfaceOrientations
#else
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
#endif
{
    return UIInterfaceOrientationMaskAll;
}


@end
