//
//  NSDictionary+LPKit.h
//  LoopeerLibrary
//
//  Created by dengjiebin on 12/31/14.
//  Copyright (c) 2014 Loopeer. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDictionary (LPKit)


/**
 * Merge the dictionary
 *
 */
- (NSDictionary *)dictionaryByMergingWithDictionary:(NSDictionary *)dictionary;


/**
 * Build the url encoding string with current dictionary
 *
 */
- (NSString *)urlEncodedString;


/**
 * Print the dictionary to json string
 *
 */
- (NSString *)toJsonStringWithPrettyPrint:(BOOL)prettyPrint;


/**
 * Quick Query the item from the dictionary
 *
 */
- (NSDictionary *)dictionaryForKey:(NSString *)aKey;
- (NSArray *)arrayForKey:(NSString *)aKey;
- (NSString *)stringForKey:(NSString *)aKey;
- (NSNumber *)numberForKey:(NSString *)aKey;
- (float)floatForKey:(NSString *)aKey;
- (double)doubleForKey:(NSString *)aKey;
- (int)intForKey:(NSString *)aKey;
- (long long)longLongForKey:(NSString *)aKey;
- (BOOL)boolForKey:(NSString *)aKey;
- (NSInteger)integerForKey:(NSString*)aKey;



@end
