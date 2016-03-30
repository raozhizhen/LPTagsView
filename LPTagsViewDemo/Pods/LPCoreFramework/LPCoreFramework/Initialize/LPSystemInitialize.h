//
//  LPSystemInitialize.h
//  LPCoreFrameworkDemo
//
//  Created by dengjiebin on 10/19/15.
//  Copyright (c) 2015 Loopeer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LPSystemInitialize : NSObject


/**
 * Setup the the system configure initialize
 *
 * Attention: It will be invoke after the LPNetworkServices init complete, Best practice to be invoke in applicationDidBecomeActive.
 *
 * @requestURL the init API request URL
 * @modelClass The class should be the subclass of LPSystemConfigure
 */
+ (void)setupWithRequestURL:(NSString *)requestURL modelOfClass:(Class)modelClass completeHandler:(void(^)())completeHandler;

@end
