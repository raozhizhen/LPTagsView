//
//  UIView+LPKit.m
//  LoopeerLibrary
//
//  Created by dengjiebin on 12/31/14.
//  Copyright (c) 2014 Loopeer. All rights reserved.
//

#import "UIView+LPKit.h"

@implementation UIView (LPKit)

- (void)showBorder {
    
    if (![self borderColor]) {
        [self setBorderColor:[UIColor redColor]];
    }
    
    if (![self borderWidth]) {
        [self setBorderWidth:1];
    }
    
    [[self layer] setBorderColor:[self borderColor].CGColor];
    [[self layer] setBorderWidth:[self borderWidth]];
}

- (void) hideBorder{
    [[self layer] setBorderWidth:0.0];
    [[self layer] setBorderColor:[UIColor clearColor].CGColor];
}


#pragma mark - Round corners

- (void)setRoundedCorners:(UIRectCorner)corners radius:(CGSize)size {
    UIBezierPath* maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:size];
    
    CAShapeLayer* maskLayer = [CAShapeLayer new];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    
    self.layer.mask = maskLayer;
}


#pragma mark - Border Color

static char * kBorderColorKey = "border color key";

- (void)setBorderColor:(UIColor *)color {
    objc_setAssociatedObject(self, kBorderColorKey, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)borderColor {
    return objc_getAssociatedObject(self, kBorderColorKey);
}

#pragma mark - Border Width

static char * kBorderWidthKey = "border width key";

- (void)setBorderWidth:(CGFloat)width {
    objc_setAssociatedObject(self, kBorderWidthKey, @(width), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)borderWidth {
    return [objc_getAssociatedObject(self, kBorderWidthKey) floatValue];
}



- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

#pragma mark - Animation

- (void)shakeView {
    CAKeyframeAnimation *shake = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    shake.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-5.0f, 0.0f, 0.0f)], [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(5.0f, 0.0f, 0.0f)]];
    shake.autoreverses = YES;
    shake.repeatCount = 2.0f;
    shake.duration = 0.07f;
    
    [self.layer addAnimation:shake forKey:nil];
}

- (void)pulseViewWithTime:(CGFloat)seconds {
    [UIView animateWithDuration:seconds/6 animations:^{
        [self setTransform:CGAffineTransformMakeScale(1.1, 1.1)];
    } completion:^(BOOL finished) {
        if(finished) {
            [UIView animateWithDuration:seconds/6 animations:^{
                [self setTransform:CGAffineTransformMakeScale(0.96, 0.96)];
            } completion:^(BOOL finished) {
                if(finished) {
                    [UIView animateWithDuration:seconds/6 animations:^{
                        [self setTransform:CGAffineTransformMakeScale(1.03, 1.03)];
                    } completion:^(BOOL finished) {
                        if(finished) {
                            [UIView animateWithDuration:seconds/6 animations:^{
                                [self setTransform:CGAffineTransformMakeScale(0.985, 0.985)];
                            } completion:^(BOOL finished) {
                                if(finished) {
                                    [UIView animateWithDuration:seconds/6 animations:^{
                                        [self setTransform:CGAffineTransformMakeScale(1.007, 1.007)];
                                    } completion:^(BOOL finished) {
                                        if(finished) {
                                            [UIView animateWithDuration:seconds/6 animations:^{
                                                [self setTransform:CGAffineTransformMakeScale(1, 1)];
                                            } completion:^(BOOL finished) {
                                                if(finished) {
                                                    
                                                }
                                            }];
                                        }
                                    }];
                                }
                            }];
                        }
                    }];
                }
            }];
        }
    }];
}

@end
