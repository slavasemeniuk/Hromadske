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


@implementation DateFormatter

+ (DateFormatter *)sharedManager {
    static DateFormatter *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[DateFormatter alloc] init];
    });
    
    return _manager;
}

-(NSString *)convertDateFromTimeStamp:(NSNumber *)value{
    double timestamp = [value floatValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    
    
    return [self timeIntervalFromDate:date];
}

-(NSString *)timeIntervalFromDate:(NSDate *)date1{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * d2 = [NSDate date];
    
    NSTimeInterval delta = [d2 timeIntervalSinceDate:date1];
    NSString *res = [[NSString alloc]init];
    if (delta < 2 * MINUTE) {
        return @"Хвилину назад";
    }
    if (delta < 45 * MINUTE) {
        int minutes = ((double)delta/MINUTE);
        if ((minutes>4&&minutes<=20)||(minutes%10==0)) {
            res =@"хвилин назад";
        }
        else
        if (minutes%10==1) {
            res =@"хвилина назад";
        }
        else
        if (minutes%10>=1&&minutes%10<=4) {
            res =@"хвилини назад";
        }
        return [NSString stringWithFormat:@"%d %@", minutes, res];
    }
    if (delta < 90*MINUTE) {
        return @"Годину назад";
    }
    if (delta < 24 * HOUR) {
        int hours = ((double)delta/HOUR);
        if ((hours>4&&hours<=20)||(hours%10==0)) {
            res =@"хвилин назад";
        }
        else
            if (hours%10==1) {
                res =@"хвилина назад";
            }
            else
                if (hours%10>=1&&hours%10<=4) {
                    res =@"хвилини назад";
                }
        return [NSString stringWithFormat:@"%d %@", hours, res];
    }
    if (delta < 48 * HOUR) {
        return @"Вчора";
    }
    else
    {
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        return [dateFormatter stringFromDate: date1];
    }
}


@end
