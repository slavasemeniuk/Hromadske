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
{
    NSString *_mode;
}
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
    _mode=@"day";
    _article=article;
}

-(void)setUpViewController{
    [self setUpNavigationBar];
    [self setUpData];
}

-(void)setUpNavigationBar{
    self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hromadske-logo"]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"news-moon"] style:UIBarButtonItemStyleDone target:self action:@selector(changeMode)];
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

-(void)changeMode{
    if ([_mode isEqual:@"day"]) {
        _mode=@"night";
        self.navigationItem.rightBarButtonItem.image=[UIImage imageNamed:@"news-sun"];
        self.navigationController.navigationBar.barTintColor=[UIColor blackColor];
        self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
        self.descript.textColor=[UIColor whiteColor];
        self.name.textColor = [UIColor whiteColor];
        self.view.backgroundColor=[UIColor blackColor];
        UIView *addStatusBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.navigationController.navigationBar.frame.size.width, 20)];
        addStatusBar.backgroundColor = [UIColor blackColor];
        [self.navigationController.navigationBar.window addSubview:addStatusBar];
    }
    else{
        _mode=@"day";
        self.navigationItem.rightBarButtonItem.image=[UIImage imageNamed:@"news-moon"];
        self.navigationController.navigationBar.barTintColor=[UIColor whiteColor];
        self.navigationController.navigationBar.tintColor=[UIColor blackColor];
        self.descript.textColor=[UIColor blackColor];
        self.name.textColor = [UIColor blackColor];
        self.view.backgroundColor=[UIColor whiteColor];
        UIView *addStatusBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.navigationController.navigationBar.frame.size.width, 20)];
        addStatusBar.backgroundColor = [UIColor colorWithRed:253.0f/255.0f green:123.0f/255.0f blue:40.0f/255.0f alpha:1];;
        [self.navigationController.navigationBar.window addSubview:addStatusBar];
    }
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
