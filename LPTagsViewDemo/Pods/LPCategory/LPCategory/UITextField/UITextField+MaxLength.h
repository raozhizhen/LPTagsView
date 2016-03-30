//
//  UITextField+MaxLength.h
//  LPCategoryDemo
//
//  Created by dengjiebin on 9/17/15.
//  Copyright (c) 2015 Loopeer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (MaxLength)

@property (nonatomic, copy) NSNumber *maxLength;

- (BOOL)lp_textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

@end
