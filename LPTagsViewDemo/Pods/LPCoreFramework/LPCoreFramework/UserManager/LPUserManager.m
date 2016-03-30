//
//  LPUserManager.m
//  LPCoreFrameworkDemo
//
//  Created by Han Shuai on 16/1/18.
//  Copyright © 2016年 Loopeer. All rights reserved.
//

#import "LPUserManager.h"
#import <LPNetwork.h>
#import "LPNetworkService.h"
#import "NSString+LPKit.h"

static NSString *const kLPAccountKey = @"kLPAccountKey";
static NSString *const kLPLastAccountKey = @"kLPLastAccountKey";

static NSString *const kIdKeyInHeader = @"account-id";
static NSString *const kTokenKeyInHeader = @"token";

NSString *const kLPUserLoginNotification = @"kLPUserLoginNotification";
NSString *const kLPUserUpdateRefreshNotification = @"kLPUserUpdateRefreshNotification";
NSString *const kLPUserLogoutNotification = @"kLPUserLogoutNotification";
NSString *const kLPUserStateChangeNotification = @"kLPUserStateChangeNotification";

static LPAccountModel *account;

@implementation LPUserManager

- (instancetype)init {
    self = [super init];
    if (self) {
        if (!account) {
            account = [[LPAccountModel alloc] init];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout) name:kLPNotificationUserNotAuthorizedHandler object:nil];
            [self loadFromUserDefaults];
        }
    }
    return self;
}

+ (instancetype)sharedUserManager {
    static dispatch_once_t onceToken;
    static id sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[LPUserManager alloc] init];
    });
    return sharedInstance;
}


#pragma mark - public Methods

- (BOOL)isLogin {
    if (!account) {
        return NO;
    }
    
    if ([account.accountId integerValue] == 0 || [NSString isStringEmpty:account.token]) {
        return NO;
    }
    
    return YES;
}

- (void)login:(LPAccountModel *)accountInfo {
    [self saveAccount:accountInfo];
    [[LPNetworkService sharedInstance] addValue:account.token forHTTPHeaderField:kTokenKeyInHeader];
    [[LPNetworkService sharedInstance] addValue:[account.accountId stringValue] forHTTPHeaderField:kIdKeyInHeader];
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:kLPUserLoginNotification object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kLPUserStateChangeNotification object:nil];
}

- (void)logout {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:kLPAccountKey];
    if (account) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:account];
        [userDefaults setObject:data forKey:kLPLastAccountKey];
    }
    [userDefaults synchronize];
    
    [self loadFromUserDefaults];
    
    NSMutableDictionary *headers = [[LPNetworkRequest sharedInstance].configuration.builtinHeaders mutableCopy];
    [headers removeObjectForKey:kTokenKeyInHeader];
    [headers removeObjectForKey:kIdKeyInHeader];
    [LPNetworkRequest sharedInstance].configuration.builtinHeaders = [headers copy];
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:kLPUserLogoutNotification object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kLPUserStateChangeNotification object:nil];
}

- (void)updateAccount:(LPAccountModel *)accountInfo {
    [self saveAccount:accountInfo];
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:kLPUserUpdateRefreshNotification object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kLPUserStateChangeNotification object:nil];
}

- (LPAccountModel *)account {
    return account;
}

- (LPAccountModel *)lastAccount {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [userDefaults objectForKey:kLPLastAccountKey];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

#pragma mark - userDefaults

- (void)loadFromUserDefaults {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [userDefaults objectForKey:kLPAccountKey];
    account = [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

- (void)saveAccount:(LPAccountModel *)account {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:account];
    [userDefaults setObject:data forKey:kLPAccountKey];
    [userDefaults synchronize];
    
    [self loadFromUserDefaults];
}

@end
