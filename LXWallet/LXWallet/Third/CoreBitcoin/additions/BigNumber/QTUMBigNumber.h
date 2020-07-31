//
//  QTUMBigNumber.h
//  TBWallet
//
//  Created by TB on 2020/6/24.
//  Copyright © 2020 TB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JKBigDecimal.h"

NS_ASSUME_NONNULL_BEGIN

@interface QTUMBigNumber : NSObject

@end

@interface tdchainwalletBigNumber : NSObject

@property (strong, nonatomic, readonly) JKBigDecimal *decimalContainer;

+ (instancetype)decimalWithString:(NSString *) string;

+ (instancetype)decimalWithInteger:(NSInteger) integer;

- (instancetype)initWithString:(NSString *) string;

- (instancetype)initWithInteger:(NSInteger) integer;


- (instancetype)add:(tdchainwalletBigNumber *) bigDecimal;

- (instancetype)subtract:(tdchainwalletBigNumber *) bigDecimal;

- (instancetype)multiply:(tdchainwalletBigNumber *) bigDecimal;

- (instancetype)divide:(tdchainwalletBigNumber *) bigDecimal;

- (instancetype)remainder:(tdchainwalletBigNumber *) bigInteger;

- (NSComparisonResult)compare:(tdchainwalletBigNumber *) other;

- (instancetype)pow:(unsigned int) exponent;

- (instancetype)negate;

- (instancetype)abs;

- (NSString *)stringValue;

- (NSInteger)integerValue;

- (NSString *)description;

- (int64_t)satoshiAmountValue;

- (NSInteger)tdchainwalletAmountValue;

@end

@interface tdchainwalletBigNumber (Comparison)

- (BOOL)isLessThan:(tdchainwalletBigNumber *) decimalNumber;

- (BOOL)isLessThanOrEqualTo:(tdchainwalletBigNumber *) decimalNumber;

- (BOOL)isGreaterThan:(tdchainwalletBigNumber *) decimalNumber;

- (BOOL)isGreaterThanOrEqualTo:(tdchainwalletBigNumber *) decimalNumber;

- (BOOL)isEqualToDecimalNumber:(tdchainwalletBigNumber *) decimalNumber;

- (BOOL)isEqualToInt:(int) i;

- (BOOL)isGreaterThanInt:(int) i;

- (BOOL)isGreaterThanOrEqualToInt:(int) i;

- (BOOL)isLessThanInt:(int) i;

- (BOOL)isLessThanOrEqualToInt:(int) i;

- (NSDecimalNumber *)decimalNumber;

- (tdchainwalletBigNumber *)roundedNumberWithScale:(NSInteger) scale;

@end

@interface tdchainwalletBigNumber (Format)

- (NSString *)shortFormatOfNumberWithPowerOfMinus10:(tdchainwalletBigNumber *) power;

- (NSString *)shortFormatOfNumberWithPowerOf10:(tdchainwalletBigNumber *) power;

- (tdchainwalletBigNumber *)numberWithPowerOfMinus10:(tdchainwalletBigNumber *) power;

- (tdchainwalletBigNumber *)numberWithPowerOf10:(tdchainwalletBigNumber *) power;

- (NSString *)stringNumberWithPowerOfMinus10:(tdchainwalletBigNumber *) power;

- (NSString *)stringNumberWithPowerOf10:(tdchainwalletBigNumber *) power;

- (NSString *)shortFormatOfNumber;

@end

@interface tdchainwalletBigNumber (Constants)

+ (tdchainwalletBigNumber*)maxBigNumberWithPowerOfTwo:(NSInteger) power isUnsigned:(BOOL) isUnsigned;

@end

NS_ASSUME_NONNULL_END
