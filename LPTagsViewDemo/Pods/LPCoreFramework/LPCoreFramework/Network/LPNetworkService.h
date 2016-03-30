//
//  LPNetworkService.h
//  LPCoreFrameworkDemo
//
//  Created by dengjiebin on 9/9/15.
//  Copyright (c) 2015 Loopeer. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kLPNetworkRequestShowLoadingDisable; // Request show loading disable key
extern NSString *const kLPNetworkRequestShowLoadingText; // Request show loading text key
extern NSString *const kLPNetworkRequestDisableUserAuth; // Disable the user auth
extern NSString *const kLPNetworkRequestDisableStopProcessingWhenError; // Disable the stop processing when network error
extern NSString *const kLPNetworkRequestDisableNetworkErrorToast; // Disable the toast when network error
extern NSString *const kLPNetworkRequestDisableStopProcessingWhenNotSuccess; // Disable the stop processing when request not success

extern NSInteger const kLPNetworkResponseSuccess; // Response successs code
extern NSInteger const kLPNetworkResponseUserNotAuthorized; // User Not Authorized code
extern NSInteger const kLPNetworkResponseNotSupported; // API NOT Supported code

extern NSString *const kLPNotificationUserNotAuthorizedHandler; // User Not Autorized handle notification


@interface LPNetworkService : NSObject

@property (nonatomic, copy) NSString *baseURL;  // Request base URL
@property (nonatomic, assign) BOOL showNetworkActivity; // If should show the network activity on status bar
@property (nonatomic, copy) NSString *appId; // App Store AppID
@property (nonatomic, copy) NSString *networkNotConnectedToastText; // The toast text that when the network is not connected
@property (nonatomic, assign) NSTimeInterval timeout; // The timeout interval that the request

+ (instancetype)sharedInstance;

// Setup
- (void)setupService;

// Loading
- (void)showLoading:(NSString *)text;
- (void)dismissLoading;

- (void)showLoading:(NSString *)text withKey:(NSString *)key;
- (void)dismissLoadingWithKey:(NSString *)key;


// Add build header
- (void)addValue:(id)object forHTTPHeaderField:(NSString *)key;

@end
