//
//  LPUserManager.h
//  LPCoreFrameworkDemo
//
//  Created by Han Shuai on 16/1/18.
//  Copyright © 2016年 Loopeer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LPAccountModel.h"

extern NSString *const kLPUserLoginNotification;
extern NSString *const kLPUserUpdateRefreshNotification;
extern NSString *const kLPUserLogoutNotification;
extern NSString *const kLPUserStateChangeNotification;

@interface LPUserManager : NSObject

+ (instancetype)sharedUserManager;

- (BOOL)isLogin;
- (void)login:(LPAccountModel *)account;
- (void)logout;

- (void)updateAccount:(LPAccountModel *)account;

- (LPAccountModel *)account;
- (LPAccountModel *)lastAccount;

@end
