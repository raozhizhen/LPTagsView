//
//  UIImage+LPKit.h
//  LoopeerLibrary
//
//  Created by dengjiebin on 12/31/14.
//  Copyright (c) 2014 Loopeer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (LPKit)


/**
 * Apply the alpha to the current image, return the new image
 *
 */
- (UIImage *)imageByApplyingAlpha:(CGFloat)alpha;


@end
