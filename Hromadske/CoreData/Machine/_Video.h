// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Video.h instead.

@import CoreData;

extern const struct VideoAttributes {
	__unsafe_unretained NSString *url;
} VideoAttributes;

extern const struct VideoRelationships {
	__unsafe_unretained NSString *article;
} VideoRelationships;

@class Articles;

@interface VideoID : NSManagedObjectID {}
@end

@interface _Video : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) VideoID* objectID;

@property (nonatomic, strong) NSString* url;

//- (BOOL)validateUrl:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) Articles *article;

//- (BOOL)validateArticle:(id*)value_ error:(NSError**)error_;

@end

@interface _Video (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveUrl;
- (void)setPrimitiveUrl:(NSString*)value;

- (Articles*)primitiveArticle;
- (void)setPrimitiveArticle:(Articles*)value;

@end
