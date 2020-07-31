//
//  NSData+AES.h
//  tdchainwallet wallet
//
//  Created by Vladimir Lebedevich on 17.07.17.
//  Copyright © 2017 tdchainwallet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (AES256)

- (NSData *)AES256EncryptWithKey:(NSString *) key;

- (NSData *)AES256DecryptWithKey:(NSString *) key;

@end
