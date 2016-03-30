//
//  UIViewController+TextFieldDelegate.m
//  LPCategoryDemo
//
//  Created by dengjiebin on 9/17/15.
//  Copyright (c) 2015 Loopeer. All rights reserved.
//

#import "UIViewController+TextFieldDelegate.h"

@implementation UIViewController (TextFieldDelegate)

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
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
