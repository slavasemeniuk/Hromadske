#import "_Articles.h"

@interface Articles : _Articles {}

+ (NSArray*)identificationAttributes;
+ (NSArray*)mappingArray;
+ (NSArray*)detailMapping;

- (NSString*)getContent;
@end
