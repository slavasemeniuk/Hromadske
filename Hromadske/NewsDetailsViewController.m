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
    if (([[_article valueForKey:@"content"] isEqual:@"link"])&&(![_article getLink])) {
        UIAlertView *noDetails = [[UIAlertView alloc]initWithTitle:@"Деталі відсутні" message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [noDetails show];
        [self goBack];
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
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(goBack)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(changeMode)];
}

-(void)changeMode{
    if ([_mode isEqual:@"day"]) {
        _mode=@"night";
    }
    else{
        _mode=@"day";
    }
    [self setUpWebView];
}

-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
