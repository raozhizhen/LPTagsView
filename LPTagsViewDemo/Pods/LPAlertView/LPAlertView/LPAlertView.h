//
//  LPAlertView.h
//  LoopeerAlertView
//
//  Created by Dengjiebin on 14-12-30.
//  Copyright (c) 2014年 Loopeer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DQAlertView.h"
#import "EDStarRating.h"
#import "MZAppearance.h"

typedef void (^LPAlertViewCompletionBlock) (DQAlertView *alertView, NSInteger buttonIndex);
typedef void (^LPAlertViewTextFieldCompletionBlock) (DQAlertView *alertView, UITextField *textField, NSInteger buttonIndex);
typedef void (^LPAlertViewRateTextFieldCompletionBlock) (DQAlertView *alertView, EDStarRating *starRating, UITextField *textField, NSInteger buttonIndex);

extern NSInteger const kLPAlertViewTag;
extern NSInteger const kLPAlertViewCancelButtonIndex;
extern NSInteger const kLPAlertViewOtherButtonIndex;


@interface LPAlertView : NSObject


@property (nonatomic, strong) UIColor *textColor MZ_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIFont *textFont MZ_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *seperatorColorKey MZ_APPEARANCE_SELECTOR;

@property (nonatomic, strong) UIColor *cancelButtonTitleColor MZ_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIFont *cancelButtonTitleFont MZ_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *otherButtonTitleColor MZ_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIFont *otherButtonTitleFont MZ_APPEARANCE_SELECTOR;

@property (nonatomic, strong) UIColor *titleColor MZ_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIFont *titleFont MZ_APPEARANCE_SELECTOR;

@property (nonatomic, strong) UIColor *messageColor MZ_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIFont *messageFont MZ_APPEARANCE_SELECTOR;
@property (nonatomic, assign) NSTextAlignment messageTextAlignment MZ_APPEARANCE_SELECTOR;

@property (nonatomic, strong) UIColor *textFieldBackgroundColor MZ_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *textFieldTextColor MZ_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIFont *textFieldTextFont MZ_APPEARANCE_SELECTOR;
@property (nonatomic, assign) NSTextAlignment textFieldTextAlignment MZ_APPEARANCE_SELECTOR;

// Customize the animation
@property (nonatomic, assign) DQAlertViewAnimationType appearAnimationType;
@property (nonatomic, assign) DQAlertViewAnimationType disappearAnimationType;
@property (nonatomic, assign) NSTimeInterval appearTime;
@property (nonatomic, assign) NSTimeInterval disappearTime;


#pragma mark - MZAppearance

+ (id)appearance;


#pragma mark - Message

+ (void)alertWithTitle:(NSString *)title
           withMessage:(NSString *)message
     cancelButtonTitle:(NSString *)cancelButtonTitle
      otherButtonTitle:(NSString *)otherButtonTitle
   withCompletionBlock:(LPAlertViewCompletionBlock)completionBlock;


+ (void)alertWithTitle:(NSString *)title
           withMessage:(NSString *)message
     cancelButtonTitle:(NSString *)cancelButtonTitle
      otherButtonTitle:(NSString *)otherButtonTitle
   withDissmissOutside:(BOOL)shouldDismissOutside
   withCompletionBlock:(LPAlertViewCompletionBlock)completionBlock;


#pragma mark - Input Text

+ (void)alertWithPlaceholder:(NSString *)placeholder
                   withTitle:(NSString *)title
                 withMessage:(NSString *)message
           cancelButtonTitle:(NSString *)cancelButtonTitle
            otherButtonTitle:(NSString *)otherButtonTitle
         withCompletionBlock:(LPAlertViewTextFieldCompletionBlock)completionBlock;


#pragma mark - Rate & Input Text

+ (void)alertWithRate:(float)rate
      WithPlaceholder:(NSString *)placeholder
    cancelButtonTitle:(NSString *)cancelButtonTitle
     otherButtonTitle:(NSString *)otherButtonTitle
  withCompletionBlock:(LPAlertViewRateTextFieldCompletionBlock)completionBlock;


@end
