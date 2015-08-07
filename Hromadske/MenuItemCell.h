//
//  MenuItemCell.h
//  Hromadske
//
//  Created by Admin on 19.04.15.
//  Copyright (c) 2015 Semeniuk Sviatoslav. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuItemCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView* icon;
@property (weak, nonatomic) IBOutlet UILabel* title;
@property (weak, nonatomic) IBOutlet UIImageView* rightImageView;
@property (weak, nonatomic) IBOutlet UIView *rightContainerView;

- (void)selectCell;

@end
