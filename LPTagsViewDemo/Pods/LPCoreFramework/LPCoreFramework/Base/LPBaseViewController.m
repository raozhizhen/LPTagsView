//
//  LPBaseViewController.m
//  LPTableViewDemo
//
//  Created by dengjiebin on 6/10/15.
//  Copyright (c) 2015 Loopeer. All rights reserved.
//

#import "LPBaseViewController.h"
#import "UINavigationBar+BottomHairline.h"
#import "LPNetworkService.h"

@interface LPBaseViewController ()

@end

@implementation LPBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self suitIOS7];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)suitIOS7 {
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUserNotAuthorizedHandler) name:kLPNotificationUserNotAuthorizedHandler object:nil];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kLPNotificationUserNotAuthorizedHandler object:nil];
}


#pragma mark - User Not Authorized Handler


// The Subclass BaseViewController should implement it
- (void)didUserNotAuthorizedHandler {}



@end
