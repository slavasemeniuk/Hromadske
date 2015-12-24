// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Categories.h instead.

@import CoreData;

extern const struct CategoriesAttributes {
	__unsafe_unretained NSString *name;
} CategoriesAttributes;

extern const struct CategoriesRelationships {
	__unsafe_unretained NSString *articles;
} CategoriesRelationships;

@class Articles;

@interface CategoriesID : NSManagedObjectID {}
@end

@interface _Categories : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) CategoriesID* objectID;

@property (nonatomic, strong) NSString* name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) Articles *articles;

//- (BOOL)validateArticles:(id*)value_ error:(NSError**)error_;

@end

@interface _Categories (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (Articles*)primitiveArticles;
- (void)setPrimitiveArticles:(Articles*)value;

@end
