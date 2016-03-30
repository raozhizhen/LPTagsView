//
//  LPSystemConfigure.h
//  LPCoreFramework
//
//  Created by dengjiebin on 7/3/15.
//  Copyright (c) 2015 Loopeer. All rights reserved.
//

#import "MTLModel.h"
#import <MTLJSONAdapter.h>

@interface LPSystemConfigure : MTLModel <MTLJSONSerializing>

@property (nonatomic, assign) BOOL isAppStoreReviewing;
@property (nonatomic, copy) NSString *timeZone;
@property (nonatomic, copy) NSString *qiniuUploadToken;

@end
