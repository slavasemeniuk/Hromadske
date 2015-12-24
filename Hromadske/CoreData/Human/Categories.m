#import "Categories.h"

@interface Categories ()

// Private interface goes here.

@end

@implementation Categories

+ (NSArray*)identificationAttributes
{
    return @[@"id"];
}

+ (NSArray*)mappingArray
{
    return @[@"id", @"title", @"created_at", @"views_count"];
}

@end
