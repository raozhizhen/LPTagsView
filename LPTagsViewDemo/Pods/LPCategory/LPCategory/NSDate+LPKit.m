//
//  NSDate+LPKit.m
//  LoopeerLibrary
//
//  Created by dengjiebin on 12/31/14.
//  Copyright (c) 2014 Loopeer. All rights reserved.
//

#import "NSDate+LPKit.h"

@implementation NSDate (LPKit)

- (NSString *)formatTime {
    NSString *_timestamp;
    time_t now;
    time(&now);
    
    int distance = (int)difftime(now, self.timeIntervalSince1970);
    if (distance < 0) distance = 0;
    
    if (distance < 60) {
        _timestamp = [NSString stringWithFormat:@"%d秒前", distance];
    } else if (distance < 60 * 60) {
        distance = distance / 60;
        _timestamp = [NSString stringWithFormat:@"%d分钟前", distance];
    } else if (distance < 60 * 60 * 24) {
        distance = distance / 60 / 60;
        _timestamp = [NSString stringWithFormat:@"%d小时前", distance];
    } else if (distance < 60 * 60 * 24 * 7) {
        distance = distance / 60 / 60 / 24;
        _timestamp = [NSString stringWithFormat:@"%d天前", distance];
    } else if (distance < 60 * 60 * 24 * 7 * 4) {
        distance = distance / 60 / 60 / 24 / 7;
        _timestamp = [NSString stringWithFormat:@"%d周前", distance];
    } else {
        static NSDateFormatter *dateFormatter = nil;
        if (dateFormatter == nil) {
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"M月d日 HH:mm"];
        }
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.timeIntervalSince1970];
        _timestamp = [dateFormatter stringFromDate:date];
    }
    return _timestamp;
}

- (NSString *)formatTimeWithWeekdays {
    NSDateFormatter *ndf = [[NSDateFormatter alloc] init];
    [ndf setDateFormat:@"yy.MM.dd"];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.timeIntervalSince1970];
    NSString *normalYear = [ndf stringFromDate:date];
    
    [ndf setDateFormat:@"c"];
    NSInteger weekdayIndex = [[ndf stringFromDate:date] integerValue];
    NSString *weekday;
    switch (weekdayIndex) {
        case 1:
            weekday = @"日";
            break;
        case 2:
            weekday = @"一";
            break;
        case 3:
            weekday = @"二";
            break;
        case 4:
            weekday = @"三";
            break;
        case 5:
            weekday = @"四";
            break;
        case 6:
            weekday = @"五";
            break;
        case 7:
            weekday = @"六";
            break;
        default:
            break;
    }
    
    return [NSString stringWithFormat:@"%@ 星期%@", normalYear, weekday];
}

- (NSString *)formatTimeYMD {
    NSDateFormatter *ndf = [[NSDateFormatter alloc] init];
    [ndf setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.timeIntervalSince1970];
    return [ndf stringFromDate:date];
}

- (NSString *)formatTimeYMDHMS {
    NSDateFormatter *ndf = [[NSDateFormatter alloc] init];
    [ndf setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.timeIntervalSince1970];
    return [ndf stringFromDate:date];
}

- (NSString *)formatTimeYMDHM {
    NSDateFormatter *ndf = [[NSDateFormatter alloc] init];
    [ndf setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.timeIntervalSince1970];
    return [ndf stringFromDate:date];
}

- (NSString *)formatTimeMD {
    NSDateFormatter *ndf = [[NSDateFormatter alloc] init];
    [ndf setDateFormat:@"MM月dd日"];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.timeIntervalSince1970];
    return [ndf stringFromDate:date];
}

- (NSString *)formatRemainingTime {
    NSString *_timestamp;
    time_t now;
    time(&now);
    
    int distance = (int)difftime(self.timeIntervalSince1970, now);
    
    int mimute = 60;
    int hour = mimute * 60;
    int day = hour * 24;
    
    int intervaDays = distance / day;
    if (intervaDays > 0) {
        _timestamp = [NSString stringWithFormat:@"%d天", intervaDays];
        
    } else if (intervaDays <= 0) {
        _timestamp = @"到期";
    }
    
    return _timestamp;
}

@end
