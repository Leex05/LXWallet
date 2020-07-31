//
//  NSString+Extension.h
//  tdchainwallet wallet
//
//  Created by Vladimir Lebedevich on 23.02.17.
//  Copyright © 2017 tdchainwallet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

+ (NSString *)valueForKey:(NSString *) key fromQueryItems:(NSArray *) queryItems;

+ (NSData *)dataFromHexString:(NSString *) string;

+ (NSString *)hexadecimalString:(NSData *) data;

+ (NSString *)invertHex:(NSString *) hexString;

+ (NSString *)stringFromCamelCase:(NSString *) camelString;

+ (NSString *)randomStringWithLength:(int) len;

- (NSDate *)date;

- (BOOL)isDecimalString;

- (NSString*)firstMatchedStringWithPattern:(NSString*) pattern;

+ (NSString *)interceptDecimalPoint:(NSString *)string bit:(NSInteger)bitNum;
@end
