//
//  HTMLManager.m
//  Hromadske
//
//  Created by Admin on 02.05.15.
//  Copyright (c) 2015 Semeniuk Sviatoslav. All rights reserved.
//

#import "HTMLManager.h"
@interface HTMLManager ()
{
    NSScanner *_scanner;
}

@end

@implementation HTMLManager

+ (HTMLManager *)sharedManager {
    static HTMLManager *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[HTMLManager alloc] init];
    });
    
    return _manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _scanner=[[NSScanner alloc] init];
    }
    return self;
}

- (NSString *)removeTagsFromString: (NSString *) string {
    NSString *text = nil;
    _scanner = [NSScanner scannerWithString: string];
    while ([_scanner isAtEnd] == NO) {
        [_scanner scanUpToString: @"<" intoString: NULL];
        [_scanner scanUpToString: @">" intoString: &text];
        string = [string stringByReplacingOccurrencesOfString:
                [NSString stringWithFormat: @"%@>", text]
                                               withString: @" "];
    }
    string = [string stringByReplacingOccurrencesOfString:@"\r\n&nbsp" withString:@" "];
    string = [string stringByReplacingOccurrencesOfString:@"&nbsp" withString:@" "];
    string = [string stringByReplacingOccurrencesOfString:@"&quot" withString:@" "];
    
    return string;
}

@end
