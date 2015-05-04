//
//  Video.h
//  Hromadske
//
//  Created by Admin on 14.04.15.
//  Copyright (c) 2015 Semeniuk Sviatoslav. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Articles;

@interface Video : NSManagedObject

@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) Articles *article;

@end
