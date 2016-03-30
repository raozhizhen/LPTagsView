//
//  NSArray+LPKit.h
//  LoopeerLibrary
//
//  Created by dengjiebin on 12/31/14.
//  Copyright (c) 2014 Loopeer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (LPKit)


/**
 * Return an random object from the array
 *
 */
- (id)randomObject;


/**
 * Get the object at a given index in safe mode
 * Return nil if the array self is empty
 *
 */
- (id)safeObjectAtIndex:(NSUInteger)index;


/**
 * Create a reversed array from self
 *
 */
- (NSArray *)reversedArray;


/**
 * Convert self to JSON as NSString
 *
 */
- (NSString *)arrayToJson;


/**
 * Convert the given array to JSON as NSString
 *
 */
+ (NSString *)arrayToJson:(NSArray *)array;


/**
 * Convert the given array to JSON as NSString
 *
 */
+ (NSArray *)reversedArray:(NSArray *)array;

@end
