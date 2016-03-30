//
//  LPAlertView.m
//  LoopeerAlertView
//
//  Created by Dengjiebin on 14-12-30.
//  Copyright (c) 2014年 Loopeer. All rights reserved.
//

#import "LPAlertView.h"
#import "UIColor+LPKit.h"
#import "UIView+LPkit.h"
#import "Masonry.h"


NSInteger const kLPAlertViewTag = 10999;

NSInteger const kLPAlertViewCancelButtonIndex = 1;
NSInteger const kLPAlertViewOtherButtonIndex = 2;

static CGFloat const kLPAertViewTextFieldHeight = 44;

@implementation LPAlertView

#pragma mark - Init

- (instancetype)init {
    self = [super init];
    if (self) {
        // Default settings
        self.disappearTime = .1;
        self.appearTime = .2;
        self.disappearAnimationType = DQAlertViewAnimationTypeDefault;
        self.appearAnimationType = DQAlertViewAnimationTypeDefault;

        // Default
        self.textColor = [UIColor colorWithHexString:@"#5D5D5D"];
        self.textFont = [UIFont systemFontOfSize:17];
        self.seperatorColorKey = [UIColor colorWithHexString:@"#E4E4E4"];
        
        self.cancelButtonTitleColor = [UIColor colorWithHexString:@"#3AD0D6"];
        self.cancelButtonTitleFont = [UIFont systemFontOfSize:16];
        self.otherButtonTitleColor = [UIColor colorWithHexString:@"#3AD0D6"];
        self.otherButtonTitleFont = [UIFont systemFontOfSize:16];
        
        self.titleColor = [UIColor colorWithHexString:@"#878787"];
        self.titleFont = [UIFont systemFontOfSize:15];

        self.messageColor = [UIColor colorWithHexString:@"#878787"];
        self.messageFont = [UIFont systemFontOfSize:16];
        self.messageTextAlignment = NSTextAlignmentLeft;

        self.textFieldBackgroundColor = [UIColor colorWithHexString:@"#F1F1F1"];
        self.textFieldTextColor = [UIColor colorWithHexString:@"#444444"];
        self.textFieldTextFont = [UIFont systemFontOfSize:17];
        self.textFieldTextAlignment = NSTextAlignmentCenter;
                
        // apply the appearance
        [[[self class] appearance] applyInvocationTo:self];
    }
    return self;
}

#pragma mark - appearance

+ (id)appearance {
    return [MZAppearance appearanceForClass:[self class]];
}

#pragma mark - Message

+ (void)alertWithTitle:(NSString *)title
           withMessage:(NSString *)message
     cancelButtonTitle:(NSString *)cancelButtonTitle
      otherButtonTitle:(NSString *)otherButtonTitle
   withCompletionBlock:(LPAlertViewCompletionBlock)completionBlock {
    [self alertWithTitle:title withMessage:message cancelButtonTitle:cancelButtonTitle otherButtonTitle:otherButtonTitle withDissmissOutside:YES withCompletionBlock:completionBlock];
}


+ (void)alertWithTitle:(NSString *)title
           withMessage:(NSString *)message
     cancelButtonTitle:(NSString *)cancelButtonTitle
      otherButtonTitle:(NSString *)otherButtonTitle
   withDissmissOutside:(BOOL)shouldDismissOutside
   withCompletionBlock:(LPAlertViewCompletionBlock)completionBlock {
    if ([LPAlertView existAlertView])
        return;
    
    LPAlertView *mAlertView = [[LPAlertView alloc] init];
    
    DQAlertView *alertView = [[DQAlertView alloc] initWithTitle:title message:message cancelButtonTitle:cancelButtonTitle otherButtonTitle:otherButtonTitle];
    alertView.backgroundColor = [UIColor whiteColor];
    alertView.messageLabel.textColor = mAlertView.textColor;
    alertView.messageLabel.font = mAlertView.textFont;
    alertView.seperatorColor = mAlertView.seperatorColorKey;
    [alertView.cancelButton setTitleColor:mAlertView.cancelButtonTitleColor forState:UIControlStateNormal];
    [alertView.otherButton setTitleColor:mAlertView.otherButtonTitleColor forState:UIControlStateNormal];
    alertView.disappearAnimationType = mAlertView.disappearAnimationType;
    alertView.appearAnimationType = mAlertView.appearAnimationType;
    alertView.disappearTime = mAlertView.disappearTime;
    alertView.appearTime = mAlertView.appearTime;
    alertView.cancelButton.titleLabel.font = mAlertView.cancelButtonTitleFont;
    alertView.otherButton.titleLabel.font = mAlertView.otherButtonTitleFont;
    
    [alertView actionWithBlocksCancelButtonHandler:^{
        completionBlock(alertView, kLPAlertViewCancelButtonIndex);
    } otherButtonHandler:^{
        [alertView dismiss];
        completionBlock(alertView, kLPAlertViewOtherButtonIndex);
    }];
    
    alertView.shouldDismissOnOutsideTapped = shouldDismissOutside;
    alertView.tag = kLPAlertViewTag;
    [alertView show];
}

