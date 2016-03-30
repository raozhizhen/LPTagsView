//
//  LPNetworkRequest.m
//  LoopeerNetworkDemo
//
//  Created by dengjiebin on 5/20/15.
//  Copyright (c) 2015 Loopeer. All rights reserved.
//

#import "LPNetworkRequest.h"
#import "LPNetworkResponseCache.h"

static NSString *const kLPNetworkRequestMethodGet = @"GET";
static NSString *const kLPNetworkRequestMethodPost = @"POST";
static NSString *const kLPNetworkRequestMethodDelete = @"DELETE";
static NSString *const kLPNetworkRequestMethodPut = @"PUT";

NSString *NSStringFromLPNetworkRequestMethod(LPNetworkRequestMethod method) {
    switch (method) {
        case LPNetworkRequestMethodGet:
            return kLPNetworkRequestMethodGet;
            break;
        case LPNetworkRequestMethodPost:
            return kLPNetworkRequestMethodPost;
            break;
        case LPNetworkRequestMethodDelete:
            return kLPNetworkRequestMethodDelete;
            break;
        case LPNetworkRequestMethodPut:
            return kLPNetworkRequestMethodPut;
            break;
        default:
            return kLPNetworkRequestMethodGet;
            break;
    }
    return nil;
};

LPNetworkRequestMethod LPNetworkRequestMethodFromNSString(NSString *method) {
    if ([method isEqualToString:kLPNetworkRequestMethodPut]) {
        return LPNetworkRequestMethodPut;
    } else if ([method isEqualToString:kLPNetworkRequestMethodPost]) {
        return LPNetworkRequestMethodPost;
    } else if ([method isEqualToString:kLPNetworkRequestMethodDelete]) {
        return LPNetworkRequestMethodDelete;
    } else {
        return LPNetworkRequestMethodGet;
    }
};


@implementation LPNetworkRequest {
    AFHTTPRequestOperationManager *_requestManager;
    NSMutableDictionary *_chainedOperations;
    NSMapTable *_completionBlocks;
    NSMapTable *_operationMethodParameters;
    LPNetworkResponseCache *_cache;
    NSMutableArray *_batchGroups;
}

@synthesize configuration = _configuration;

