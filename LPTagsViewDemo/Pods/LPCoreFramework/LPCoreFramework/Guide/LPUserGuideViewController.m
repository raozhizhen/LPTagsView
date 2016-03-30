//
//  LPUserGuideViewController.m
//  LPCoreFrameworkDemo
//
//  Created by dengjiebin on 6/30/15.
//  Copyright (c) 2015 Loopeer. All rights reserved.
//

#import "LPUserGuideViewController.h"
#import "EAIntroView.h"

static CGFloat const kTitlePositionY = 230;
static CGFloat const kTitleIconPositionY = 115;
static CGFloat const kTitleFontSize = 18;
static CGFloat const kPageControlY = 20;

@interface LPUserGuideViewController() <EAIntroDelegate>

@end

@implementation LPUserGuideViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setupDefaults];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self showGuideView];
}


- (void)setupDefaults {
    _titlePositionY = kTitlePositionY;
    _titleIconPositionY = kTitleIconPositionY;
    _titleFontSize = kTitleFontSize;
    _pageControlY = kPageControlY;
}

- (void)showGuideView {
    NSMutableArray *pageViews = [NSMutableArray new];
    [self.pages enumerateObjectsUsingBlock:^(UIImage *image, NSUInteger idx, BOOL *stop) {
        EAIntroPage *page = [EAIntroPage page];
        page.bgImage = image;
        if (self.titles) {
            page.title = self.titles[idx];
            page.titleFont = [UIFont systemFontOfSize:self.titleFontSize];
            page.titlePositionY = self.titlePositionY;
        }

        if (self.titleIcons) {
            page.titleIconView = [[UIImageView alloc] initWithImage:self.titleIcons[idx]];
            page.titleIconPositionY = kTitleIconPositionY;
        }
        
        [pageViews addObject:page];
    }];
    
    EAIntroView *introView = [[EAIntroView alloc] initWithFrame:[UIScreen mainScreen].bounds andPages:pageViews];
    introView.tapToNext = YES;
    introView.skipButton = nil;
    introView.pageControlY = self.pageControlY;
    [introView showInView:self.navigationController.view animateDuration:0.3];
}

- (void)introDidFinish:(EAIntroView *)introView {
    if (self.finishBlock) {
        self.finishBlock();
    }
}

@end
