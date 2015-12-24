// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Link.m instead.

#import "_Link.h"

const struct LinkAttributes LinkAttributes = {
	.url = @"url",
};

const struct LinkRelationships LinkRelationships = {
	.article = @"article",
};

@implementation LinkID
@end

@implementation _Link

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Link" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Link";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Link" inManagedObjectContext:moc_];
}

- (LinkID*)objectID {
	return (LinkID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic url;

@dynamic article;

@end

