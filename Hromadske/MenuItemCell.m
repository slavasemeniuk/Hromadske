//
//  MenuItemCell.m
//  Hromadske
//
//  Created by Admin on 19.04.15.
//  Copyright (c) 2015 Semeniuk Sviatoslav. All rights reserved.
//

#import "MenuItemCell.h"

@implementation MenuItemCell {
    BOOL _selected;
}

- (void)awakeFromNib
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    _icon.image = nil;
    _rightImageView.image = nil;
    _title.text = @"";
    _subTitle.text = @"";
    _selected = NO;
    [self.contentView setBackgroundColor:[UIColor clearColor]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    if (selected) {
        [self.contentView setBackgroundColor:[UIColor colorWithRed:21.f / 255.0f green:21.f / 255.0f blue:21.f / 255.0f alpha:0.2f]];
    }
    else {
        [self.contentView setBackgroundColor:[UIColor clearColor]];
    }

}

@end
