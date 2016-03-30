//
//  LPNetworkResponseCache.h
//  LoopeerNetworkDemo
//
//  Created by dengjiebin on 5/20/15.
//  Copyright (c) 2015 Loopeer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LPNetworkResponseCache : NSObject

- (void)setObject:(id <NSCoding>)object forKey:(NSString *)key;

- (id <NSCoding>)objectForKey:(NSString *)key;

- (void)removeObjectForKey:(NSString *)key;

- (void)trimToDate:(NSDate *)date;

- (void)removeAllObjects;

@end
