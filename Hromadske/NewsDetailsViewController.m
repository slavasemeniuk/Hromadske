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
#import "Link.h"
#import "Constants.h"
#import "Articles.h"

@interface NewsDetailsViewController ()<UIWebViewDelegate>
{
    NewsDetailsMode _mode;
    NewsDetailsMode _lastMode;
}
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) PQFCirclesInTriangle *loader;
@end

@implementation NewsDetailsViewController

- (void)viewDidLoad{
    [super viewDidLoad];

    [self setUpViewController];
    [self updateCurrentMode];

    if (_article.content) {
        [self loadWebViewContent];
    } else {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataLoaded) name:@"refreshDataNotification" object:nil];
        [self loadData];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _mode = NewsDetailsModeDay;
    [self updateCurrentMode];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _mode = _lastMode;
    [self updateCurrentMode];
}

#pragma mark - VIEW CONTROLLER
-(void)setUpViewController{
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:date];
    NSInteger hour = [components hour];
    if (hour > 18 || hour < 8) {
        _mode = NewsDetailsModeNight;
        
    } else {
        _mode = NewsDetailsModeDay;
    }
    _lastMode = _mode;
    
    [self setUpNavigationBar];
    _webView.delegate = self;
    _webView.alpha = 0;
}

-(void)setUpNavigationBar{
    self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hromadske-logo"]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"news-moon"] style:UIBarButtonItemStyleDone target:self action:@selector(toggleMode)];
}


#pragma mark - DATA
-(void)loadData{
    if (!_article.content) {
        [self showLoader:YES];
        [[DataManager sharedManager] updateArticleWithId:_article.id];
    }
}
-(void)dataLoaded
{
    [self loadWebViewContent];
    [self showLoader:NO];
}

-(void)loadWebViewContent{
    if (![[_article valueForKey:@"content"] isEqual:@"link"]) {
        NSString *template = _mode == NewsDetailsModeDay ? HTMLDETAILS_DAY : HTMLDETAILS_NIGHT;
        NSString *htmlContent = [NSString stringWithFormat:@"%@%@%@",template ,_article.content,HTMLDETAILS_WRAP];
        [_webView loadHTMLString:htmlContent baseURL:[NSURL URLWithString:HROMADSKE_URL]];
    } else if ( [_article getLink] ) {
        NSString *url = [[NSString alloc] initWithString:[_article getLink]];
        NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:url]];
        [_webView loadRequest:request];
    }
}






#pragma mark - MODE
-(void)toggleMode{
    if (_mode == NewsDetailsModeDay) {
        _mode = NewsDetailsModeNight;
    }
    else{
        _mode = NewsDetailsModeDay;
    }
    [self updateCurrentMode];
}

- (void) updateCurrentMode {
    if (_mode == NewsDetailsModeDay) {
        self.navigationItem.rightBarButtonItem.image = [UIImage imageNamed:@"news-moon"];
        self.navigationController.navigationBar.barTintColor=[UIColor whiteColor];
        self.navigationController.navigationBar.tintColor=[UIColor blackColor];
        self.webView.backgroundColor = [UIColor colorWithRed:232.0f/255.0f green:232.0f/255.0f blue:232.0f/255.0f alpha:1.0f];
        self.view.backgroundColor = [UIColor colorWithRed:232.0f/255.0f green:232.0f/255.0f blue:232.0f/255.0f alpha:1.0f];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
    else{
        self.navigationItem.rightBarButtonItem.image = [UIImage imageNamed:@"news-sun"];
        self.navigationController.navigationBar.barTintColor=[UIColor blackColor];
        self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
        self.webView.backgroundColor = [UIColor colorWithRed:30.0f/255.0f green:30.0f/255.0f blue:30.0f/255.0f alpha:1.0f];
        self.view.backgroundColor = [UIColor colorWithRed:30.0f/255.0f green:30.0f/255.0f blue:30.0f/255.0f alpha:1.0f];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    [self loadWebViewContent];
}


- (void) showLoader:(BOOL)yes{
    if (!_loader) {
        self.loader = [[PQFCirclesInTriangle alloc] initLoaderOnView:self.webView];
        self.loader.layer.cornerRadius=4.f;
        self.loader.layer.borderColor = [UIColor clearColor].CGColor;
        self.loader.layer.borderWidth = .5f;
        self.loader.layer.backgroundColor = [UIColor clearColor].CGColor;
        self.loader.loaderColor = [UIColor lightGrayColor];
        self.loader.center = CGPointMake(self.view.frame.size.width / 2, 100);
    }
    
    if (yes) {
        [self.loader show];
    } else {
        [self.loader hide];
    }
    
}

#pragma mark - DELEGATE
- (void)webViewDidStartLoad:(UIWebView *)webView {
    _webView.alpha = 0;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [UIView animateWithDuration:0.3 delay:0.2 options:UIViewAnimationOptionCurveLinear animations:^{
        _webView.alpha = 1;
    } completion:nil];
}




@end
