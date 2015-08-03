//
//  Articles.h
//  
//
//  Created by Device Ekreative on 03/08/2015.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Categories, Link, Photo, Video;

@interface Articles : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * short_description;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * viewed;
@property (nonatomic, retain) NSNumber * views_count;
@property (nonatomic, retain) NSNumber * vk_id;
@property (nonatomic, retain) NSSet *links;
@property (nonatomic, retain) NSSet *photos;
@property (nonatomic, retain) NSSet *videos;
@property (nonatomic, retain) Categories *category;
@end

@interface Articles (CoreDataGeneratedAccessors)

- (void)addLinksObject:(Link *)value;
- (void)removeLinksObject:(Link *)value;
- (void)addLinks:(NSSet *)values;
- (void)removeLinks:(NSSet *)values;

- (void)addPhotosObject:(Photo *)value;
- (void)removePhotosObject:(Photo *)value;
- (void)addPhotos:(NSSet *)values;
- (void)removePhotos:(NSSet *)values;

- (void)addVideosObject:(Video *)value;
- (void)removeVideosObject:(Video *)value;
- (void)addVideos:(NSSet *)values;
- (void)removeVideos:(NSSet *)values;

@end
