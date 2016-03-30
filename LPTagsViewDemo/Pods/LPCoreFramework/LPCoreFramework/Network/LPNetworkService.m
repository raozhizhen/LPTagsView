//
//  LPNetworkService.m
//  LPCoreFrameworkDemo
//
//  Created by dengjiebin on 9/9/15.
//  Copyright (c) 2015 Loopeer. All rights reserved.
//

#import "LPNetworkService.h"
#import "LPUserManager.h"
#import <LPNetwork.h>
#import <LPAlertView.h>
#import <LPToast.h>
#import <UIApplication+LPKit.h>
#import <MBProgressHUD.h>
#import <NSString+LPKit.h>

NSString *const kLPNetworkRequestShowLoadingDisable = @"kLPNetworkRequestShowLoadingDisable";
NSString *const kLPNetworkRequestShowLoadingText = @"kLPNetworkRequestLoadingText";
NSString *const kLPNetworkRequestDisableUserAuth = @"kLPNetworkRequestDisableUserAuth";
NSString *const kLPNetworkRequestDisableStopProcessingWhenError = @"kLPNetworkRequestDisableStopProcessingWhenError";
NSString *const kLPNetworkRequestDisableNetworkErrorToast = @"kLPNetworkRequestDisableNetworkErrorToast";
NSString *const kLPNetworkRequestDisableStopProcessingWhenNotSuccess = @"kLPNetworkRequestDisableStopProcessingWhenNotSuccess";

NSInteger const kLPNetworkResponseSuccess = 0;
NSInteger const kLPNetworkResponseUserNotAuthorized = 401;
NSInteger const kLPNetworkResponseNotSupported = 505;

NSTimeInterval const kLPNetworkDefaultTimeout = 30;

NSString *const kLPNotificationUserNotAuthorizedHandler = @"kLPNotificationUserNotAuthorizedHandler";

static NSString *const kMBProgressHUDKeyDefault = @"kMBProgressHUDKeyDefault";

@implementation LPNetworkService {

    NSMutableDictionary *_mbProgressHUDs;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self defaultSettings];
    }
    return self;
}

- (void)defaultSettings {
    self.showNetworkActivity = YES;
    _mbProgressHUDs = [NSMutableDictionary new];
}

#pragma mark - init

+ (instancetype)sharedInstance {
    static LPNetworkService *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[[self class] alloc] init];
    });
    return sharedInstance;
}


#pragma mark -

- (void)setupService {
    LPNetworkRequestConfiguration *configuration = [LPNetworkRequest sharedInstance].configuration;

    [self customizeBuiltinHeaders:configuration];
    configuration.timeout = self.timeout>0?self.timeout:kLPNetworkDefaultTimeout;
    
    configuration.requestHandler = ^(AFHTTPRequestOperation *operation, id userInfo, BOOL *shouldStopProcessing) {
#ifdef DEBUG
        NSLog(@"Request: %@", operation.request.URL.absoluteString);
#endif
        
        BOOL disable = [userInfo[kLPNetworkRequestShowLoadingDisable] boolValue];
        if (!disable) {
            NSString *text = userInfo[kLPNetworkRequestShowLoadingText];
            NSNumber *key = [NSNumber numberWithUnsignedInteger:[operation hash]];
            [self showLoading:text withKey:[key stringValue]];
        }
        
        if (self.showNetworkActivity) {
            [UIApplication startNetworkActivity];
        }
    };
    configuration.responseHandler = ^(AFHTTPRequestOperation *operation, id userInfo, LPNetworkResponse *response, BOOL *shouldStopProcessing) {
#ifdef DEBUG
        NSLog(@"Response: %@", response.result);
#endif
        if (self.showNetworkActivity) {
            [UIApplication finishNetworkActivity];
        }
        
        BOOL disable = [userInfo[kLPNetworkRequestShowLoadingDisable] boolValue];
        if (!disable) {
            NSNumber *key = [NSNumber numberWithUnsignedInteger:[operation hash]];
            [self dismissLoadingWithKey:[key stringValue]];
        }

        BOOL disableToast = [userInfo[kLPNetworkRequestDisableNetworkErrorToast] boolValue];
        if (response.error) {
            if (!disableToast) {
                if (self.networkNotConnectedToastText) {
                    [LPToast showToast:self.networkNotConnectedToastText];
                } else {
                    [LPToast showToast:response.error.localizedDescription];
                }
            }
            BOOL disableStopProcessing = [userInfo[kLPNetworkRequestDisableStopProcessingWhenError] boolValue];
            if (!disableStopProcessing) {
                *shouldStopProcessing = YES;
            }
            return;
        }
        
        NSInteger code = [response.result[@"code"] integerValue];
        NSString *message = response.result[@"message"];

        BOOL disableUserAuth = [userInfo[kLPNetworkRequestDisableUserAuth] boolValue];
        BOOL disableStopProcessingWhenNotSuccess = [userInfo[kLPNetworkRequestDisableStopProcessingWhenNotSuccess] boolValue];
        
        if (code == kLPNetworkResponseNotSupported) {
            [LPAlertView alertWithTitle:nil withMessage:message cancelButtonTitle:nil otherButtonTitle:@"升级" withDissmissOutside:NO withCompletionBlock:^(DQAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == kLPAlertViewOtherButtonIndex && self.appId) {
                    NSString *appURL = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/cn/app/id%@?mt=8", self.appId];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appURL]];
                }
            }];

            if (!disableStopProcessingWhenNotSuccess || !userInfo[kLPNetworkRequestDisableStopProcessingWhenNotSuccess]) {
                *shouldStopProcessing = YES;
            }
        } else if (code == kLPNetworkResponseUserNotAuthorized) {
            if (disableUserAuth) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kLPNotificationUserNotAuthorizedHandler object:nil];                
                return;
            }
            
            [LPAlertView alertWithTitle:nil withMessage:@"您还未登录，请登录后再试" cancelButtonTitle:nil otherButtonTitle:@"确定" withCompletionBlock:^(DQAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == kLPAlertViewOtherButtonIndex) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kLPNotificationUserNotAuthorizedHandler object:nil];
                }
            }];
            
            if (!disableStopProcessingWhenNotSuccess || !userInfo[kLPNetworkRequestDisableStopProcessingWhenNotSuccess]) {
                *shouldStopProcessing = YES;
            }
        } else if (code != kLPNetworkResponseSuccess) {
            [LPToast showToast:message];
            
            if (!disableStopProcessingWhenNotSuccess || !userInfo[kLPNetworkRequestDisableStopProcessingWhenNotSuccess]) {
                *shouldStopProcessing = YES;
            }
        }
    };
    
    [LPNetworkRequest sharedInstance].configuration = configuration;
}

