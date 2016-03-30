//
//  LPToast.m
//  PowerHabit
//
//  Created by dengjiebin on 11/29/14.
//  Copyright (c) 2014 Loopeer. All rights reserved.
//

#import "LPToast.h"
#import "CRToast.h"
#import "MBProgressHUD.h"

NSString *NSStringFromLPToastPosition(LPToastPosition position) {
    switch (position) {
        case LPToastPositionTop:
            return @"top";
        case LPToastPositionCenter:
            return @"center";
        case LPToastPositionBottom:
            return @"bottom";
    }
    return nil;
};

#pragma mark - Option Constant Definitions


@interface LPToast() <MZAppearance>

@end

@implementation LPToast

#pragma mark - Init

- (instancetype)init {
    self = [super init];
    if (self) {
        // default toast
        self.toastDuration = 2;
        self.toastPosition = LPToastPositionBottom;
        self.toastCornerRadius = 5.f;
        self.toastTextMargin = 10.f;
        
        // default notifications style toast
        self.toastType = CRToastTypeNavigationBar;
        self.toastPresentationType = CRToastPresentationTypeCover;
        self.toastTextAlignment = NSTextAlignmentCenter;
        self.toastTimeInterval = 1;
        self.toastAnimationInType = CRToastAnimationTypeGravity;
        self.toastAnimationOutType = CRToastAnimationTypeGravity;
        self.toastAnimationInDirection = CRToastAnimationDirectionTop;
        self.toastAnimationOutDirection = CRToastAnimationDirectionTop;
        self.toastBackgroundColor = [UIColor orangeColor];
        
        // shared
        self.toastFont = [UIFont systemFontOfSize:16];
        self.toastTextColor = [UIColor whiteColor];


        // apply the appearance
        [[[self class] appearance] applyInvocationTo:self];
    }
    return self;
}



#pragma mark - appearance

+ (id)appearance {
    return [MZAppearance appearanceForClass:[self class]];
}


+ (CGFloat)calcOffset:(LPToastPosition)position {
    CGRect size = [[UIScreen mainScreen] bounds];
    switch (position) {
        case LPToastPositionBottom:
            return size.size.height/4;
            break;
        case LPToastPositionCenter:
            return 0;
            break;
        case LPToastPositionTop:
            return -size.size.height/4;
            break;
        default:
            break;
    }
}

#pragma mark - Toast

+ (void)showToast:(NSString *)message {
    LPToast *toast = [[LPToast alloc] init];
    [LPToast makeToast:message withToast:toast];
}


- (void)showToast:(NSString *)message {
    [LPToast makeToast:message withToast:self];
}

#pragma mark - Private

+ (void)makeToast:(NSString *)message withToast:(LPToast *)toast {
    UIWindow *mainWindow = [[UIApplication sharedApplication] keyWindow];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:mainWindow animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = message;
    hud.detailsLabelFont = toast.toastFont;
    hud.detailsLabelColor = toast.toastTextColor;
    hud.margin = toast.toastTextMargin;
    hud.cornerRadius = toast.toastCornerRadius;
    hud.yOffset = [LPToast calcOffset:toast.toastPosition];
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:NO afterDelay:toast.toastDuration];
}

#pragma mark - Notification style

+ (void)showToastNotificationStyle:(NSString *)message {
    LPToast *toast = [[LPToast alloc] init];
    [CRToastManager showNotificationWithOptions:[LPToast buildOptions:toast withMessage:message] completionBlock:nil];
}

- (void)showToastNotificationStyle:(NSString *)message {
    [CRToastManager showNotificationWithOptions:[LPToast buildOptions:self withMessage:message] completionBlock:nil];
}

+ (NSMutableDictionary *)buildOptions:(LPToast *)toast withMessage:(NSString *)message {
    NSMutableDictionary *options = [NSMutableDictionary new];
    [options setObject:@(toast.toastType) forKey:kCRToastNotificationTypeKey];
    [options setObject:@(toast.toastPresentationType) forKey:kCRToastNotificationPresentationTypeKey];
    [options setObject:@(toast.toastTextAlignment) forKey:kCRToastTextAlignmentKey];
    [options setObject:@(toast.toastTimeInterval) forKey:kCRToastTimeIntervalKey];
    [options setObject:toast.toastBackgroundColor forKey:kCRToastBackgroundColorKey];
    [options setObject:@(toast.toastAnimationInType) forKey:kCRToastAnimationInTypeKey];
    [options setObject:@(toast.toastAnimationOutType) forKey:kCRToastAnimationOutTypeKey];
    [options setObject:@(toast.toastAnimationInDirection) forKey:kCRToastAnimationInDirectionKey];
    [options setObject:@(toast.toastAnimationOutDirection) forKey:kCRToastAnimationOutDirectionKey];
    [options setObject:toast.toastFont forKey:kCRToastFontKey];
    [options setObject:toast.toastTextColor forKey:kCRToastTextColorKey];

    // append message
    [options setObject:message forKey:kCRToastTextKey];
    return options;
}

@end
