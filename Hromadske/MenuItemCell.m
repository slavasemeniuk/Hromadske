//
//  MenuItemCell.m
//  Hromadske
//
//  Created by Admin on 19.04.15.
//  Copyright (c) 2015 Semeniuk Sviatoslav. All rights reserved.
//

#import "MenuItemCell.h"


@implementation MenuItemCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
  
}

-(void)setSelected:(BOOL)selected{
    UIView * selectedBackgroundView = [[UIView alloc] init];
    [selectedBackgroundView setBackgroundColor:[UIColor colorWithRed:21.f/255.0f green:21.f/255.0f blue:21.f/255.0f alpha:0.2f]];
    [self setSelectedBackgroundView:selectedBackgroundView];
 
}

@end
