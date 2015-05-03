//
//  TeamViewCell.h
//  Hromadske
//
//  Created by Admin on 19.03.15.
//  Copyright (c) 2015 Semeniuk Sviatoslav. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeamViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageview;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *bio;
@property (weak, nonatomic) IBOutlet UIView *conteiner;

-(void) updateShadow;

@end
