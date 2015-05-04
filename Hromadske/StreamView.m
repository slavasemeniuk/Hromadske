//
//  StreamView.m
//  Hromadske
//
//  Created by Admin on 23.04.15.
//  Copyright (c) 2015 Semeniuk Sviatoslav. All rights reserved.
//

#import "StreamView.h"

@interface StreamView()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation StreamView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"StreamView" owner:self options:nil];
        self.bounds=self.view.bounds;
        [self addSubview:self.view];
        self.webView.delegate=self;
    }
    return self;
}

-(void)loadVideoStreamWithUrl:(NSString *)url{
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [self.webView loadRequest:request];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
