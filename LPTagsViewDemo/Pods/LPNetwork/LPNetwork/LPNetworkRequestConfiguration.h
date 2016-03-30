//
//  LPNetworkRequestConfiguration.h
//  LoopeerNetworkDemo
//
//  Created by dengjiebin on 5/20/15.
//  Copyright (c) 2015 Loopeer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import "LPNetworkResponse.h"

@interface LPNetworkRequestConfiguration : NSObject


@property (nonatomic, assign) NSInteger resultCacheDuration;

@property (nonatomic, copy) NSString *baseURL;

@property (nonatomic) AFHTTPRequestSerializer *requestSerializer;

@property (nonatomic) AFHTTPResponseSerializer *responseSerializer;

@property (nonatomic, copy) void (^responseHandler)(AFHTTPRequestOperation *operation, id userInfo, LPNetworkResponse *response, BOOL *shouldStopProcessing);

@property (nonatomic, copy) void (^requestHandler)(AFHTTPRequestOperation *operation, id userInfo, BOOL *shouldStopProcessing);

@property (nonatomic) id userInfo;

@property (nonatomic) NSDictionary *builtinParameters;

@property (nonatomic,strong) NSDictionary *builtinHeaders;

@property (nonatomic, assign) NSTimeInterval timeout;

@end
