//
//  LPUserGuideViewController.h
//  LPCoreFrameworkDemo
//
//  Created by dengjiebin on 6/30/15.
//  Copyright (c) 2015 Loopeer. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LPUserGuideFinishBlock)(void);

@interface LPUserGuideViewController : UIViewController

@property (nonatomic, assign) CGFloat titlePositionY;
@property (nonatomic, assign) CGFloat titleIconPositionY;
@property (nonatomic, assign) CGFloat titleFontSize;
@property (nonatomic, assign) CGFloat pageControlY;


@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *titleIcons;

@property (nonatomic, strong) NSArray *pages;

@property (nonatomic, copy) LPUserGuideFinishBlock finishBlock;

@end
