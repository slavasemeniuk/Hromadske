//
//  DIgest.m
//  Hromadske
//
//  Created by Admin on 07.04.15.
//  Copyright (c) 2015 Semeniuk Sviatoslav. All rights reserved.
//

#import "Digest.h"
#import "RemoteManager.h"
#import "DataManager.h"

@interface Digest()
{
    NSArray *_weather;
    NSArray *_streaming;
    NSArray *_content;
}

@end

@implementation Digest

+ (Digest *)sharedManager
{
    static Digest *_digest = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        _digest = [[Digest alloc] init];
    });
    return _digest;
}

-(void)getDigest
{
    //[[DataManager sharedManager] getDateOfLastArticle];
    [[RemoteManager sharedManager] parsedJsonWithEndOfURL:@"digest.json" :^(NSArray *parsedDigest)
     {
         _weather = [parsedDigest valueForKey:@"weather"];
         _streaming = [parsedDigest valueForKey:@"streaming"];
         _content = [parsedDigest valueForKey:@"content"];
     }];
}

-(NSInteger)countNewArticles
{
    return (NSInteger)[_content valueForKey:@"count_new_entries"];
}

-(void)setToZeroNewArticles
{
    _content=nil;
}

@end
