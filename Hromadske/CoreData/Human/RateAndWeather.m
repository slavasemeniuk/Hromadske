#import "RateAndWeather.h"

@interface RateAndWeather ()

// Private interface goes here.

@end

@implementation RateAndWeather

+ (NSDictionary*)mappingDictionary {
    
    return @{@"weather.temperature" : @"weather", @"weather.type" : @"weatherType", @"rates.eur" : @"rateEUR", @"rates.usd" : @"rateUSD"};
    
}


-(void)createInitialRateAndWeather{
    self.weather=@"+5";
    self.weatherType=@"0";
    self.rateEUR=@"10.00";
    self.rateUSD=@"5.00";
}

@end
