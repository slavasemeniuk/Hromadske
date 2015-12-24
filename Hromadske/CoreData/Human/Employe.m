#import "Employe.h"

@interface Employe ()

// Private interface goes here.

@end

@implementation Employe


+ (NSArray*)identificationAttributes
{
    return @[@"identifire"];
}

+ (NSArray*)mappingArray
{
    return @[@"name", @"bio", @"position"];
}

+ (NSDictionary*)mappingDict
{
    return @{@"id" : @"identifire", @"photo":@"image" };
}


@end