+ (instancetype)sharedInstance {
    static LPNetworkRequest *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.networkReachabilityStatus = AFNetworkReachabilityStatusUnknown;
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
        
        _requestManager = [AFHTTPRequestOperationManager manager];
        _cache = [[LPNetworkResponseCache alloc] init];
        _chainedOperations = [[NSMutableDictionary alloc] init];
        _completionBlocks = [NSMapTable mapTableWithKeyOptions:NSMapTableWeakMemory valueOptions:NSMapTableCopyIn];
        _operationMethodParameters = [NSMapTable mapTableWithKeyOptions:NSMapTableWeakMemory valueOptions:NSMapTableStrongMemory];
        _batchGroups = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)reachabilityChanged:(NSNotification *)notification {
    self.networkReachabilityStatus = [notification.userInfo[AFNetworkingReachabilityNotificationStatusItem] integerValue];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (LPNetworkRequestConfiguration *)configuration {
    if (!_configuration) {
        _configuration = [[LPNetworkRequestConfiguration alloc] init];
    }
    return _configuration;
}

- (void)setConfiguration:(LPNetworkRequestConfiguration *)configuration {
    if (_configuration != configuration) {
        _configuration = configuration;
        if (_configuration.resultCacheDuration > 0) {
            double pastTimeInterval = [[NSDate date] timeIntervalSince1970] - _configuration.resultCacheDuration;
            NSDate *pastDate = [NSDate dateWithTimeIntervalSince1970:pastTimeInterval];
            [_cache trimToDate:pastDate];
        }
    }
}


#pragma mark - Private

- (AFHTTPRequestOperation *)createOperationWithConfiguration:(LPNetworkRequestConfiguration *)configuration request:(NSURLRequest *)request {
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = _requestManager.responseSerializer;
    operation.shouldUseCredentialStorage = _requestManager.shouldUseCredentialStorage;
    operation.credential = _requestManager.credential;
    operation.securityPolicy = _requestManager.securityPolicy;
    operation.completionQueue = _requestManager.completionQueue;
    operation.completionGroup = _requestManager.completionGroup;
    return operation;
}


- (NSString *)serializeParams:(NSDictionary *)params {
    NSMutableArray *parts = [NSMutableArray array];
    [params enumerateKeysAndObjectsUsingBlock:^(id key, id<NSObject> obj, BOOL *stop) {
        NSString *encodedKey = [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *encodedValue = [obj.description stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *part = [NSString stringWithFormat:@"%@=%@", encodedKey, encodedValue];
        [parts addObject:part];
    }];
    NSString *queryString = [parts componentsJoinedByString:@"&"];
    return queryString ? [NSString stringWithFormat:@"?%@", queryString] : @"";
}

- (AFHTTPRequestOperation *)findNextOperationInChainedOperationsBy:(AFHTTPRequestOperation *)operation {
    __block AFHTTPRequestOperation *theOperation;
    
    [_chainedOperations enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSMutableArray *chainedOperations, BOOL *stop) {
        [chainedOperations enumerateObjectsUsingBlock:^(AFHTTPRequestOperation *requestOperation, NSUInteger idx, BOOL *stop) {
            if ([requestOperation.request.URL isEqual:operation.request.URL]) {
                if (idx < chainedOperations.count - 1) {
                    theOperation = chainedOperations[idx + 1];
                    *stop = YES;
                }
                [chainedOperations removeObject:requestOperation];
//                [chainedOperations removeObject:theOperation];
            }
        }];
        if (chainedOperations) {
            *stop = YES;
        }
        if (!chainedOperations.count) {
            [_chainedOperations removeObjectForKey:key];
        }
    }];
    
    return theOperation;
}


- (AFHTTPRequestOperation *)requestOperationWithMethod:(LPNetworkRequestMethod)method
                                             URLString:(NSString *)URLString
                                            parameters:(NSDictionary *)parameters
                                      startImmediately:(BOOL)startImmediately
                             constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))block
                                  configurationHandler:(LPNetworkRequestConfigurationHandler)configurationHandler
                                     completionHandler:(LPNetworkRequestCompletionHandler)completionHandler {
    LPNetworkRequestConfiguration *configuration = [self.configuration copy];
    if (configurationHandler) {
        configurationHandler(configuration);
    }
    _requestManager.requestSerializer = configuration.requestSerializer;
    _requestManager.responseSerializer = configuration.responseSerializer;
    
    if (self.parametersHandler) {
        NSMutableDictionary *mutableParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
        NSMutableDictionary *mutableBultinParameters = [NSMutableDictionary dictionaryWithDictionary:configuration.builtinParameters];
        self.parametersHandler(mutableParameters, mutableBultinParameters);
        parameters = [mutableParameters copy];
        configuration.builtinParameters = [mutableBultinParameters copy];
    }
    
    NSString *combinedURL = [URLString stringByAppendingString:[self serializeParams:configuration.builtinParameters]];
    NSMutableURLRequest *request;
    
    if (block) {
        // Upload, add constructing body
        request = [_requestManager.requestSerializer multipartFormRequestWithMethod:NSStringFromLPNetworkRequestMethod(method) URLString:[[NSURL URLWithString:combinedURL relativeToURL:[NSURL URLWithString:configuration.baseURL]] absoluteString] parameters:parameters constructingBodyWithBlock:block error:nil];
    } else {
        request = [_requestManager.requestSerializer requestWithMethod:NSStringFromLPNetworkRequestMethod(method) URLString:[[NSURL URLWithString:combinedURL relativeToURL:[NSURL URLWithString:configuration.baseURL]] absoluteString] parameters:parameters error:nil];
    }
    
    if (configuration.builtinHeaders.count > 0) {
        for (NSString *key in configuration.builtinHeaders) {
            [request setValue:configuration.builtinHeaders[key] forHTTPHeaderField:key];
        }
    }
    
    AFHTTPRequestOperation *operation = [self createOperationWithConfiguration:configuration request:request];
    
    if (!startImmediately) {
        NSMutableDictionary *methodParameters = [NSMutableDictionary dictionaryWithDictionary:@{@"method":NSStringFromLPNetworkRequestMethod(method), @"URLString":URLString}];

        if (parameters) {
            methodParameters[@"parameters"] = parameters;
        }
        if (block) {
            methodParameters[@"constructingBodyWithBlock"] = block;
        }
        if (configurationHandler) {
            methodParameters[@"configurationHandler"] = configurationHandler;
        }
        if (completionHandler) {
            methodParameters[@"completionHandler"] = completionHandler;
        }
        
        [_operationMethodParameters setObject:methodParameters forKey:operation];
        return operation;
    }
    
    
    __weak typeof(self) weakSelf = self;
    
    void (^checkIfShouldDoChainOperation)(AFHTTPRequestOperation *) = ^(AFHTTPRequestOperation *operation){
        __strong typeof(self) strongSelf = weakSelf;
        AFHTTPRequestOperation *nextOperation = [strongSelf findNextOperationInChainedOperationsBy:operation];
        if (nextOperation) {
            NSDictionary *methodParameters = [_operationMethodParameters objectForKey:nextOperation];
            if (methodParameters) {
                [strongSelf requestOperationWithMethod:LPNetworkRequestMethodFromNSString(methodParameters[@"method"])
                                             URLString:methodParameters[@"URLString"]
                                            parameters:methodParameters[@"parameters"]
                                      startImmediately:YES
                             constructingBodyWithBlock:methodParameters[@"constructingBodyWithBlock"]
                                  configurationHandler:methodParameters[@"configurationHandler"]
                                     completionHandler:methodParameters[@"completionHandler"]];
                [_operationMethodParameters removeObjectForKey:nextOperation];
            } else {
                [_requestManager.operationQueue addOperation:nextOperation];
            }
        }
    };
    
    BOOL (^shouldStopProcessingRequest)(AFHTTPRequestOperation *, id userInfo, LPNetworkRequestConfiguration *) =  ^BOOL (AFHTTPRequestOperation *operation, id userInfo, LPNetworkRequestConfiguration *configuration) {
        BOOL shouldStopProcessing = NO;
        
        if (weakSelf.configuration.requestHandler) {
            weakSelf.configuration.requestHandler(operation, userInfo, &shouldStopProcessing);
        }
        
        if (configuration.requestHandler) {
            configuration.requestHandler(operation, userInfo, &shouldStopProcessing);
        }
        return shouldStopProcessing;
    };
    
    LPNetworkResponse *(^handleResponse)(AFHTTPRequestOperation *, id, BOOL) = ^ LPNetworkResponse *(AFHTTPRequestOperation *theOperation, id responseObject, BOOL isFromCache) {
        LPNetworkResponse *response = [[LPNetworkResponse alloc] init];
        // a bit trick :)
        response.error = [responseObject isKindOfClass:[NSError class]] ? responseObject : nil;
        response.result = response.error ? nil : responseObject;
        
        BOOL shouldStopProcessing = NO;
        
        if (weakSelf.configuration.responseHandler) {
            weakSelf.configuration.responseHandler(operation, configuration.userInfo, response, &shouldStopProcessing);
        }
        
        if (configuration.responseHandler) {
            configuration.responseHandler(operation, configuration.userInfo, response, &shouldStopProcessing);
        }
        
        if (shouldStopProcessing) {
            [_completionBlocks removeObjectForKey:theOperation];
            return response;
        }
        
        completionHandler(response.error, response.result, isFromCache, theOperation);
        [_completionBlocks removeObjectForKey:theOperation];
        
        checkIfShouldDoChainOperation(theOperation);
        return response;
    };
    
    if (configuration.resultCacheDuration > 0 && method == LPNetworkRequestMethodGet) {
        NSString *urlKey = [URLString stringByAppendingString:[self serializeParams:parameters]];
        id result = [_cache objectForKey:urlKey];
        if (result) {            
            if (!shouldStopProcessingRequest(operation, configuration.userInfo, configuration)) {
                handleResponse(operation, result, YES);
            } else {
                NSError *error = [NSError errorWithDomain:@"取消请求" code:kLPNetworkResponseCancelError userInfo:nil];
                handleResponse(operation, error, NO);
            }
            return operation;
        }
    }
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *theOperation, id responseObject){
        LPNetworkResponse *response = handleResponse(theOperation, responseObject, NO);
        
        if (configuration.resultCacheDuration > 0 && method == LPNetworkRequestMethodGet && !response.error) {
            NSString *urlKey = [URLString stringByAppendingString:[self serializeParams:parameters]];
            [_cache setObject:response.result forKey:urlKey];
        }
    } failure:^(AFHTTPRequestOperation *theOperation, NSError *error){
        handleResponse(theOperation, error, NO);
    }];
    
    if (!shouldStopProcessingRequest(operation, configuration.userInfo, configuration)) {
        [_requestManager.operationQueue addOperation:operation];
    } else {
        NSError *error = [NSError errorWithDomain:@"取消请求" code:kLPNetworkResponseCancelError userInfo:nil];
        handleResponse(operation, error, NO);
    }
    
    [_completionBlocks setObject:operation.completionBlock forKey:operation];
    
    return operation;
}

