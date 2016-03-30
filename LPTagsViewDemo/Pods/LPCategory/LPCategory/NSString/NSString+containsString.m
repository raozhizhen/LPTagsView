//
//  NSString+containsString.m
//  FreeCall
//
//  Created by dengjiebin on 4/18/15.
//  Copyright (c) 2015 Loopeer. All rights reserved.
//

#import "NSString+containsString.h"
#import <objc/runtime.h>

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wincomplete-implementation"
@implementation NSString (ContainsString)
#pragma GCC diagnostic pop

#if __IPHONE_OS_VERSION_MIN_REQUIRED < 80000

+ (void)load {
    @autoreleasepool {
        [self ll_modernizeSelector:NSSelectorFromString(@"containsString:") withSelector:@selector(ll_containsString:)];
    }
}

+ (void)ll_modernizeSelector:(SEL)originalSelector withSelector:(SEL)newSelector {
    if (![NSString instancesRespondToSelector:originalSelector]) {
        Method newMethod = class_getInstanceMethod(self, newSelector);
        class_addMethod(self, originalSelector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod));
    }
}

// containsString: has been added in iOS 8. We dynamically add this if we run on iOS 7.
- (BOOL)ll_containsString:(NSString *)aString {
    return [self rangeOfString:aString].location != NSNotFound;
}

#endif

@end
