// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Articles.m instead.

#import "_Articles.h"

const struct ArticlesAttributes ArticlesAttributes = {
	.content = @"content",
	.created_at = @"created_at",
	.customContent = @"customContent",
	.id = @"id",
	.short_description = @"short_description",
	.title = @"title",
	.viewed = @"viewed",
	.views_count = @"views_count",
	.vk_id = @"vk_id",
};

const struct ArticlesRelationships ArticlesRelationships = {
	.category = @"category",
	.links = @"links",
	.photos = @"photos",
	.videos = @"videos",
};

@implementation ArticlesID
@end

@implementation _Articles

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Articles" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Articles";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Articles" inManagedObjectContext:moc_];
}

- (ArticlesID*)objectID {
	return (ArticlesID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"idValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"id"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"viewedValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"viewed"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"views_countValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"views_count"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"vk_idValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"vk_id"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic content;

@dynamic created_at;

@dynamic customContent;

@dynamic id;

- (int16_t)idValue {
	NSNumber *result = [self id];
	return [result shortValue];
}

- (void)setIdValue:(int16_t)value_ {
	[self setId:@(value_)];
}

- (int16_t)primitiveIdValue {
	NSNumber *result = [self primitiveId];
	return [result shortValue];
}

- (void)setPrimitiveIdValue:(int16_t)value_ {
	[self setPrimitiveId:@(value_)];
}

@dynamic short_description;

@dynamic title;

@dynamic viewed;

- (BOOL)viewedValue {
	NSNumber *result = [self viewed];
	return [result boolValue];
}

- (void)setViewedValue:(BOOL)value_ {
	[self setViewed:@(value_)];
}

- (BOOL)primitiveViewedValue {
	NSNumber *result = [self primitiveViewed];
	return [result boolValue];
}

- (void)setPrimitiveViewedValue:(BOOL)value_ {
	[self setPrimitiveViewed:@(value_)];
}

@dynamic views_count;

- (int16_t)views_countValue {
	NSNumber *result = [self views_count];
	return [result shortValue];
}

- (void)setViews_countValue:(int16_t)value_ {
	[self setViews_count:@(value_)];
}

- (int16_t)primitiveViews_countValue {
	NSNumber *result = [self primitiveViews_count];
	return [result shortValue];
}

- (void)setPrimitiveViews_countValue:(int16_t)value_ {
	[self setPrimitiveViews_count:@(value_)];
}

@dynamic vk_id;

- (int16_t)vk_idValue {
	NSNumber *result = [self vk_id];
	return [result shortValue];
}

- (void)setVk_idValue:(int16_t)value_ {
	[self setVk_id:@(value_)];
}

- (int16_t)primitiveVk_idValue {
	NSNumber *result = [self primitiveVk_id];
	return [result shortValue];
}

- (void)setPrimitiveVk_idValue:(int16_t)value_ {
	[self setPrimitiveVk_id:@(value_)];
}

@dynamic category;

@dynamic links;

- (NSMutableSet*)linksSet {
	[self willAccessValueForKey:@"links"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"links"];

	[self didAccessValueForKey:@"links"];
	return result;
}

@dynamic photos;

- (NSMutableSet*)photosSet {
	[self willAccessValueForKey:@"photos"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"photos"];

	[self didAccessValueForKey:@"photos"];
	return result;
}

@dynamic videos;

- (NSMutableSet*)videosSet {
	[self willAccessValueForKey:@"videos"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"videos"];

	[self didAccessValueForKey:@"videos"];
	return result;
}

@end

