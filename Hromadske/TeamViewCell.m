//
//  TeamViewCell.m
//  Hromadske
//
//  Created by Admin on 19.03.15.
//  Copyright (c) 2015 Semeniuk Sviatoslav. All rights reserved.
//

#import "TeamViewCell.h"

@implementation TeamViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setUpImageView];
}

- (void)setUpImageView
{
    _imageview.layer.cornerRadius = _imageview.frame.size.width / 2;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    _imageview.image = nil;
    _bio.text = nil;
    _label.text = nil;
}

@end
