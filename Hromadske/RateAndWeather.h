//
//  RateAndWeather.h
//  Hromadske
//
//  Created by Admin on 20.04.15.
//  Copyright (c) 2015 Semeniuk Sviatoslav. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface RateAndWeather : NSManagedObject

@property (nonatomic, retain) NSString * rateUSD;
@property (nonatomic, retain) NSString * weather;
@property (nonatomic, retain) NSString * weatherType;
@property (nonatomic, retain) NSString * rateEUR;

-(void)createInitialRateAndWeather;
-(void)updateRateAndWeather:(NSArray *)data;

@end
