//
//  NSString+Extension.m
//  tdchainwallet wallet
//
//  Created by Vladimir Lebedevich on 23.02.17.
//  Copyright © 2017 tdchainwallet. All rights reserved.
//

@implementation NSString (Extension)

+ (NSString *)valueForKey:(NSString *) key
		   fromQueryItems:(NSArray *) queryItems {

	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name=%@", key];
	NSURLQueryItem *queryItem = [[queryItems
			filteredArrayUsingPredicate:predicate]
			firstObject];
	return queryItem.value;
}

+ (NSData *)dataFromHexString:(NSString *) string {

	NSString *newString = [string lowercaseString];
	NSMutableData *data = [NSMutableData new];
	unsigned char whole_byte;
	char byte_chars[3] = {'\0', '\0', '\0'};
	int i = 0;
	int length = (int)newString.length;
	while (i < length - 1) {
		char c = [newString characterAtIndex:i++];
		if (c < '0' || (c > '9' && c < 'a') || c > 'f')
			continue;
		byte_chars[0] = c;
		byte_chars[1] = [newString characterAtIndex:i++];
		whole_byte = strtol (byte_chars, NULL, 16);
		[data appendBytes:&whole_byte length:1];
	}
	return data;
}

//
+ (NSString *)hexadecimalString:(NSData *) data {
	/* Returns hexadecimal string of NSData. Empty string if data is empty.   */
	const unsigned char *dataBuffer = (const unsigned char *)[data bytes];

	if (!dataBuffer)
		return [NSString string];

	NSUInteger dataLength = [data length];
	NSMutableString *hexString = [NSMutableString stringWithCapacity:(dataLength * 2)];

	for (int i = 0; i < dataLength; ++i)
		[hexString appendString:[NSString stringWithFormat:@"%02lx", (unsigned long)dataBuffer[i]]];

	return [NSString stringWithString:hexString];
}

+ (NSString *)invertHex:(NSString *) hexString {

	NSMutableString *reversedString = [NSMutableString string];
	NSInteger charIndex = [hexString length];

	while (hexString && charIndex > 0) {
		charIndex -= 2;
		NSRange subStrRange = NSMakeRange (charIndex, 2);
		NSString *substring = [hexString substringWithRange:subStrRange];
		[reversedString appendString:[substring substringWithRange:NSMakeRange (0, 1)]];
		[reversedString appendString:[substring substringWithRange:NSMakeRange (1, 1)]];
	}

	return reversedString;
}

+ (NSString *)stringFromCamelCase:(NSString *) camelString {

	NSMutableString *newStr = [NSMutableString string];

	for (NSInteger i = 0; i < camelString.length; i++) {
		NSString *ch = [camelString substringWithRange:NSMakeRange (i, 1)];
		if ([ch rangeOfCharacterFromSet:[NSCharacterSet uppercaseLetterCharacterSet]].location != NSNotFound) {
			[newStr appendString:@" "];
		}
		[newStr appendString:ch];
	}
//	DebugLog(@"%@", newStr.capitalizedString);
	return newStr.capitalizedString;
}

- (NSString*)firstMatchedStringWithPattern:(NSString*) pattern {
    
    NSRegularExpression *functionRegex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:NULL];
    NSArray<NSTextCheckingResult *> *matches = [functionRegex matchesInString:self options:0 range:NSMakeRange (0, self.length)];
    
    for (NSTextCheckingResult *match in matches) {
        
        if (match.numberOfRanges > 1) {
            NSRange range = [match rangeAtIndex:1];
            return [self substringWithRange:range];
        } else {
            break;
        }
    }
    
    return @"";
}

+ (NSString *)randomStringWithLength:(int) len {

	NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
	NSMutableString *randomString = [NSMutableString stringWithCapacity:len];

	for (int i = 0; i < len; i++) {
		[randomString appendFormat:@"%C", [letters characterAtIndex:arc4random_uniform ((uint32_t)[letters length])]];
	}

	return randomString;
}

- (NSDate *)date {

	NSDateFormatter *fullDateFormater = [[NSDateFormatter alloc] init];
	fullDateFormater.dateFormat = @"Y-M-d hh:mm:ss";
	fullDateFormater.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
	return [fullDateFormater dateFromString:self];
}

- (BOOL)isDecimalString {

	NSString *expression = @"^[0-9]*((\\.|,)[0-9]{0,})?$";
	NSError *error = nil;
	NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression options:NSRegularExpressionCaseInsensitive error:&error];
	NSUInteger numberOfMatches = [regex numberOfMatchesInString:self options:0 range:NSMakeRange (0, [self length])];
	return numberOfMatches != 0;
}


+ (NSString *)interceptDecimalPoint:(NSString *)string bit:(NSInteger)bitNum{
    NSString *returnStr = string;
    if ([returnStr isEqualToString:@"--"]) {
        return returnStr;
    }
    //判断是否包含小数点
    if ([string containsString:@"."]) {
        //截取字符串
        NSArray *bits = [string componentsSeparatedByString:@"."];
        //如果bits数量大于2说明小数点不止一个
        if (bits.count == 2) {
            NSString *integerStr = [bits firstObject];
            
            NSString *bit = [bits lastObject];
            NSString *newBit = bit;
            if (bit.length >= bitNum) {
                newBit = [bit substringToIndex:bitNum];
            }else{
                for (NSInteger i = bit.length; i < bitNum; i ++) {
                    newBit = [newBit stringByAppendingString:@"0"];
                }
            }
            string = [NSString stringWithFormat:@"%@.%@",integerStr,newBit];
        }
    }else{
        string = [string stringByAppendingString:@"."];
        for (int i = 0; i < bitNum; i ++) {
            string = [string stringByAppendingString:@"0"];
        }
    }
    returnStr = string;
    return returnStr;
}
@end
