//
//  NSArray+LPKit.m
//  LoopeerLibrary
//
//  Created by dengjiebin on 12/31/14.
//  Copyright (c) 2014 Loopeer. All rights reserved.
//

#import "NSArray+LPKit.h"

@implementation NSArray (LPKit)


- (id)randomObject {
    if(self.count<1) return nil;
    
    return self[arc4random() % [self count]];
}

- (id)safeObjectAtIndex:(NSUInteger)index {
    if ([self count] > 0)
        return [self objectAtIndex:index];
    else
        return nil;
}

- (NSArray *)reversedArray {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[self count]];
    NSEnumerator *enumerator = [self reverseObjectEnumerator];
    
    for (id element in enumerator) {
        [array addObject:element];
    }
    
    return array;
}

- (NSString *)arrayToJson {
    NSString *json = nil;
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
    if(!error) {
        json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        return json;
    } else {
        return nil;
    }
}

+ (NSString *)arrayToJson:(NSArray*)array {
    NSString *json = nil;
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:array options:0 error:&error];
    if(!error) {
        json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        return json;
    } else {
        return nil;
    }
}

+ (NSArray *)reversedArray:(NSArray*)array {
    NSMutableArray *arrayTemp = [NSMutableArray arrayWithCapacity:[array count]];
    NSEnumerator *enumerator = [array reverseObjectEnumerator];
    
    for(id element in enumerator) {
        [arrayTemp addObject:element];
    }
    
    return array;
}

@end
