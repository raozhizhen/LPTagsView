//
//  UINavigationBar+BottomHairline.m
//  IdtingMerchant
//
//  Created by dengjiebin on 6/27/15.
//  Copyright (c) 2015 Loopeer. All rights reserved.
//

#import "UINavigationBar+BottomHairline.h"

@implementation UINavigationBar (BottomHairline)


- (void)hideBottomHairline {
    UIImageView *navBarHairlineImageView = [self findHairlineImageViewUnder:self];
    navBarHairlineImageView.hidden = YES;
    
}

- (void)showBottomHairline {
    UIImageView *navBarHairlineImageView = [self findHairlineImageViewUnder:self];
    navBarHairlineImageView.hidden = NO;
}


- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

@end
