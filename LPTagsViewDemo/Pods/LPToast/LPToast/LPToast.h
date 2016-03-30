//
//  LPToast.h
//  PowerHabit
//
//  Created by dengjiebin on 11/29/14.
//  Copyright (c) 2014 Loopeer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MZAppearance.h"
#import <UIKit/UIKit.h>
#import "CRToast.h"

typedef NS_ENUM(NSInteger, LPToastPosition) {
    LPToastPositionTop,
    LPToastPositionCenter,
    LPToastPositionBottom
};


@interface LPToast : NSObject

#pragma mark - Properties


// Android Style Toast Property
@property (nonatomic, assign) LPToastPosition toastPosition MZ_APPEARANCE_SELECTOR;
@property (nonatomic, assign) NSUInteger toastDuration MZ_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGFloat toastTextMargin MZ_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGFloat toastCornerRadius MZ_APPEARANCE_SELECTOR;

// Toast & Notification Style Toast shared Property
@property (nonatomic, strong) UIFont *toastFont MZ_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *toastTextColor MZ_APPEARANCE_SELECTOR;


// Notification Style Toast Property

@property (nonatomic, assign) CRToastType toastType MZ_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CRToastPresentationType toastPresentationType MZ_APPEARANCE_SELECTOR;
@property (nonatomic, assign) NSTextAlignment toastTextAlignment MZ_APPEARANCE_SELECTOR;
@property (nonatomic, assign) NSUInteger toastTimeInterval MZ_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CRToastAnimationType toastAnimationInType MZ_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CRToastAnimationType toastAnimationOutType MZ_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CRToastAnimationDirection toastAnimationInDirection MZ_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CRToastAnimationDirection toastAnimationOutDirection MZ_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *toastBackgroundColor MZ_APPEARANCE_SELECTOR;


#pragma mark - MZAppearance

+ (id)appearance;

#pragma mark - Android Toast style

- (void)showToast:(NSString *)message;
+ (void)showToast:(NSString *)message;


#pragma mark - Notification Style

- (void)showToastNotificationStyle:(NSString *)message;
+ (void)showToastNotificationStyle:(NSString *)message;


@end
