//
//  RateAndWeather.m
//  Hromadske
//
//  Created by Admin on 20.04.15.
//  Copyright (c) 2015 Semeniuk Sviatoslav. All rights reserved.
//

#import "RateAndWeather.h"


@implementation RateAndWeather

@dynamic rateUSD;
@dynamic weather;
@dynamic rateEUR;
@dynamic weatherType;

-(void)createInitialRateAndWeather{
    self.weather=@"+5";
    self.weatherType=@"0";
    self.rateEUR=@"10.00";
    self.rateUSD=@"5.00";
}
-(void)updateRateAndWeather:(NSArray *)data{
    self.weatherType=[[[data valueForKey:@"weather"] valueForKey:@" type"]objectAtIndex:0];
    self.weather=[[[data valueForKey:@"weather"] valueForKey:@"temperature"]objectAtIndex:0];
    self.rateEUR=[[[[data valueForKey:@"rates"] valueForKey:@"eur"] objectAtIndex:0] stringValue];
    self.rateUSD=[[[[data valueForKey:@"rates"] valueForKey:@"usd"] objectAtIndex:0] stringValue];
}

@end
