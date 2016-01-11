#import "RateAndWeather.h"

@interface RateAndWeather ()

// Private interface goes here.

@end

@implementation RateAndWeather

+ (NSDictionary*)mappingDictionary {
    
    return @{@"weather.temperature" : @"weather", @"weather.type" : @"weatherType", @"rates.eur" : @"rateEUR", @"rates.usd" : @"rateUSD", @"streaming" : @"streaming", @"streaming.title" : @"streamingTitle"};
    
}

@end
