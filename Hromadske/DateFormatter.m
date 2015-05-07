//
//  DateFormatter.m
//  Hromadske
//
//  Created by Admin on 17.04.15.
//  Copyright (c) 2015 Semeniuk Sviatoslav. All rights reserved.
//

#import "DateFormatter.h"

#define SECOND 1
#define MINUTE (60*SECOND)
#define HOUR (60*MINUTE)
#define DAY (24*HOUR)
#define MONTH (30*DAY)

@interface DateFormatter ()

{
    NSDateFormatter *_df;
}

@end

@implementation DateFormatter

+ (DateFormatter *)sharedManager {
    static DateFormatter *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[DateFormatter alloc] init];
    });
    
    return _manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _df = [[NSDateFormatter alloc] init];
        [_df setDateStyle:NSDateFormatterMediumStyle];
    }
    return self;
}

- (NSDate *)convertToDateFromTimeStamp:(NSNumber *)value{
    double timestamp = [value doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    return date;
}

- (NSString *)convertToTimeStamp: (NSDate *)date{
    NSTimeInterval timeInterval = [date timeIntervalSince1970];
    NSString *res = [NSString stringWithFormat:@"%f",timeInterval];
    NSLog(@"%@",res);
    return res;
}

- (NSString *)timeIntervalFromDate:(NSDate *)date1{
    
    NSDate * d2 = [NSDate date];
    
    NSTimeInterval delta = [d2 timeIntervalSinceDate:date1];
    NSString *res = [[NSString alloc]init];
    if (delta < 2 * MINUTE) {
        return @"Хвилину тому";
    }
    if (delta < 45 * MINUTE) {
        int minutes = ((double)delta/MINUTE);
        if ((minutes>4&&minutes<=20)||(minutes%10==0)||(minutes%10>=5)) {
            res =@"хвилин тому";
        }
        else
        if (minutes%10==1) {
            res =@"хвилина тому";
        }
        else
        if (minutes%10>=1&&minutes%10<=4) {
            res =@"хвилини тому";
        }
        return [NSString stringWithFormat:@"%d %@", minutes, res];
    }
    if (delta < 90*MINUTE) {
        return @"Годину тому";
    }
    if (delta < 24 * HOUR) {
        int hours = ((double)delta/HOUR);
        if ((hours>4&&hours<=20)||(hours%10==0)||(hours%10>=5)) {
            res =@"годин тому";
        }
        else
            if (hours%10==1) {
                res =@"година тому";
            }
            else
                if (hours%10>=1&&hours%10<=4) {
                    res =@"години тому";
                }
        return [NSString stringWithFormat:@"%d %@", hours, res];
    }
    if (delta < 48 * HOUR) {
        return @"Вчора";
    }
    else
    {
        return [_df stringFromDate: date1];
    }
}


@end
