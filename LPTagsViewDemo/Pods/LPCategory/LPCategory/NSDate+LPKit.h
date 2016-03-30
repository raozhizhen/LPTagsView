//
//  NSDate+LPKit.h
//  LoopeerLibrary
//
//  Created by dengjiebin on 12/31/14.
//  Copyright (c) 2014 Loopeer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (LPKit)

- (NSString *)formatTime;
- (NSString *)formatTimeWithWeekdays;
- (NSString *)formatTimeYMD;
- (NSString *)formatTimeYMDHMS;
- (NSString *)formatTimeYMDHM;
- (NSString *)formatTimeMD;

- (NSString *)formatRemainingTime;



@end
