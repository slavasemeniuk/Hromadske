//
//  NewsDetailsLocalViewController.m
//  Hromadske
//
//  Created by Admin on 29.04.15.
//  Copyright (c) 2015 Semeniuk Sviatoslav. All rights reserved.
//

#import "NewsDetailsLocalViewController.h"
#import "Articles.h"
#import <UIImageView+AFNetworking.h>

@interface NewsDetailsLocalViewController ()
@property (weak, nonatomic) IBOutlet UIView *attachmentView;
@property (weak, nonatomic) IBOutlet UILabel *descript;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) Articles *article;
@end

@implementation NewsDetailsLocalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpViewController];
}

//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}

-(void)setdata:(id)article
{
    _article=article;
}

-(void)setUpViewController{
    [self setUpNavigationBar];
    [self setUpData];
}

-(void)setUpNavigationBar{
    self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hromadske-logo"]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Назад" style:UIBarButtonItemStyleDone target:self action:@selector(goRoot)];
}

-(void)setUpData{
    [self.name setText:_article.title];
    [self.descript setText:_article.short_description];
    if ([_article getVideoURL]) {
        UIWebView *webView = [[UIWebView alloc]initWithFrame:self.attachmentView.bounds];
        NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:[_article getVideoURL]]];
        [webView loadRequest:request];
        [self.attachmentView addSubview:webView];
    }
    else
        if ([_article getImageUrl]) {
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.attachmentView.bounds];
            [self.attachmentView addSubview:imgView];
            NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[_article getImageUrl]]
                                                          cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                      timeoutInterval:60];
            [imgView setImageWithURLRequest:imageRequest placeholderImage:[UIImage imageNamed:@"placeholder"] success:nil failure:nil];
            
        }
    else
    {
        [self goRoot];
    }
}

-(void)goRoot{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
