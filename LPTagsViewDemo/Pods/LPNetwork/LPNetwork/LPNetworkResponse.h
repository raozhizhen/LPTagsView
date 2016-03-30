//
//  LPNetworkResponse.h
//  LoopeerNetworkDemo
//
//  Created by dengjiebin on 5/20/15.
//  Copyright (c) 2015 Loopeer. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSInteger const kLPNetworkResponseCancelError;

@interface LPNetworkResponse : NSObject


@property (nonatomic) NSError *error;
@property (nonatomic) id result;


@end
