//
//  LPCoreManager.h
//  LPCoreFrameworkDemo
//
//  Created by dengjiebin on 6/18/15.
//  Copyright (c) 2015 Loopeer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LPCoreManager : NSObject

@property (nonatomic, assign, readonly) BOOL isFirstLaunch;

+ (instancetype)sharedManager;


@end
