//
//  TransactionScriptBuilder.h
//  TBWallet
//
//  Created by TB on 2020/6/24.
//  Copyright © 2020 TB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QTUMBigNumber.h"

NS_ASSUME_NONNULL_BEGIN

@interface TransactionScriptBuilder : NSObject
- (BTCScript *)createContractScriptWithBiteCode:(NSData *) bitcode
                                    andGasLimit:(tdchainwalletBigNumber *) aGasLimit
                                    andGasPrice:(tdchainwalletBigNumber *) aGasPrice;

- (BTCScript *)sendContractScriptWithBiteCode:(NSData *) bitcode
                           andContractAddress:(NSData *) address
                                  andGasLimit:(tdchainwalletBigNumber *) aGasLimit
                                  andGasPrice:(tdchainwalletBigNumber *) aGasPrice;
@end

NS_ASSUME_NONNULL_END
