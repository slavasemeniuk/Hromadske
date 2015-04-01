//
//  HelpProjectViewController.m
//  Hromadske
//
//  Created by Admin on 19.03.15.
//  Copyright (c) 2015 Semeniuk Sviatoslav. All rights reserved.
//

#import "HelpProjectViewController.h"
#import "DataManager.h"
#import "HelpProject.h"

@interface HelpProjectViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) NSString *url;

@end

@implementation HelpProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpLabel];
    
}

-(void) setUpLabel {
    _label.lineBreakMode = NSLineBreakByWordWrapping;
    _label.numberOfLines = 0;
}

-(void) setUpData {
    [[DataManager sharedManager] helpProjectDataWithCompletion: ^(id helpData) {
        HelpProject *helpProjectData = helpData;
        [_label setText: helpProjectData.content];
        _url = helpProjectData.url;
    }];
}
- (IBAction)goToHelp:(id)sender {
    NSURL *url = [NSURL URLWithString:_url];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    UIWebView *helpPage = [[UIWebView alloc] init];
    [helpPage loadRequest:requestObj];
}

@end
