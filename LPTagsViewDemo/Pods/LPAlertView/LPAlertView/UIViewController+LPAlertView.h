//
//  UIViewController+LPAlertView.h
//  LPAlertViewDemo
//
//  Created by dengjiebin on 6/17/15.
//  Copyright (c) 2015 Loopeer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (LPAlertView)

- (void)lp_registerKeyboardObserver;
- (void)lp_removeKeyboardObserver;

@end
