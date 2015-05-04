//
//  WebHelpViewController.m
//  Hromadske
//
//  Created by Admin on 29.04.15.
//  Copyright (c) 2015 Semeniuk Sviatoslav. All rights reserved.
//

#import "WebHelpViewController.h"
#import "Constants.h"

@interface WebHelpViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation WebHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpBar];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:HELP_URL]];
    [_webView loadRequest:request];
}

-(void)setUpBar{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Назад" style:UIBarButtonItemStyleDone target:self action:nil];
}


@end
