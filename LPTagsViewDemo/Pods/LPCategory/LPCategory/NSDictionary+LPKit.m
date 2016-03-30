//
//  NSDictionary+LPKit.m
//  LoopeerLibrary
//
//  Created by dengjiebin on 12/31/14.
//  Copyright (c) 2014 Loopeer. All rights reserved.
//

#import "NSDictionary+LPKit.h"

@implementation NSDictionary (LPKit)


- (NSDictionary *)dictionaryByMergingWithDictionary:(NSDictionary *)dictionary {
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:self];
    [result addEntriesFromDictionary:dictionary];
    return [NSDictionary dictionaryWithDictionary:result];
}


// helper function: get the string form of any object
static NSString *toString(id object) {
    return [NSString stringWithFormat: @"%@", object];
}

// helper function: get the url encoded string form of any object
static NSString *urlEncode(id object) {
    NSString *string = toString(object);
    return [string stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
}

- (NSString *)urlEncodedString {
    NSMutableArray *parts = [NSMutableArray array];
    for (id key in self) {
        id value = [self objectForKey: key];
        NSString *part = [NSString stringWithFormat: @"%@=%@", urlEncode(key), urlEncode(value)];
        [parts addObject: part];
    }
    return [parts componentsJoinedByString: @"&"];
}


- (NSString *)toJsonStringWithPrettyPrint:(BOOL)prettyPrint {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:(NSJSONWritingOptions)(prettyPrint ? NSJSONWritingPrettyPrinted : 0)
                                                         error:&error];
    
    if (!jsonData) {
        NSLog(@"toJsonStringWithPrettyPrint: error: %@", error.localizedDescription);
        return @"{}";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}



- (NSDictionary *)dictionaryForKey:(NSString *)aKey {
    if (aKey) {
        id value = [self objectForKey:aKey];
        if (value && [value isKindOfClass:[NSDictionary class]])
            return value;
    }
    
    return nil;
}

- (NSArray *)arrayForKey:(NSString *)aKey {
    if (aKey) {
        id value = [self objectForKey:aKey];
        if (value && [value isKindOfClass:[NSArray class]])
            return value;
    }
    
    return nil;
}

- (NSString *)stringForKey:(NSString*)aKey {
    if (aKey) {
        id value = [self objectForKey:aKey];
        if (value) {
            if ([value isKindOfClass:[NSString class]])
                return value;
            else if ([value isKindOfClass:[NSNumber class]])
                return [value stringValue];
        }
    }
    
    return nil;
}

- (NSNumber *)numberForKey:(NSString*)aKey {
    if (aKey) {
        id value = [self objectForKey:aKey];
        if (value && [value isKindOfClass:[NSNumber class]])
            return value;
    }
    
    return nil;
}

- (float)floatForKey:(NSString *)aKey {
    if (aKey) {
        id value = [self objectForKey:aKey];
        if (value && ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]]))
            return [value floatValue];
    }
    
    return 0.0f;
}

- (double)doubleForKey:(NSString *)aKey {
    if (aKey) {
        id value = [self objectForKey:aKey];
        if (value && ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]]))
            return [value doubleValue];
    }
    
    return 0.0;
}

- (int)intForKey:(NSString *)aKey {
    if (aKey) {
        id value = [self objectForKey:aKey];
        if (value && ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]]))
            return [value intValue];
    }
    
    return 0;
}

- (long long)longLongForKey:(NSString *)aKey {
    if (aKey) {
        id value = [self objectForKey:aKey];
        if (value && ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]]))
            return [value longLongValue];
    }
    
    return 0;
}


- (BOOL)boolForKey:(NSString *)aKey {
    if (aKey) {
        id value = [self objectForKey:aKey];
        if (value && ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]]))
            return [value boolValue];
    }
    
    return NO;
}

- (NSInteger)integerForKey:(NSString*)aKey {
    if (aKey) {
        id value = [self objectForKey:aKey];
        if (value && ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]]))
            return [value integerValue];
    }
    
    return 0;
}



@end
