//
//  TeamViewCell.m
//  Hromadske
//
//  Created by Admin on 19.03.15.
//  Copyright (c) 2015 Semeniuk Sviatoslav. All rights reserved.
//

#import "TeamViewCell.h"

@implementation TeamViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setUpImageView];
    [self setUpLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUpImageView
{
    _imageview.layer.cornerRadius = _imageview.frame.size.width/2;
    _imageview.layer.borderWidth = 3.0f;
    _imageview.layer.borderColor = [UIColor colorWithRed:249.0f/255.0f green:172.0f/255.0f blue:34/255.0f alpha:1.0].CGColor;
    _imageview.layer.masksToBounds = YES;
}
-(void)setUpLabel
{
    _bio.lineBreakMode = NSLineBreakByWordWrapping;
    _bio.numberOfLines = 0;
}

@end