#pragma mark - Input Text

+ (void)alertWithPlaceholder:(NSString *)placeholder
                   withTitle:(NSString *)title
                 withMessage:(NSString *)message
           cancelButtonTitle:(NSString *)cancelButtonTitle
            otherButtonTitle:(NSString *)otherButtonTitle
         withCompletionBlock:(LPAlertViewTextFieldCompletionBlock)completionBlock {
    if ([LPAlertView existAlertView])
        return;
    
    LPAlertView *mAlertView = [[LPAlertView alloc] init];
    
    static NSInteger leftpadding = 30;
    DQAlertView *alertView = [[DQAlertView alloc] initWithTitle:title message:nil cancelButtonTitle:cancelButtonTitle otherButtonTitle:otherButtonTitle];
    
    UIView *window = [[[UIApplication sharedApplication] delegate] window];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, window.width - leftpadding * 2, [mAlertView contentHeightWithTitle:title withMessage:message withWidth:(window.width - leftpadding*2 - 2*8)])];
    alertView.contentView = contentView;
    
    UILabel *titleLabel = [mAlertView customTitleLabelWithTitle:title];
    [contentView addSubview:titleLabel];
    
    UILabel *messageLabel = [mAlertView customMessageLabelWithMessage:message];
    [contentView addSubview:messageLabel];
    
    UITextField *textField = [[UITextField alloc] init];
    textField.backgroundColor = mAlertView.textFieldBackgroundColor;
    textField.textColor = mAlertView.textFieldTextColor;
    textField.font = mAlertView.textFieldTextFont;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.textAlignment = mAlertView.textFieldTextAlignment;
    
    [contentView addSubview:textField];
    
    if (placeholder) {
        textField.placeholder = placeholder;
    }
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(alertView.mas_centerX);
        make.top.equalTo(alertView).offset(8);
    }];
    
    if (message) {
        [messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLabel.mas_bottom).offset(8);
            make.left.equalTo(alertView).offset(8);
            make.right.equalTo(alertView).offset(-8);
        }];
    }
    
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        if (message) {
            make.top.equalTo(messageLabel.mas_bottom).offset(8);
        } else {
            make.top.equalTo(titleLabel.mas_bottom).offset(8);
        }
        make.left.equalTo(alertView.mas_left);
        make.width.equalTo(alertView.mas_width);
        make.height.equalTo(@(kLPAertViewTextFieldHeight));
    }];
    
    alertView.disappearAnimationType = mAlertView.disappearAnimationType;
    alertView.appearAnimationType = mAlertView.appearAnimationType;
    alertView.disappearTime = mAlertView.disappearTime;
    alertView.appearTime = mAlertView.appearTime;
    alertView.seperatorColor = mAlertView.seperatorColorKey;
    [alertView.cancelButton setTitleColor:mAlertView.cancelButtonTitleColor forState:UIControlStateNormal];
    [alertView.otherButton setTitleColor:mAlertView.otherButtonTitleColor forState:UIControlStateNormal];
    alertView.cancelButton.titleLabel.font = mAlertView.cancelButtonTitleFont;
    alertView.otherButton.titleLabel.font = mAlertView.otherButtonTitleFont;
    
    [alertView actionWithBlocksCancelButtonHandler:^{
        completionBlock(alertView, textField, kLPAlertViewCancelButtonIndex);
    } otherButtonHandler:^{
        [alertView dismiss];
        completionBlock(alertView, textField, kLPAlertViewOtherButtonIndex);
    }];
    
    alertView.shouldDismissOnOutsideTapped = YES;
    alertView.tag = kLPAlertViewTag;
    [alertView show];
}


#pragma mark - Rate & Input Text

