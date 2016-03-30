//
//  NSString+containsString.h
//  FreeCall
//
//  Created by dengjiebin on 4/18/15.
//  Copyright (c) 2015 Loopeer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (containsString)

#if __IPHONE_OS_VERSION_MIN_REQUIRED < 80000

- (BOOL)containsString:(NSString *)aString;

#endif

@end
