// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Link.h instead.

@import CoreData;

extern const struct LinkAttributes {
	__unsafe_unretained NSString *url;
} LinkAttributes;

extern const struct LinkRelationships {
	__unsafe_unretained NSString *article;
} LinkRelationships;

@class Articles;

@interface LinkID : NSManagedObjectID {}
@end

@interface _Link : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) LinkID* objectID;

@property (nonatomic, strong) NSString* url;

//- (BOOL)validateUrl:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) Articles *article;

//- (BOOL)validateArticle:(id*)value_ error:(NSError**)error_;

@end

@interface _Link (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveUrl;
- (void)setPrimitiveUrl:(NSString*)value;

- (Articles*)primitiveArticle;
- (void)setPrimitiveArticle:(Articles*)value;

@end
