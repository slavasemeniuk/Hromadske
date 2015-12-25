#import "Categories.h"

@interface Categories ()

// Private interface goes here.

@end

@implementation Categories

+ (NSArray*)identificationAttributes
{
    return @[@"name"];
}

+ (NSDictionary*)mappingDict
{
    return @{@"category" : @"name"};
}

@end
