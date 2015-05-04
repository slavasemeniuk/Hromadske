//
//  NewsTableViewCell.m
//  Hromadske
//
//  Created by Admin on 04.04.15.
//  Copyright (c) 2015 Semeniuk Sviatoslav. All rights reserved.
//

#import "NewsTableViewCell.h"

@implementation NewsTableViewCell

- (void)awakeFromNib {
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:_container.bounds];
    _container.layer.masksToBounds = NO;
    _container.layer.shadowColor = [UIColor blackColor].CGColor;
    _container.layer.shadowOffset = CGSizeMake(0.5f, 0.5f);
    _container.layer.shadowOpacity = 0.5f;
    _container.layer.shadowPath = shadowPath.CGPath;
    [_container.layer setShouldRasterize:YES];
    [_container.layer setRasterizationScale:[UIScreen mainScreen].scale];
}

- (void) updateShadow {
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:_container.bounds];
    _container.layer.shadowPath = shadowPath.CGPath;
}


-(void)unviewed
{
    _topLine.backgroundColor = [UIColor colorWithRed:253.0f/255.0f green:124.0f/255.0f blue:40.0f/255.0f alpha:1.0f];
}

-(void)prepareForReuse{
    [super prepareForReuse];
    _topLine.backgroundColor = [UIColor colorWithRed:206.0f/255.0f green:206.0f/255.0f blue:207.0f/255.0f alpha:1.0f];
    _image_view.image = nil;
    _createdAt.text = nil;
    _shortDescription.text = nil;
    _title.text = nil;
    _category.text =nil;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [self setHighlighted:highlighted];
}

- (void)setHighlighted:(BOOL)highlighted{
    self.container.alpha = highlighted ? 0.5 : 1;
}

@end
