//
//  JKBigDecimal.h
//  TBWallet
//
//  Created by TB on 2020/6/24.
//  Copyright © 2020 TB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JKBigInteger.h"

NS_ASSUME_NONNULL_BEGIN

@interface JKBigDecimal : NSObject<NSCoding>
@property (nonatomic, retain) JKBigInteger *bigInteger;
@property (nonatomic, assign) NSUInteger figure;//小数位数

+ (id)decimalWithString:(NSString *) string;

- (id)initWithString:(NSString *) string;

- (id)add:(JKBigDecimal *) bigDecimal;

- (id)subtract:(JKBigDecimal *) bigDecimal;

- (id)multiply:(JKBigDecimal *) bigDecimal;

- (id)divide:(JKBigDecimal *) bigDecimal;

- (id)remainder:(JKBigDecimal *) bigInteger;
//- (NSArray *)divideAndRemainder:(JKBigDecimal *)bigInteger;

- (NSComparisonResult)compare:(JKBigDecimal *) other;

- (id)pow:(unsigned int) exponent;

- (id)negate;

- (id)abs;

- (NSString *)stringValue;

- (NSString *)description;
@end

NS_ASSUME_NONNULL_END
