//
//  NSString+Validation.m
//  LPCategoryDemo
//
//  Created by dengjiebin on 9/17/15.
//  Copyright (c) 2015 Loopeer. All rights reserved.
//

#import "NSString+Validation.h"

@implementation NSString (Validation)

- (BOOL)lp_isValidPhoneNumber {
    NSString *phoneRegex = @"^1[3|4|5|7|8]\\d{9}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:self];
}


- (BOOL)lp_isValidTelNumber {
    NSString *phoneRegex = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    BOOL isCommonTelPhone = [phoneTest evaluateWithObject:self];
    
    NSString *servicePhoneRegex = @"^(400|800)\\d{7}$";
    NSPredicate *servicePhoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",servicePhoneRegex];
    BOOL isServicePhone = [servicePhoneTest evaluateWithObject:self];
    
    return isCommonTelPhone || isServicePhone;
}


@end
