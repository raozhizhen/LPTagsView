//
//  LPCoreManager.m
//  LPCoreFrameworkDemo
//
//  Created by dengjiebin on 6/18/15.
//  Copyright (c) 2015 Loopeer. All rights reserved.
//

#import "LPCoreManager.h"

static NSString *const kUserDefaultKeyAppVersion = @"kUserDefaultKeyAppVersion";

@implementation LPCoreManager {

    NSString *_appVersion;
}

#pragma mark - Init

- (instancetype)init {
    self = [super init];
    if (self) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        _appVersion = [userDefaults objectForKey:kUserDefaultKeyAppVersion];
        
        
        NSBundle *mainBundle = [NSBundle mainBundle];
        NSDictionary *infoDictionary =  [mainBundle infoDictionary];
        NSString *version = infoDictionary[@"CFBundleShortVersionString"];
        if ([version isEqualToString:_appVersion]) {
            _isFirstLaunch = NO;
        } else {
            _isFirstLaunch = YES;
            
            [self saveCurrentAppVersion:version];
        }
    }
    return self;
}

#pragma mark - Shared Instance

+ (instancetype)sharedManager {
    static LPCoreManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[[self class] alloc] init];
    });
    return sharedManager;
}


- (void)saveCurrentAppVersion:(NSString *)appVersion {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:appVersion forKey:kUserDefaultKeyAppVersion];
    [userDefaults synchronize];
}

@end
