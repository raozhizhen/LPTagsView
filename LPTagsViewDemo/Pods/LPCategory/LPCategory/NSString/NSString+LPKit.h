//
//  NSString+LPKit.h
//  LoopeerLibrary
//
//  Created by dengjiebin on 12/31/14.
//  Copyright (c) 2014 Loopeer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface NSString (LPKit)


- (NSString *)MD5Hash;
- (NSString *)sha1;
- (NSString *)reverse;

- (BOOL)isEmail;
- (NSString *)stringByStrippingWhitespace;
- (NSString *)substringFrom:(NSInteger)from to:(NSInteger)to;
- (NSString *)capitalizeFirst:(NSString *)source;
- (NSString *)underscoresToCamelCase:(NSString*)underscores;
- (NSString *)camelCaseToUnderscores:(NSString *)input;
- (NSUInteger)countWords;
- (BOOL)contains:(NSString *)string;
- (BOOL)isBlank;

- (NSString *)urlEncode;
- (NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding;
- (NSString *)urlDecode;
- (NSString *)urlDecodeUsingEncoding:(NSStringEncoding)encoding;


+ (BOOL)isStringEmpty:(NSString *)string;
+ (NSString *)stringWithMD5OfFile:(NSString *)path;


@end
