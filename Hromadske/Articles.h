//
//  Articles.h
//  Hromadske
//
//  Created by Admin on 14.04.15.
//  Copyright (c) 2015 Semeniuk Sviatoslav. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Video;

@interface Articles : NSManagedObject

@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * short_description;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * views_count;
@property (nonatomic, retain) NSNumber * vk_id;
@property (nonatomic, retain) NSSet *links;
@property (nonatomic, retain) NSSet *photos;
@property (nonatomic, retain) NSSet *videos;
@end

@interface Articles (CoreDataGeneratedAccessors)

- (void)addLinksObject:(NSManagedObject *)value;
- (void)removeLinksObject:(NSManagedObject *)value;
- (void)addLinks:(NSSet *)values;
- (void)removeLinks:(NSSet *)values;

- (void)addPhotosObject:(NSManagedObject *)value;
- (void)removePhotosObject:(NSManagedObject *)value;
- (void)addPhotos:(NSSet *)values;
- (void)removePhotos:(NSSet *)values;

- (void)addVideosObject:(Video *)value;
- (void)removeVideosObject:(Video *)value;
- (void)addVideos:(NSSet *)values;
- (void)removeVideos:(NSSet *)values;

@end
