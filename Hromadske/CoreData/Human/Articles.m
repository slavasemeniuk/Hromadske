#import "Articles.h"
#import "Constants.h"
#import <RestKit/RestKit.h>
#import <RestKit/CoreData.h>
#import "Photo.h"

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

+ (NSArray*)detailMapping
{
    return @[@"content"];
}

- (NSString*)getContent
{
    self.viewed = [NSNumber numberWithBool:YES];
    
    if (self.content) {
        return self.content;
    }
    
    if (!self.content && self.links.allObjects.firstObject) {
        return @"link";
    }
    
    NSDataDetector* detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:nil];
    
    NSArray* matches = [detector matchesInString:self.short_description options:0 range:NSMakeRange(0, [self.short_description length])];
    
    NSString* short_description = self.short_description;
    
    for (NSTextCheckingResult* match in matches) {
        NSString* link = [[match URL] absoluteString];
        NSString* html_link = [NSString stringWithFormat:@"<a href='%@'>%@</a>", link, link];
        short_description = [short_description stringByReplacingOccurrencesOfString:link withString:html_link];
    }
    
    NSMutableString* imageHtmlContent = [NSMutableString string];
    NSArray* arrayOfImages = [self.photos allObjects];
    
    for (int i = 0; i < [arrayOfImages count]; i++) {
        NSString* imageContent = [NSString stringWithFormat:HTMLITEMIMAGE, [(Photo*)[arrayOfImages objectAtIndex:i] url]];
        [imageHtmlContent appendString:imageContent];
        NSLog(@"%@", imageHtmlContent);
    }
    
    return [NSString stringWithFormat:HTML_CONTENT_WITH_IMAGE, self.title, imageHtmlContent, short_description];
}

// Custom logic goes here.

@end
