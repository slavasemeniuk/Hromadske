// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Categories.m instead.

#import "_Categories.h"

const struct CategoriesAttributes CategoriesAttributes = {
	.name = @"name",
};

const struct CategoriesRelationships CategoriesRelationships = {
	.articles = @"articles",
};

@implementation CategoriesID
@end

@implementation _Categories

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Categories" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Categories";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Categories" inManagedObjectContext:moc_];
}

- (CategoriesID*)objectID {
	return (CategoriesID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic name;

@dynamic articles;

- (NSMutableSet*)articlesSet {
	[self willAccessValueForKey:@"articles"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"articles"];

	[self didAccessValueForKey:@"articles"];
	return result;
}

@end

