//
//  NSObject+Catch.m
//  tdchainwallet wallet
//
//  Created by Vladimir Lebedevich on 21.05.17.
//  Copyright © 2016 tdchainwallet. All rights reserved.
//

#import "NSNull+Catch.h"

@implementation NSNull (Catch)


- (NSMethodSignature *)methodSignatureForSelector:(SEL) aSelector {
	NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];

	if (!signature) {
		signature = [NSMethodSignature signatureWithObjCTypes:"@:"];
	}

	return signature;
}

- (void)forwardInvocation:(NSInvocation *) anInvocation {
	//[NSException raise:NSInvalidArgumentException format:@"NULL EXEPTION"];
}

- (NSNumber *)roundedNumberWithScale:(NSInteger) scale {
	return [NSNumber new];
}

@end