+ (void)alertWithRate:(float)rate
      WithPlaceholder:(NSString *)placeholder
    cancelButtonTitle:(NSString *)cancelButtonTitle
     otherButtonTitle:(NSString *)otherButtonTitle
  withCompletionBlock:(LPAlertViewRateTextFieldCompletionBlock)completionBlock {
    if ([LPAlertView existAlertView])
        return;
    
    LPAlertView *mAlertView = [[LPAlertView alloc] init];
    
    static NSInteger leftpadding = 30;
    
    DQAlertView *alertView = [[DQAlertView alloc] initWithTitle:@"" message:nil cancelButtonTitle:cancelButtonTitle otherButtonTitle:otherButtonTitle];
    UIView *window = [[[UIApplication sharedApplication] delegate] window];
    alertView.customFrame = CGRectMake(leftpadding, (window.height - 200)/2 - leftpadding, (window.width - leftpadding * 2), 126);
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, (window.width - leftpadding * 2), 82)];
    alertView.contentView = contentView;
    
    EDStarRating *starRating = [[EDStarRating alloc] init];
    starRating.backgroundColor = [UIColor clearColor];
    starRating.starImage = [UIImage imageNamed:@"LoopeerAlertView.bundle/images/star.png"];
    starRating.starHighlightedImage = [UIImage imageNamed:@"LoopeerAlertView.bundle/images/star_selected.png"];
    starRating.frame = CGRectMake(contentView.width/4, 0, contentView.width/2, 40);
    starRating.horizontalMargin = 12;
    starRating.displayMode = EDStarRatingDisplayFull;
    starRating.editable = YES;
    starRating.maxRating = 5.0;
    starRating.rating = rate;
    [contentView addSubview:starRating];
    
    UITextField *textField = [[UITextField alloc] init];
    textField.backgroundColor = mAlertView.textFieldBackgroundColor;
    textField.textColor = mAlertView.textFieldTextColor;
    textField.font = mAlertView.textFieldTextFont;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.textAlignment = NSTextAlignmentCenter;
    [textField becomeFirstResponder];
    [contentView addSubview:textField];
    if (placeholder) {
        textField.placeholder = placeholder;
    }
    
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(alertView.mas_left);
        make.width.equalTo(alertView.mas_width);
        make.top.equalTo(starRating.mas_bottom).offset(-2);
        make.height.equalTo(@44);
    }];

    alertView.disappearAnimationType = mAlertView.disappearAnimationType;
    alertView.appearAnimationType = mAlertView.appearAnimationType;
    alertView.disappearTime = mAlertView.disappearTime;
    alertView.appearTime = mAlertView.appearTime;
    alertView.seperatorColor = mAlertView.seperatorColorKey;
    [alertView.cancelButton setTitleColor:mAlertView.cancelButtonTitleColor forState:UIControlStateNormal];
    [alertView.otherButton setTitleColor:mAlertView.otherButtonTitleColor forState:UIControlStateNormal];
    alertView.cancelButton.titleLabel.font = mAlertView.cancelButtonTitleFont;
    alertView.otherButton.titleLabel.font = mAlertView.otherButtonTitleFont;
    
    [alertView actionWithBlocksCancelButtonHandler:^{
        completionBlock(alertView, starRating, textField, kLPAlertViewCancelButtonIndex);
    } otherButtonHandler:^{
        [alertView dismiss];
        completionBlock(alertView, starRating, textField, kLPAlertViewOtherButtonIndex);
    }];
    
    alertView.shouldDismissOnOutsideTapped = YES;
    alertView.tag = kLPAlertViewTag;
    [alertView show];
}

+ (BOOL)existAlertView {
    UIView *window = [[[UIApplication sharedApplication] delegate] window];
    UIView *blackOpaqueView = [window viewWithTag:kLPAlertViewTag];
    if (blackOpaqueView) {
        return YES;
    }
    return NO;
}

#pragma mark - Private

- (UILabel *)customTitleLabelWithTitle:(NSString *)title {
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 1;
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    label.textColor = self.titleColor;
    label.font = self.titleFont;
    label.text = title;
    return label;
}

- (UILabel *)customMessageLabelWithMessage:(NSString *)message {
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    label.textAlignment = self.messageTextAlignment;
    label.textColor = self.messageColor;
    label.font = self.messageFont;
    label.text = message;
    return label;
}

- (CGFloat)contentHeightWithTitle:(NSString *)title withMessage:(NSString *)message withWidth:(CGFloat)width {
    CGFloat height = kLPAertViewTextFieldHeight;
    height += 8*2 + [[self customTitleLabelWithTitle:title] sizeThatFits:CGSizeZero].height;
    if (message) {
        height += 8 + [[self customMessageLabelWithMessage:message] sizeThatFits:CGSizeMake(width, 0)].height;
    }
    return height;
}

@end
