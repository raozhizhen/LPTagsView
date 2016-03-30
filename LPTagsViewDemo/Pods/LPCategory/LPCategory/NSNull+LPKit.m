//
//  NSNull+LPKit.m
//  LoopeerLibrary
//
//  Created by dengjiebin on 12/31/14.
//  Copyright (c) 2014 Loopeer. All rights reserved.
//

#import "NSNull+LPKit.h"

#define NSNullObjects @[@"",@0,@{},@[]]


@implementation NSNull (LPKit)


- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature* signature = [super methodSignatureForSelector:aSelector];
    if (!signature) {
        for (NSObject *object in NSNullObjects) {
            signature = [object methodSignatureForSelector:aSelector];
            if (signature) {
                break;
            }
        }
    }
    return signature;
}


- (void)forwardInvocation:(NSInvocation *)anInvocation {
    SEL aSelector = [anInvocation selector];
    
    for (NSObject *object in NSNullObjects) {
        if ([object respondsToSelector:aSelector]) {
            [anInvocation invokeWithTarget:object];
            return;
        }
    }
    
    [self doesNotRecognizeSelector:aSelector];
}

@end
