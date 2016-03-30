//
//  LPNetworkRequest.h
//  LoopeerNetworkDemo
//
//  Created by dengjiebin on 5/20/15.
//  Copyright (c) 2015 Loopeer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import "LPNetworkRequestConfiguration.h"

typedef NS_ENUM(NSUInteger, LPNetworkRequestMethod) {
    LPNetworkRequestMethodGet = 0,
    LPNetworkRequestMethodPost,
    LPNetworkRequestMethodDelete,
    LPNetworkRequestMethodPut
};


typedef void (^LPNetworkRequestConfigurationHandler)(LPNetworkRequestConfiguration *configuration);

typedef void (^LPNetworkRequestCompletionHandler)(NSError *error, id result, BOOL isFromCache, AFHTTPRequestOperation *operation);

typedef void (^LPNetworkRequestParametersHandler)(NSMutableDictionary *requestParameters, NSMutableDictionary *builtinParameters);


@interface LPNetworkRequest : NSObject


@property (nonatomic) AFNetworkReachabilityStatus networkReachabilityStatus;

@property (nonatomic) LPNetworkRequestConfiguration *configuration;

@property (nonatomic, readonly) NSArray *runningRequests;

@property (nonatomic, copy) LPNetworkRequestParametersHandler parametersHandler;


+ (instancetype)sharedInstance;

#pragma mark - Chains

/**
 * Add operation to the chain
 */
- (void)addOperation:(AFHTTPRequestOperation *)operation toChain:(NSString *)chain;

/**
 * Get the all operations of the chain
 */
- (NSArray *)operationsInChain:(NSString *)chain;

/**
 * Remove the specified operation of the chain
 */
- (void)removeOperation:(AFHTTPRequestOperation *)operation inChain:(NSString *)chain;

/**
 * Remove the all operations of the chain
 */
- (void)removeOperationsInChain:(NSString *)chain;


#pragma mark - Batch

/**
 * Batch execute some operation
 */
- (void)batchOfRequestOperations:(NSArray *)operations
                   progressBlock:(void (^)(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations))progressBlock
                 completionBlock:(void (^)())completionBlock;

#pragma mark - Cancel

/**
 * Cancel all requests
 */
- (void)cancelAllRequest;

/**
 * Cancel the some http operations with the URL & Method
 */
- (void)cancelHTTPOperationsWithMethod:(LPNetworkRequestMethod)method url:(NSString *)url;

/**
 * Re-Assemble
 */
- (AFHTTPRequestOperation *)reAssembleOperation:(AFHTTPRequestOperation *)operation;


#pragma mark - Get/Post

/**
 * Get Request
 */
- (AFHTTPRequestOperation *)GET:(NSString *)URLString
                     parameters:(NSDictionary *)parameters
               startImmediately:(BOOL)startImmediately
           configurationHandler:(LPNetworkRequestConfigurationHandler)configurationHandler
              completionHandler:(LPNetworkRequestCompletionHandler)completionHandler;


/**
 * Post Request
 */
- (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(NSDictionary *)parameters
                startImmediately:(BOOL)startImmediately
            configurationHandler:(LPNetworkRequestConfigurationHandler)configurationHandler
               completionHandler:(LPNetworkRequestCompletionHandler)completionHandler;

/**
 * Upload
 */
- (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(NSDictionary *)parameters
                startImmediately:(BOOL)startImmediately
       constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))block
            configurationHandler:(LPNetworkRequestConfigurationHandler)configurationHandler
               completionHandler:(LPNetworkRequestCompletionHandler)completionHandler;

@end