- (AFHTTPRequestOperation *)startOperation:(AFHTTPRequestOperation *)operation {
    NSDictionary *methodParameters = [_operationMethodParameters objectForKey:operation];
    AFHTTPRequestOperation *newOperation = operation;
    if (methodParameters) {
        newOperation = [self requestOperationWithMethod:LPNetworkRequestMethodFromNSString(methodParameters[@"method"])
                                              URLString:methodParameters[@"URLString"]
                                             parameters:methodParameters[@"parameters"]
                                       startImmediately:YES
                              constructingBodyWithBlock:methodParameters[@"constructingBodyWithBlock"]
                                   configurationHandler:methodParameters[@"configurationHandler"]
                                      completionHandler:methodParameters[@"completionHandler"]];
        [_operationMethodParameters removeObjectForKey:operation];
    } else {
        [_requestManager.operationQueue addOperation:operation];
    }
    return newOperation;
}

#pragma mark - Public

- (AFHTTPRequestOperation *)GET:(NSString *)URLString
                     parameters:(NSDictionary *)parameters
               startImmediately:(BOOL)startImmediately
           configurationHandler:(LPNetworkRequestConfigurationHandler)configurationHandler
              completionHandler:(LPNetworkRequestCompletionHandler)completionHandler {
    return [self requestOperationWithMethod:LPNetworkRequestMethodGet URLString:URLString parameters:parameters startImmediately:startImmediately constructingBodyWithBlock:nil configurationHandler:configurationHandler completionHandler:completionHandler];
}

