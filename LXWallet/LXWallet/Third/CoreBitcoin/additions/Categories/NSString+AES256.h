//
//  NSString+AES256.h
//  tdchainwallet wallet
//
//  Created by Vladimir Lebedevich on 17.07.17.
//  Copyright © 2017 tdchainwallet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (AES256)

+ (NSString *)encryptString:(NSString *) plaintext withKey:(NSString *) key;

+ (NSString *)decryptString:(NSString *) ciphertext withKey:(NSString *) key;

@end
