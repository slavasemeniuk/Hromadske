//
//  DateFormatter.h
//  Hromadske
//
//  Created by Admin on 17.04.15.
//  Copyright (c) 2015 Semeniuk Sviatoslav. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateFormatter : NSObject

+ (DateFormatter *)sharedManager;

- (NSString *)timeIntervalFromDate:(NSDate *)date1;

- (NSString *)convertToTimeStamp: (NSDate *)date;

@end
