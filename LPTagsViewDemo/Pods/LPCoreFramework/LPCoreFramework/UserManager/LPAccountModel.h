//
//  LPAccountModel.h
//  LPCoreFrameworkDemo
//
//  Created by Han Shuai on 16/1/18.
//  Copyright © 2016年 Loopeer. All rights reserved.
//

#import "LPBaseModel.h"

@interface LPAccountModel : LPBaseModel

@property (nonatomic, strong, readonly) NSNumber *accountId;
@property (nonatomic, copy) NSString *token;

@end
