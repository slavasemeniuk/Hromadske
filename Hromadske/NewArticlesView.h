//
//  newArticlesView.h
//  Hromadske
//
//  Created by Admin on 24.04.15.
//  Copyright (c) 2015 Semeniuk Sviatoslav. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewArticlesView : UIView
@property (strong, nonatomic) IBOutlet UIView *conteinerView;
@property (weak, nonatomic) IBOutlet UILabel *label;

-(void)newArticles:(NSInteger)number;
@end
