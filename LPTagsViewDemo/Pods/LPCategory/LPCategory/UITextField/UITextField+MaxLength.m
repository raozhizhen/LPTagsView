//
//  UITextField+MaxLength.m
//  LPCategoryDemo
//
//  Created by dengjiebin on 9/17/15.
//  Copyright (c) 2015 Loopeer. All rights reserved.
//

#import "UITextField+MaxLength.h"
#import <objc/runtime.h>


static NSString *kMaxLengthKey = @"kMaxLengthKey";

@implementation UITextField (MaxLength)

- (void)setMaxLength:(NSNumber *)maxLength {
    objc_setAssociatedObject(self, &kMaxLengthKey, maxLength, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSNumber *)maxLength {
    return objc_getAssociatedObject(self, &kMaxLengthKey);
}


- (BOOL)lp_textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (!textField.maxLength) {
        return YES;
    }
    
    if (range.length + range.location > textField.text.length) {
        return NO;
    }
    
    NSUInteger len = [textField.text length] + [string length] - range.length;
    
    if (len > [textField.maxLength integerValue]) {
        return NO;
    }
    
    return YES;
}

@end
