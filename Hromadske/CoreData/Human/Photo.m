#import "Photo.h"

@interface Photo ()

// Private interface goes here.

@end

@implementation Photo

+ (NSDictionary*)mappingDictionary
{
    return @{@"src" : @"url"};
}

@end
