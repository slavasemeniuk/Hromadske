//
//  newArticlesView.m
//  Hromadske
//
//  Created by Admin on 24.04.15.
//  Copyright (c) 2015 Semeniuk Sviatoslav. All rights reserved.
//

#import "NewArticlesView.h"

@implementation NewArticlesView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"NewArticlesView" owner:self options:nil];
        self.bounds=self.conteinerView.bounds;
        [self addSubview:self.conteinerView];
    }
    return self;
}
-(void)newArticles:(NSInteger)number{
    if (number > 99) {
        [self.label setText:@"99"];
    } else {
        [self.label setText:[NSString stringWithFormat:@"%ld",(long)number]];
    }
}

@end
