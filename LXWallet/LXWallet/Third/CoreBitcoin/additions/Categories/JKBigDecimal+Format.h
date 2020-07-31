//
//  JKBigDecimal+Format.h
//  tdchainwallet wallet
//
//  Created by Vladimir Lebedevich on 30.10.17.
//  Copyright © 2017 tdchainwallet. All rights reserved.
//

#import "JKBigDecimal.h"

@interface JKBigDecimal (Format)

- (NSString *)shortFormatOfNumberWithPowerOfMinus10:(JKBigDecimal *) power;

- (NSString *)shortFormatOfNumberWithPowerOf10:(NSNumber *) power;

- (JKBigDecimal *)numberWithPowerOfMinus10:(JKBigDecimal *) power;

- (JKBigDecimal *)numberWithPowerOf10:(JKBigDecimal *) power;

- (NSString *)stringNumberWithPowerOfMinus10:(JKBigDecimal *) power;

- (NSString *)stringNumberWithPowerOf10:(JKBigDecimal *) power;

- (NSString *)shortFormatOfNumber;

@end
