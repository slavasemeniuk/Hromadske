// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Photo.h instead.

@import CoreData;

extern const struct PhotoAttributes {
	__unsafe_unretained NSString *url;
} PhotoAttributes;

extern const struct PhotoRelationships {
	__unsafe_unretained NSString *article;
} PhotoRelationships;

@class Articles;

@interface PhotoID : NSManagedObjectID {}
@end

@interface _Photo : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) PhotoID* objectID;

@property (nonatomic, strong) NSString* url;

//- (BOOL)validateUrl:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) Articles *article;

//- (BOOL)validateArticle:(id*)value_ error:(NSError**)error_;

@end

@interface _Photo (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveUrl;
- (void)setPrimitiveUrl:(NSString*)value;

- (Articles*)primitiveArticle;
- (void)setPrimitiveArticle:(Articles*)value;

@end
