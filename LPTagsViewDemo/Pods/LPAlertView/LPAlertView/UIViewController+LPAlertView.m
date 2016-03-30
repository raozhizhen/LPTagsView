//
//  UIViewController+LPAlertView.m
//  LPAlertViewDemo
//
//  Created by dengjiebin on 6/17/15.
//  Copyright (c) 2015 Loopeer. All rights reserved.
//

#import "UIViewController+LPAlertView.h"
#import "LPAlertView.h"

@implementation UIViewController (LPAlertView)

- (void)lp_registerKeyboardObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didKeyboardHidden:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didKeyboardShown:) name:UIKeyboardWillShowNotification object:nil];
}

- (void)lp_removeKeyboardObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}


#pragma mark - Private

- (void)didKeyboardHidden:(NSNotification *)notification {
}

- (void)didKeyboardShown:(NSNotification *)notification {
    UIView *window = [[[UIApplication sharedApplication] delegate] window];
    UIView *blackOpaqueView = [window viewWithTag:kLPAlertViewTag];
    
    CGRect frame = blackOpaqueView.frame;
    CGRect newFrame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
    
    CGFloat topH = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
    newFrame.origin.y = (topH - frame.size.height)*3/4;
    blackOpaqueView.frame = newFrame;
}

@end
