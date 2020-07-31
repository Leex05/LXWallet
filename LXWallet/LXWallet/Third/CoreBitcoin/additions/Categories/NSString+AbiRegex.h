//
//  NSString+AbiRegex.h
//  tdchainwallet wallet
//
//  Created by Vladimir Lebedevich on 30.08.17.
//  Copyright © 2017 tdchainwallet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (AbiRegex)

- (BOOL)isUintFromAbi;

- (BOOL)isIntFromAbi;

- (BOOL)isBytesFixedFromAbi;

- (BOOL)isBytesFromAbi;

- (BOOL)isAddressFromAbi;

- (BOOL)isStringFromAbi;

- (BOOL)isBoolFromAbi;

- (BOOL)isArrayFromAbi;

- (BOOL)isArrayOfArraysFromAbi;

- (BOOL)isFixedArrayOfStringFromAbi;

- (BOOL)isDynamicArrayOfStringFromAbi;

- (BOOL)isFixedArrayOfUintFromAbi;

- (BOOL)isDynamicArrayOfUintFromAbi;

- (BOOL)isFixedArrayOfIntFromAbi;

- (BOOL)isDynamicArrayOfIntFromAbi;

- (BOOL)isFixedArrayOfBoolFromAbi;

- (BOOL)isDynamicArrayOfBoolFromAbi;

- (BOOL)isFixedArrayOfBytesFromAbi;

- (BOOL)isDynamicArrayOfBytesFromAbi;

- (BOOL)isFixedArrayOfFixedBytesFromAbi;

- (BOOL)isDynamicArrayOfFixedBytesFromAbi;

- (BOOL)isFixedArrayOfAddressesFromAbi;

- (BOOL)isDynamicArrayOfAddressesFromAbi;

- (NSInteger)arraySize;

- (NSInteger)fixedBytesSize;

- (NSInteger)uintSize;

- (NSInteger)intSize;

- (NSArray<NSString *> *)dynamicArrayElementsFromParameter;

- (NSArray<NSString *> *)dynamicArrayStringsFromParameter;

@end
