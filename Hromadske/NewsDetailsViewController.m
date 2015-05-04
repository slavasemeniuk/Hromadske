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
}
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) PQFCirclesInTriangle *loader;
@end

@implementation NewsDetailsViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self updateData];
    [self setUpViewController];
}

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"refreshDataNotification" object:nil];
    [self setUpNavigationBar];
    if (_article.content) {
        [self setUpWebView];
           }
    
}

-(void)setUpWebView{
    if (![[_article valueForKey:@"content"] isEqual:@"link"]) {
        [self webViewWithHtml];
    }
    if (([[_article valueForKey:@"content"] isEqual:@"link"])&&([_article getLink])) {
        NSString *url = [[NSString alloc] initWithString:[_article getLink]];
        NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:url]];
        [_webView loadRequest:request];
    }
}

-(void)webViewWithHtml
{
    if (_mode == NewsDetailsModeDay) {
        self.navigationController.navigationBar.barTintColor=[UIColor whiteColor];
        self.navigationController.navigationBar.tintColor=[UIColor blackColor];
        self.webView.backgroundColor = [UIColor colorWithRed:232.0f/255.0f green:232.0f/255.0f blue:232.0f/255.0f alpha:1.0f];
        [_webView loadHTMLString:[NSString stringWithFormat:@"%@%@%@",HTMLDETAILS_BEGIN,_article.content,HTMLDETAILS_END] baseURL:[NSURL URLWithString:HROMADSKE_URL]];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

    }
    else{
        
        self.navigationController.navigationBar.barTintColor=[UIColor blackColor];
        self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
        self.webView.backgroundColor = [UIColor colorWithRed:30.0f/255.0f green:30.0f/255.0f blue:30.0f/255.0f alpha:1.0f];
        [_webView loadHTMLString:[NSString stringWithFormat:@"%@%@%@",HTMLDETAILS_BEGIN_NIGHT,_article.content,HTMLDETAILS_END] baseURL:[NSURL URLWithString:HROMADSKE_URL]];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    
}

-(void)setContent:article
{
    _article=article;
}

-(void)updateData{
    if (!_article.content) {
        [self presentLoader];
        [[DataManager sharedManager] updateArticleWithId:_article.id];
    }
}

-(void)refreshData
{
    [self.loader remove];
    [self setUpWebView];
    
}

-(void)setUpNavigationBar{
    self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hromadske-logo"]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"news-moon"] style:UIBarButtonItemStyleDone target:self action:@selector(changeMode)];
    if ( _mode == NewsDetailsModeDay) {
        self.navigationItem.rightBarButtonItem.image = [UIImage imageNamed:@"news-moon"];
    }
    else{
        self.navigationItem.rightBarButtonItem.image = [UIImage imageNamed:@"news-sun"];
    }
}

-(void)changeMode{
    if ( _mode == NewsDetailsModeDay) {
        _mode = NewsDetailsModeNight;
        self.navigationItem.rightBarButtonItem.image = [UIImage imageNamed:@"news-sun"];
    }
    else{
        _mode = NewsDetailsModeDay;
        self.navigationItem.rightBarButtonItem.image = [UIImage imageNamed:@"news-moon"];
    }
    [self setUpWebView];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barTintColor=[UIColor whiteColor];
    self.navigationController.navigationBar.tintColor=[UIColor blackColor];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void) presentLoader{
    self.loader = [[PQFCirclesInTriangle alloc] initLoaderOnView:self.webView];
    self.loader.layer.cornerRadius=4.f;
    self.loader.layer.borderColor = [UIColor clearColor].CGColor;
    self.loader.layer.borderWidth = .5f;
    self.loader.layer.backgroundColor = [UIColor clearColor].CGColor;
    self.loader.loaderColor = [UIColor lightGrayColor];
    self.loader.center = CGPointMake(self.view.frame.size.width / 2, 100);
    
    [self.loader show];
    
}



@end