- (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(NSDictionary *)parameters
                startImmediately:(BOOL)startImmediately
            configurationHandler:(LPNetworkRequestConfigurationHandler)configurationHandler
               completionHandler:(LPNetworkRequestCompletionHandler)completionHandler {
    return [self requestOperationWithMethod:LPNetworkRequestMethodPost URLString:URLString parameters:parameters startImmediately:startImmediately constructingBodyWithBlock:nil configurationHandler:configurationHandler completionHandler:completionHandler];
}

- (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(NSDictionary *)parameters
                startImmediately:(BOOL)startImmediately
       constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))block
            configurationHandler:(LPNetworkRequestConfigurationHandler)configurationHandler
               completionHandler:(LPNetworkRequestCompletionHandler)completionHandler {
    return [self requestOperationWithMethod:LPNetworkRequestMethodPost URLString:URLString parameters:parameters startImmediately:startImmediately constructingBodyWithBlock:block configurationHandler:configurationHandler completionHandler:completionHandler];
}


#pragma mark - Chains

- (void)addOperation:(AFHTTPRequestOperation *)operation toChain:(NSString *)chain {
    NSString *chainName = chain ? : @"";
    if (!_chainedOperations[chainName]) {
        _chainedOperations[chainName] = [[NSMutableArray alloc] init];
    }
    
    if (!((NSMutableArray *)_chainedOperations[chainName]).count) {
        operation = [self startOperation:operation];
    }
    
    [_chainedOperations[chainName] addObject:operation];
}

