//
//  UIApplication+LPKit.h
//  LoopeerLibrary
//
//  Created by dengjiebin on 1/2/15.
//  Copyright (c) 2015 Loopeer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (LPKit)


/**
 * Check if the device can actually make a phone call
 *
 */
- (BOOL)canMakePhoneCall;


/**
 * Start the network activity
 *
 */
+ (void)startNetworkActivity;


/**
 * Finish the network activity
 *
 */
+ (void)finishNetworkActivity;

- (void)updateNetworkActivityIndicator;


/**
 * Schedule local notification At specified time
 *
 */
- (void)scheduleLocalNotificationAtHour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second withText:(NSString *)text;


/**
 * Show the local notification now
 *
 */
- (void)showLocalNotification:(NSString *)message;

@end
