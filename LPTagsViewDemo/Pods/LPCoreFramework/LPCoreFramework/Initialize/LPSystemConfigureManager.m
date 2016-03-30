//
//  LPSystemConfigureManager.m
//  LPCoreFramework
//
//  Created by dengjiebin on 7/3/15.
//  Copyright (c) 2015 Loopeer. All rights reserved.
//

#import "LPSystemConfigureManager.h"

static NSString *const kSystemConfigureKey = @"lp_system_configure";

@implementation LPSystemConfigureManager

static LPSystemConfigure *_systemConfigure;

- (instancetype)init {
    self = [super init];
    if (self) {
        if (!_systemConfigure) {
            _systemConfigure = [[LPSystemConfigure alloc] init];
            
            [self loadFromUserDefaults];
        }
    }
    return self;
}

- (void)loadFromUserDefaults {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [userDefaults objectForKey:kSystemConfigureKey];
    if (data) {
        _systemConfigure = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
}

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static id sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[[self class] alloc] init];
    });
    return sharedInstance;
}

- (void)update:(LPSystemConfigure *)configure {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:configure];
    [userDefaults setObject:data forKey:kSystemConfigureKey];
    [userDefaults synchronize];
    
    [self loadFromUserDefaults];
}

- (LPSystemConfigure *)configure {
    return _systemConfigure;
}

- (void)clear {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:kSystemConfigureKey];
    [userDefaults synchronize];
    
    [self loadFromUserDefaults];
}

@end
