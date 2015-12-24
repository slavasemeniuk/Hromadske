// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Employe.m instead.

#import "_Employe.h"

const struct EmployeAttributes EmployeAttributes = {
	.bio = @"bio",
	.identifire = @"identifire",
	.image = @"image",
	.name = @"name",
	.position = @"position",
};

@implementation EmployeID
@end

@implementation _Employe

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Employe" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Employe";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Employe" inManagedObjectContext:moc_];
}

- (EmployeID*)objectID {
	return (EmployeID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"identifireValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"identifire"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic bio;

@dynamic identifire;

- (int16_t)identifireValue {
	NSNumber *result = [self identifire];
	return [result shortValue];
}

- (void)setIdentifireValue:(int16_t)value_ {
	[self setIdentifire:@(value_)];
}

- (int16_t)primitiveIdentifireValue {
	NSNumber *result = [self primitiveIdentifire];
	return [result shortValue];
}

- (void)setPrimitiveIdentifireValue:(int16_t)value_ {
	[self setPrimitiveIdentifire:@(value_)];
}

@dynamic image;

@dynamic name;

@dynamic position;

@end

