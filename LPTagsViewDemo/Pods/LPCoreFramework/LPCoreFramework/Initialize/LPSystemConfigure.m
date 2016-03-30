//
//  LPSystemConfigure.m
//  LPCoreFramework
//
//  Created by dengjiebin on 7/3/15.
//  Copyright (c) 2015 Loopeer. All rights reserved.
//

#import "LPSystemConfigure.h"

@implementation LPSystemConfigure

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"isAppStoreReviewing" : @"appstore_reviewing",
             @"timeZone"            : @"timezone",
             @"qiniuUploadToken"    : @"up_token"
              };
}


@end
