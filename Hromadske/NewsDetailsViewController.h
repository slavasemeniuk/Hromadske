//
//  NewsDetailsViewController.h
//  Hromadske
//
//  Created by Admin on 17.04.15.
//  Copyright (c) 2015 Semeniuk Sviatoslav. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    NewsDetailsModeDay = 0,
    NewsDetailsModeNight
} NewsDetailsMode;

@interface NewsDetailsViewController : UIViewController

-(void) setContent: (id) article;

@end