- (void)customizeBuiltinHeaders:(LPNetworkRequestConfiguration *)configuration {
    
    NSMutableDictionary *builtinHeaders = [NSMutableDictionary new];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    NSString *build = infoDictionary[(NSString*)kCFBundleVersionKey];
    [builtinHeaders setObject:build forKey:@"build"];
    
    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    [builtinHeaders setObject:version forKey:@"version"];
    
    [builtinHeaders setObject:@"ios" forKey:@"platform"];
    
    NSUUID *uuid = [[UIDevice currentDevice] identifierForVendor];
    [builtinHeaders setObject:[uuid UUIDString] forKey:@"device-id"];
    
    if ([[LPUserManager sharedUserManager] isLogin]) {
        [builtinHeaders setObject:[[[LPUserManager sharedUserManager] account].accountId stringValue] forKey:@"account-id"];
        [builtinHeaders setObject:[[LPUserManager sharedUserManager] account].token forKey:@"token"];
    }
    
    configuration.builtinHeaders = builtinHeaders;
}

- (void)setBaseURL:(NSString *)baseURL {
    _baseURL = baseURL;

    [LPNetworkRequest sharedInstance].configuration.baseURL = baseURL;
}

#pragma mark - Loading

- (void)showLoading:(NSString *)text {
    [self showLoading:text withKey:nil];
}

- (void)dismissLoading {
    [self dismissLoadingWithKey:nil];
}

- (void)showLoading:(NSString *)text withKey:(NSString *)key {
    UIViewController *topViewController = [self getTopVisibleViewController:[UIApplication sharedApplication].keyWindow.rootViewController];

    MBProgressHUD *mbProgressHUD = [[MBProgressHUD alloc] initWithView:topViewController.view];
    [topViewController.view addSubview:mbProgressHUD];
    
    mbProgressHUD.labelText = text;
    mbProgressHUD.removeFromSuperViewOnHide = YES;
    
    [mbProgressHUD show:YES];
    
    [_mbProgressHUDs setObject:mbProgressHUD forKey:[NSString isStringEmpty:key]?kMBProgressHUDKeyDefault:key];
}

- (void)dismissLoadingWithKey:(NSString *)key {
    MBProgressHUD *hud = [_mbProgressHUDs objectForKey:key];
    [hud hide:YES];

    [_mbProgressHUDs removeObjectForKey:[NSString isStringEmpty:key]?kMBProgressHUDKeyDefault:key];
}


- (UIViewController *)getTopVisibleViewController:(UIViewController *)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *)rootViewController;
        return [self getTopVisibleViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)rootViewController;
        return [self getTopVisibleViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController *presentedViewController = rootViewController.presentedViewController;
        return [self getTopVisibleViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}

#pragma mark - Add header

- (void)addValue:(id)object forHTTPHeaderField:(NSString *)key {
    NSMutableDictionary *builtinHeaders = [[LPNetworkRequest sharedInstance].configuration.builtinHeaders mutableCopy];
    if (builtinHeaders) {
        [builtinHeaders setObject:object forKey:key];
        [LPNetworkRequest sharedInstance].configuration.builtinHeaders = builtinHeaders;
    } else {
        [LPNetworkRequest sharedInstance].configuration.builtinHeaders = @{key: object};
    }
}

@end
