//
//  NewsDetailsViewController.m
//  Hromadske
//
//  Created by Admin on 17.04.15.
//  Copyright (c) 2015 Semeniuk Sviatoslav. All rights reserved.
//

#import "NewsDetailsViewController.h"
#import <KVNProgress/KVNProgress.h>
#import "DataManager.h"
#import "ControllersManager.h"
#import "Link.h"
#import "Constants.h"
#import "Articles.h"

@interface NewsDetailsViewController ()<UIWebViewDelegate>
{
    NSString *_mode;
}
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) Articles *article;
@end

@implementation NewsDetailsViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self updateData];
    [self setUpViewController];
}

-(void)setUpViewController{
    _mode=@"day";
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
    if (([[_article valueForKey:@"content"] isEqual:@"link"])&&(([_article getVideoURL])||[_article getImageUrl])) {
        NewsDetailsLocalViewController *newsdet=[[ControllersManager sharedManager] createLocalNewsDetailsViewControllerWithArticle:_article];
        [self.navigationController pushViewController:newsdet animated:YES];
       
    }
    

}

-(void)webViewWithHtml
{
    if ([_mode isEqual:@"day"]) {
        NSString *HTMLString = [NSString stringWithFormat:@"%@%@%@",HTMLDETAILS_BEGIN,_article.content,HTMLDETAILS_END];
        [_webView loadHTMLString:HTMLString baseURL:[NSURL URLWithString:HROMADSKE_URL]];
    }
    else{
        NSString *HTMLString = [NSString stringWithFormat:@"%@%@%@",HTMLDETAILS_BEGIN_NIGHT,_article.content,HTMLDETAILS_END];
        [_webView loadHTMLString:HTMLString baseURL:[NSURL URLWithString:HROMADSKE_URL]];
    }
    
}

-(void)setContent:article
{
    _article=article;
}

-(void)updateData{
    if (!_article.content) {
        [[DataManager sharedManager] updateArticleWithId:_article.id];
        [KVNProgress showWithStatus:@"Завантаження"];
    }
}

-(void)refreshData
{
    [self setUpWebView];
    [KVNProgress dismiss];
    
}

-(void)setUpNavigationBar{
    self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hromadske-logo"]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Назад" style:UIBarButtonItemStylePlain target:self action:@selector(goRoot)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"news-moon"] style:UIBarButtonItemStyleDone target:self action:@selector(changeMode)];
}

-(void)changeMode{
    if ([_mode isEqual:@"day"]) {
        _mode=@"night";
        self.navigationItem.rightBarButtonItem.image=[UIImage imageNamed:@"news-sun"];
        self.navigationController.navigationBar.barTintColor=[UIColor blackColor];
        self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    }
    else{
        _mode=@"day";
        self.navigationItem.rightBarButtonItem.image=[UIImage imageNamed:@"news-moon"];
        self.navigationController.navigationBar.barTintColor=[UIColor whiteColor];
        self.navigationController.navigationBar.tintColor=[UIColor blackColor];
    }
    [self setUpWebView];
}
    
-(void)goRoot{
    self.navigationController.navigationBar.barTintColor=[UIColor whiteColor];
    self.navigationController.navigationBar.tintColor=[UIColor blackColor];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
