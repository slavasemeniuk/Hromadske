#import "Articles.h"
#import <RestKit/RestKit.h>
#import <RestKit/CoreData.h>

@interface Articles ()

@end

@implementation Articles


+ (NSArray*)identificationAttributes
{
   return @[@"id"];
}

+ (NSArray*)mappingArray
{
    return @[@"id", @"title", @"created_at", @"views_count", @"short_description"];
}

// Custom logic goes here.

@end
