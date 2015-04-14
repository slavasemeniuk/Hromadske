//
//  Artilces.h
//  Hromadske
//
//  Created by Admin on 13.04.15.
//  Copyright (c) 2015 Semeniuk Sviatoslav. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Artilces : NSManagedObject

@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * short_description;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * views_count;
@property (nonatomic, retain) NSNumber * vk_id;

@end
