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
    
    [_loader remove];
    [DataManager sharedManager].newsDetailsMode=_mode;
    _mode = NewsDetailsModeDay;
    [self updateCurrentMode];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _mode = [DataManager sharedManager].newsDetailsMode;
    [self updateCurrentMode];
}

#pragma mark - VIEW CONTROLLER
-(void)setUpViewController{
    if ([DataManager sharedManager].newsDetailsMode!=NewsDetailsModeNone) {
        _mode=[DataManager sharedManager].newsDetailsMode;
    }else{
        NSDate *date = [NSDate date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:date];
        NSInteger hour = [components hour];
        if (hour > 18 || hour < 8) {
            _mode = NewsDetailsModeNight;
            
        } else {
            _mode = NewsDetailsModeDay;
        }
    }
    [self setUpNavigationBar];
    _webView.delegate = self;
    _webView.alpha = 0;
}

-(void)setUpNavigationBar{
    self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hromadske-logo"]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"news-moon"] style:UIBarButtonItemStyleDone target:self action:@selector(toggleMode)];
    self.navigationItem.backBarButtonItem.title=@"Назад";
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
    [self showLoader:NO];
    [self loadWebViewContent];
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
    [self setLoaderColor];
    [self updateCurrentMode];
}

- (void) updateCurrentMode {
    if (_mode == NewsDetailsModeDay) {
        self.navigationItem.rightBarButtonItem.image = [UIImage imageNamed:@"news-moon"];
        self.navigationController.navigationBar.barTintColor=[UIColor whiteColor];
        self.navigationController.navigationBar.tintColor=[UIColor blackColor];
        _webView.backgroundColor = [UIColor colorWithRed:232.0f/255.0f green:232.0f/255.0f blue:232.0f/255.0f alpha:_webView.alpha];
        self.view.backgroundColor = [UIColor colorWithRed:232.0f/255.0f green:232.0f/255.0f blue:232.0f/255.0f alpha:1.0f];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
    else{
        self.navigationItem.rightBarButtonItem.image = [UIImage imageNamed:@"news-sun"];
        self.navigationController.navigationBar.barTintColor=[UIColor blackColor];
        self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
        _webView.backgroundColor = [UIColor colorWithRed:30.0f/255.0f green:30.0f/255.0f blue:30.0f/255.0f alpha:_webView.alpha];
        self.view.backgroundColor = [UIColor colorWithRed:30.0f/255.0f green:30.0f/255.0f blue:30.0f/255.0f alpha:1.0f];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    [self loadWebViewContent];
}


- (void) showLoader:(BOOL)yes{
    if (!_loader) {
        _loader = [[PQFCirclesInTriangle alloc] initLoaderOnView:self.view];
        _loader.layer.cornerRadius=4.f;
        _loader.layer.borderColor = [UIColor clearColor].CGColor;
        _loader.layer.borderWidth = .5f;
        _loader.layer.backgroundColor = [UIColor clearColor].CGColor;
        [self setLoaderColor];
        _loader.center = CGPointMake(self.view.frame.size.width / 2, 100);
    }
    
    if (yes) {
        [_loader show];
    } else {
        [_loader hide];
    }
    
}

- (void)setLoaderColor{
    if (_mode==NewsDetailsModeDay) {
        _loader.loaderColor = [UIColor lightGrayColor];
    }else{
        _loader.loaderColor = [UIColor whiteColor];
    }
}

#pragma mark - DELEGATE
- (void)webViewDidStartLoad:(UIWebView *)webView {
    _webView.alpha = 0;
    [self showLoader:YES];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [UIView animateWithDuration:0.3 delay:0.2 options:UIViewAnimationOptionCurveLinear animations:^{
        [self showLoader:NO];
        _webView.alpha = 1;
    } completion:nil];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self showLoader:NO];
}


@end
