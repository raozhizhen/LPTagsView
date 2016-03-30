//
//  LPNetworkRequestConfiguration.m
//  LoopeerNetworkDemo
//
//  Created by dengjiebin on 5/20/15.
//  Copyright (c) 2015 Loopeer. All rights reserved.
//

#import "LPNetworkRequestConfiguration.h"

@implementation LPNetworkRequestConfiguration

- (AFHTTPRequestSerializer *)requestSerializer {
    if (_requestSerializer) {
        if (self.timeout > 0) {
            _requestSerializer.timeoutInterval = self.timeout;
        }
        return _requestSerializer;
    }
    
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    if (self.timeout > 0) {
        serializer.timeoutInterval = self.timeout;
    }
    return serializer;
}

- (AFHTTPResponseSerializer *)responseSerializer {
    return _responseSerializer ? : [AFJSONResponseSerializer serializer];
}

- (instancetype)copyWithZone:(NSZone *)zone {
    LPNetworkRequestConfiguration *configuration = [[LPNetworkRequestConfiguration alloc] init];
    configuration.baseURL = [self.baseURL copy];
    configuration.resultCacheDuration = self.resultCacheDuration;
    configuration.builtinParameters = [self.builtinParameters copy];
    configuration.userInfo = [self.userInfo copy];
    configuration.builtinHeaders = [self.builtinHeaders copy];
    configuration.timeout = self.timeout;    
    return configuration;
}


@end
