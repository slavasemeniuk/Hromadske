// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Articles.h instead.

@import CoreData;

extern const struct ArticlesAttributes {
	__unsafe_unretained NSString *content;
	__unsafe_unretained NSString *created_at;
	__unsafe_unretained NSString *customContent;
	__unsafe_unretained NSString *id;
	__unsafe_unretained NSString *short_description;
	__unsafe_unretained NSString *title;
	__unsafe_unretained NSString *viewed;
	__unsafe_unretained NSString *views_count;
	__unsafe_unretained NSString *vk_id;
} ArticlesAttributes;

extern const struct ArticlesRelationships {
	__unsafe_unretained NSString *category;
	__unsafe_unretained NSString *links;
	__unsafe_unretained NSString *photos;
	__unsafe_unretained NSString *videos;
} ArticlesRelationships;

@class Categories;
@class Link;
@class Photo;
@class Video;

@interface ArticlesID : NSManagedObjectID {}
@end

@interface _Articles : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) ArticlesID* objectID;

@property (nonatomic, strong) NSString* content;

//- (BOOL)validateContent:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* created_at;

//- (BOOL)validateCreated_at:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* customContent;

//- (BOOL)validateCustomContent:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* id;

@property (atomic) int16_t idValue;
- (int16_t)idValue;
- (void)setIdValue:(int16_t)value_;

//- (BOOL)validateId:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* short_description;

//- (BOOL)validateShort_description:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* title;

//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* viewed;

@property (atomic) BOOL viewedValue;
- (BOOL)viewedValue;
- (void)setViewedValue:(BOOL)value_;

//- (BOOL)validateViewed:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* views_count;

@property (atomic) int16_t views_countValue;
- (int16_t)views_countValue;
- (void)setViews_countValue:(int16_t)value_;

//- (BOOL)validateViews_count:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* vk_id;

@property (atomic) int16_t vk_idValue;
- (int16_t)vk_idValue;
- (void)setVk_idValue:(int16_t)value_;

//- (BOOL)validateVk_id:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) Categories *category;

//- (BOOL)validateCategory:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *links;

- (NSMutableSet*)linksSet;

@property (nonatomic, strong) NSSet *photos;

- (NSMutableSet*)photosSet;

@property (nonatomic, strong) NSSet *videos;

- (NSMutableSet*)videosSet;

@end

@interface _Articles (LinksCoreDataGeneratedAccessors)
- (void)addLinks:(NSSet*)value_;
- (void)removeLinks:(NSSet*)value_;
- (void)addLinksObject:(Link*)value_;
- (void)removeLinksObject:(Link*)value_;

@end

@interface _Articles (PhotosCoreDataGeneratedAccessors)
- (void)addPhotos:(NSSet*)value_;
- (void)removePhotos:(NSSet*)value_;
- (void)addPhotosObject:(Photo*)value_;
- (void)removePhotosObject:(Photo*)value_;

@end

@interface _Articles (VideosCoreDataGeneratedAccessors)
- (void)addVideos:(NSSet*)value_;
- (void)removeVideos:(NSSet*)value_;
- (void)addVideosObject:(Video*)value_;
- (void)removeVideosObject:(Video*)value_;

@end

@interface _Articles (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveContent;
- (void)setPrimitiveContent:(NSString*)value;

- (NSDate*)primitiveCreated_at;
- (void)setPrimitiveCreated_at:(NSDate*)value;

- (NSString*)primitiveCustomContent;
- (void)setPrimitiveCustomContent:(NSString*)value;

- (NSNumber*)primitiveId;
- (void)setPrimitiveId:(NSNumber*)value;

- (int16_t)primitiveIdValue;
- (void)setPrimitiveIdValue:(int16_t)value_;

- (NSString*)primitiveShort_description;
- (void)setPrimitiveShort_description:(NSString*)value;

- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;

- (NSNumber*)primitiveViewed;
- (void)setPrimitiveViewed:(NSNumber*)value;

- (BOOL)primitiveViewedValue;
- (void)setPrimitiveViewedValue:(BOOL)value_;

- (NSNumber*)primitiveViews_count;
- (void)setPrimitiveViews_count:(NSNumber*)value;

- (int16_t)primitiveViews_countValue;
- (void)setPrimitiveViews_countValue:(int16_t)value_;

- (NSNumber*)primitiveVk_id;
- (void)setPrimitiveVk_id:(NSNumber*)value;

- (int16_t)primitiveVk_idValue;
- (void)setPrimitiveVk_idValue:(int16_t)value_;

- (Categories*)primitiveCategory;
- (void)setPrimitiveCategory:(Categories*)value;

- (NSMutableSet*)primitiveLinks;
- (void)setPrimitiveLinks:(NSMutableSet*)value;

- (NSMutableSet*)primitivePhotos;
- (void)setPrimitivePhotos:(NSMutableSet*)value;

- (NSMutableSet*)primitiveVideos;
- (void)setPrimitiveVideos:(NSMutableSet*)value;

@end
