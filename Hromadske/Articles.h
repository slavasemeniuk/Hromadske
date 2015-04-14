//
//  Articles.h
//  Hromadske
//
//  Created by Admin on 13.04.15.
//  Copyright (c) 2015 Semeniuk Sviatoslav. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Articles : NSManagedObject

@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * short_description;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * views_count;
@property (nonatomic, retain) NSNumber * vk_id;
@property (nonatomic, retain) NSSet *withLink;
@property (nonatomic, retain) NSSet *withPhoto;
@property (nonatomic, retain) NSSet *withVideo;
@end

@interface Articles (CoreDataGeneratedAccessors)

- (void)addWithLinkObject:(NSManagedObject *)value;
- (void)removeWithLinkObject:(NSManagedObject *)value;
- (void)addWithLink:(NSSet *)values;
- (void)removeWithLink:(NSSet *)values;

- (void)addWithPhotoObject:(NSManagedObject *)value;
- (void)removeWithPhotoObject:(NSManagedObject *)value;
- (void)addWithPhoto:(NSSet *)values;
- (void)removeWithPhoto:(NSSet *)values;

- (void)addWithVideoObject:(NSManagedObject *)value;
- (void)removeWithVideoObject:(NSManagedObject *)value;
- (void)addWithVideo:(NSSet *)values;
- (void)removeWithVideo:(NSSet *)values;

-(void) convertDataToArticleModel: (NSArray *) article;

@end
