//
//  UIView+LPKit.h
//  LoopeerLibrary
//
//  Created by dengjiebin on 12/31/14.
//  Copyright (c) 2014 Loopeer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

@interface UIView (LPKit)

@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;

- (void)showBorder;
- (void)hideBorder;

- (void)setBorderColor:(UIColor *)color;
- (void)setBorderWidth:(CGFloat)width;

#pragma mark - Round Corners

- (void)setRoundedCorners:(UIRectCorner)corners radius:(CGSize)size;

#pragma mark - Animation

/**
 * Create a shake effect on the UIView
 * 
 */
- (void)shakeView;

/**
 * Create a pulse effect on th UIView
 *
 */
- (void)pulseViewWithTime:(CGFloat)seconds;



@end
