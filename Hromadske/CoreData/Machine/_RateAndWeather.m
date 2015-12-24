// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RateAndWeather.m instead.

#import "_RateAndWeather.h"

const struct RateAndWeatherAttributes RateAndWeatherAttributes = {
	.rateEUR = @"rateEUR",
	.rateUSD = @"rateUSD",
	.weather = @"weather",
	.weatherType = @"weatherType",
};

@implementation RateAndWeatherID
@end

@implementation _RateAndWeather

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"RateAndWeather" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"RateAndWeather";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"RateAndWeather" inManagedObjectContext:moc_];
}

- (RateAndWeatherID*)objectID {
	return (RateAndWeatherID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic rateEUR;

@dynamic rateUSD;

@dynamic weather;

@dynamic weatherType;

@end

