//
//  LPSystemConfigureManager.h
//  LPCoreFramework
//
//  Created by dengjiebin on 7/3/15.
//  Copyright (c) 2015 Loopeer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LPSystemConfigure.h"

@interface LPSystemConfigureManager : NSObject

+ (instancetype)sharedInstance;

- (void)update:(LPSystemConfigure *)configure;
- (void)clear;

- (LPSystemConfigure *)configure;


@end
