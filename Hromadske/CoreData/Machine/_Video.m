// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Video.m instead.

#import "_Video.h"

const struct VideoAttributes VideoAttributes = {
	.url = @"url",
};

const struct VideoRelationships VideoRelationships = {
	.article = @"article",
};

@implementation VideoID
@end

@implementation _Video

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Video" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Video";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Video" inManagedObjectContext:moc_];
}

- (VideoID*)objectID {
	return (VideoID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic url;

@dynamic article;

@end