- (NSArray *)operationsInChain:(NSString *)chain {
    return _chainedOperations[chain];
}

- (void)removeOperation:(AFHTTPRequestOperation *)operation inChain:(NSString *)chain {
    NSString *chainName = chain ? : @"";
    if (_chainedOperations[chainName]) {
        NSMutableArray *chainedOperations = _chainedOperations[chainName];
        [chainedOperations removeObject:operation];
    }
}

- (void)removeOperationsInChain:(NSString *)chain {
    NSString *chainName = chain ? : @"";
    NSMutableArray *chainedOperations = _chainedOperations[chainName];
    chainedOperations ? [chainedOperations removeAllObjects] : @"do nothing";
}


#pragma mark - Batch

- (void)batchOfRequestOperations:(NSArray *)operations
                   progressBlock:(void (^)(NSUInteger, NSUInteger))progressBlock
                 completionBlock:(void (^)())completionBlock {
    __block dispatch_group_t group = dispatch_group_create();
    [_batchGroups addObject:group];
    __block NSInteger finishedOperationsCount = 0;
    NSInteger totalOperationsCount = operations.count;
    
    [operations enumerateObjectsUsingBlock:^(AFHTTPRequestOperation *operation, NSUInteger idx, BOOL *stop) {
        NSMutableDictionary *operationMethodParameters = [NSMutableDictionary dictionaryWithDictionary:[_operationMethodParameters objectForKey:operation]];
        if (operationMethodParameters) {
            dispatch_group_enter(group);
            LPNetworkRequestCompletionHandler originCompletionHandler = [(LPNetworkRequestCompletionHandler) operationMethodParameters[@"completionHandler"] copy];
            
            LPNetworkRequestCompletionHandler newCompletionHandler = ^(NSError *error, id result, BOOL isFromCache, AFHTTPRequestOperation *theOperation) {
                if (!isFromCache) {
                    if (progressBlock) {
                        progressBlock(++finishedOperationsCount, totalOperationsCount);
                    }
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (originCompletionHandler) {
                        originCompletionHandler(error, result, isFromCache, theOperation);
                    }
                    dispatch_group_leave(group);
                });
            };
            operationMethodParameters[@"completionHandler"] = newCompletionHandler;
            
            [_operationMethodParameters setObject:operationMethodParameters forKey:operation];
            [self startOperation:operation];
            
        }
    }];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [_batchGroups removeObject:group];
        if (completionBlock) {
            completionBlock();
        }
    });
}

#pragma mark - Cancel

- (void)cancelAllRequest {
    [_requestManager.operationQueue cancelAllOperations];
}


- (void)cancelHTTPOperationsWithMethod:(LPNetworkRequestMethod)method url:(NSString *)url {
    NSError *error;
    
    NSString *pathToBeMatched = [[[_requestManager.requestSerializer requestWithMethod:NSStringFromLPNetworkRequestMethod(method) URLString:[[NSURL URLWithString:url] absoluteString] parameters:nil error:&error] URL] path];
    
    for (NSOperation *operation in [_requestManager.operationQueue operations]) {
        if (![operation isKindOfClass:[AFHTTPRequestOperation class]]) {
            continue;
        }
        BOOL hasMatchingMethod = [NSStringFromLPNetworkRequestMethod(method) isEqualToString:[[(AFHTTPRequestOperation *)operation request] HTTPMethod]];
        BOOL hasMatchingPath = [[[[(AFHTTPRequestOperation *)operation request] URL] path] isEqual:pathToBeMatched];
        
        if (hasMatchingMethod && hasMatchingPath) {
            [operation cancel];
        }
    }
}


- (AFHTTPRequestOperation *)reAssembleOperation:(AFHTTPRequestOperation *)operation {
    AFHTTPRequestOperation *newOperation = [operation copy];
    newOperation.completionBlock = [_completionBlocks objectForKey:operation];
    [_completionBlocks removeObjectForKey:operation];
    return newOperation;
}

@end
