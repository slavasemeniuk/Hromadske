//
//  StreamView.h
//  Hromadske
//
//  Created by Admin on 23.04.15.
//  Copyright (c) 2015 Semeniuk Sviatoslav. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StreamView : UIView
@property (strong, nonatomic) IBOutlet UIView *view;

-(void)loadVideoStreamWithUrl:(NSString *)url;
@end
