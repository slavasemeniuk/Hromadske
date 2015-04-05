//
//  Articles.h
//  Hromadske
//
//  Created by Admin on 05.04.15.
//  Copyright (c) 2015 Semeniuk Sviatoslav. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Articles : NSManagedObject

@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * short_description;
@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * vk_id;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSNumber * views_count;

-(void) convertDataToArticleModel: (NSArray *) article;

@end
