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

    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:_conteiner.bounds];
    _conteiner.layer.masksToBounds = NO;
    _conteiner.layer.shadowColor = [UIColor blackColor].CGColor;
    _conteiner.layer.shadowOffset = CGSizeMake(0.5f, 0.5f);
    _conteiner.layer.shadowOpacity = 0.5f;
    _conteiner.layer.shadowPath = shadowPath.CGPath;
    [_conteiner.layer setShouldRasterize:YES];
    [_conteiner.layer setRasterizationScale:[UIScreen mainScreen].scale];
}

- (void) updateShadow {
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:_conteiner.bounds];
    _conteiner.layer.shadowPath = shadowPath.CGPath;
}

- (void) setUpImageView
{
    _imageview.layer.cornerRadius = _imageview.frame.size.width/2;
    _imageview.layer.masksToBounds = YES;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [self setHighlighted:highlighted];
}

- (void)setHighlighted:(BOOL)highlighted{
    self.conteiner.alpha = highlighted ? 0.5 : 1;
}


@end
