//
//  LPBaseModel.m
//  LPCoreFrameworkDemo
//
//  Created by dengjiebin on 10/28/15.
//  Copyright (c) 2015 Loopeer. All rights reserved.
//

#import "LPBaseModel.h"

@implementation LPBaseModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError **)error {
    self = [super initWithDictionary:dictionaryValue error:error];
    if (self == nil)
        return nil;
    
    return self;
}

- (NSDictionary *)dictionaryValue {
    NSMutableDictionary *modifiedDictionaryValue = [[super dictionaryValue] mutableCopy];
    
    for (NSString *originalKey in [super dictionaryValue]) {
        if ([self valueForKey:originalKey] == nil) {
            [modifiedDictionaryValue removeObjectForKey:originalKey];
        }
    }
    
    return [modifiedDictionaryValue copy];
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return nil;
}


@end
