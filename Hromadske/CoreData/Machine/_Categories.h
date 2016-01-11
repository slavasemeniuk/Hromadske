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

@property (nonatomic, strong) NSSet *articles;

- (NSMutableSet*)articlesSet;

@end

@interface _Categories (ArticlesCoreDataGeneratedAccessors)
- (void)addArticles:(NSSet*)value_;
- (void)removeArticles:(NSSet*)value_;
- (void)addArticlesObject:(Articles*)value_;
- (void)removeArticlesObject:(Articles*)value_;

@end

@interface _Categories (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (NSMutableSet*)primitiveArticles;
- (void)setPrimitiveArticles:(NSMutableSet*)value;

@end
