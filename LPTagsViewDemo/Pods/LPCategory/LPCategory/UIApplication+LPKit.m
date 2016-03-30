//
//  UIApplication+LPKit.m
//  LoopeerLibrary
//
//  Created by dengjiebin on 1/2/15.
//  Copyright (c) 2015 Loopeer. All rights reserved.
//

#import "UIApplication+LPKit.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

@implementation UIApplication (LPKit)


- (BOOL)canMakePhoneCall {
    
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://"]]) {
        return NO;
    }
    
    static CTTelephonyNetworkInfo *telephonyNetworkInfo;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        telephonyNetworkInfo = [CTTelephonyNetworkInfo new];
    });
    CTCarrier *carrier = [telephonyNetworkInfo subscriberCellularProvider];
    NSString *mobileNetworkCode = [carrier mobileNetworkCode];
    if (([mobileNetworkCode length] == 0) || ([mobileNetworkCode isEqualToString:@"65535"])) {
        return NO;
    } else {
        return YES;
    }
}

static NSLock *networkOperationCountLock;
static NSInteger networkOperationCount;

+ (void)startNetworkActivity {
    [self createLock];
    [networkOperationCountLock lock];
    networkOperationCount++;
    [networkOperationCountLock unlock];
    [[UIApplication sharedApplication] updateNetworkActivityIndicator];
}

+ (void)finishNetworkActivity {
    [self createLock];
    [networkOperationCountLock lock];
    networkOperationCount--;
    [networkOperationCountLock unlock];
    [[UIApplication sharedApplication] updateNetworkActivityIndicator];
}

+ (void)createLock {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        networkOperationCountLock = [NSLock new];
    });
}

- (void)updateNetworkActivityIndicator {
    [self setNetworkActivityIndicatorVisible:(networkOperationCount > 0 ? TRUE : FALSE)];
    
    [networkOperationCountLock lock];
    if (networkOperationCount < 0) {
        networkOperationCount = 0;
    }
    [networkOperationCountLock unlock];
}


#pragma mark - Local Notification

- (void)scheduleLocalNotificationAtHour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second withText:(NSString *)text {
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSDateComponents *dateComps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[NSDate date]];
    [dateComps setHour:hour];
    [dateComps setMinute:minute];
    [dateComps setSecond:second];
    NSDate *nextDate = [calendar dateFromComponents:dateComps];
    if ([nextDate timeIntervalSinceNow] < 0) {
        nextDate = [nextDate dateByAddingTimeInterval:24 * 60 * 60];
    }
    
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    if (localNotif) {
        localNotif.fireDate = nextDate;
        localNotif.timeZone = [NSTimeZone defaultTimeZone];
        localNotif.alertBody = text;
        localNotif.soundName = UILocalNotificationDefaultSoundName;
        localNotif.applicationIconBadgeNumber = 1;
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    }
}


- (void)showLocalNotification:(NSString *)message {
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    if (localNotification) {
        localNotification.fireDate = [NSDate date];
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        localNotification.alertBody = message;
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }
}



@end
