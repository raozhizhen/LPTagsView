//
//  LPSystemInitialize.m
//  LPCoreFrameworkDemo
//
//  Created by dengjiebin on 10/19/15.
//  Copyright (c) 2015 Loopeer. All rights reserved.
//

#import "LPSystemInitialize.h"
#import <LPNetworkRequest.h>
#import "LPNetworkService.h"
#import "LPSystemConfigure.h"
#import "LPSystemConfigureManager.h"

@implementation LPSystemInitialize

+ (void)setupWithRequestURL:(NSString *)requestURL modelOfClass:(Class)modelClass completeHandler:(void (^)())completeHandler {
    [[LPNetworkRequest sharedInstance] GET:requestURL parameters:nil startImmediately:YES configurationHandler:^(LPNetworkRequestConfiguration *configuration) {
        configuration.userInfo = @{kLPNetworkRequestShowLoadingDisable:@YES, kLPNetworkRequestDisableNetworkErrorToast:@YES};
    } completionHandler:^(NSError *error, id result, BOOL isFromCache, AFHTTPRequestOperation *operation) {
        LPSystemConfigure *configure = [MTLJSONAdapter modelOfClass:modelClass fromJSONDictionary:result[@"data"] error:nil];
        if (configure) {
            [[LPSystemConfigureManager sharedInstance] update:configure];
        }
        if (completeHandler) {
            completeHandler();
        }
    }];
}

@end
