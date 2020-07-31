//
//  TransactionBuilder.h
//  TBWallet
//
//  Created by TB on 2020/6/24.
//  Copyright © 2020 TB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TransactionScriptBuilder.h"
#import "QTUMBigNumber.h"

typedef NS_ENUM(NSInteger, TransactionManagerErrorType) {
    TransactionManagerErrorTypeNone,
    TransactionManagerErrorTypeNoInternetConnection,
    TransactionManagerErrorTypeServer,
    TransactionManagerErrorTypeOups,
    TransactionManagerErrorTypeNotEnoughMoney,
    TransactionManagerErrorTypeNotEnoughMoneyOnAddress,
    TransactionManagerErrorTypeNotEnoughFee,
    TransactionManagerErrorTypeNotEnoughGasLimit,
    TransactionManagerErrorTypeInvalidAddress
};

NS_ASSUME_NONNULL_BEGIN



@interface TransactionBuilder : NSObject

- (instancetype)initWithScriptBuilder:(TransactionScriptBuilder *) scriptBuilder;

/*
- (BTCTransaction *)smartContractCreationTxWithUnspentOutputs:(NSArray *) unspentOutputs
                                                   withAmount:(NSInteger) amount
                                                  withBitcode:(NSData *) bitcode
                                                      withFee:(NSInteger) fee
                                                 withGasLimit:(tdchainwalletBigNumber *) gasLimit
                                                 withGasprice:(tdchainwalletBigNumber *) gasPrice
                                               withWalletKeys:(NSArray<BTCKey *> *) walletKeys;
*/
- (void)callContractTxWithUnspentOutputs:(NSArray <BTCTransactionOutput *> *) unspentOutputs
                                  amount:(NSInteger) amount
                         contractAddress:(NSData *) contractAddress
                               toAddress:(NSString *) toAddress
                           fromAddresses:(NSArray<NSString *> *) fromAddresses
                                 bitcode:(NSData *) bitcode
                                 withFee:(NSInteger) fee
                            withGasLimit:(tdchainwalletBigNumber *) gasLimit
                            withGasprice:(tdchainwalletBigNumber *) gasPrice
                              walletKeys:(NSArray<BTCKey *> *) walletKeys
                              andHandler:(void (^)(TransactionManagerErrorType errorType, BTCTransaction *transaction)) completion;

- (void)regularTransactionWithUnspentOutputs:(NSArray <BTCTransactionOutput *> *) unspentOutputs
                                      amount:(NSInteger) amount
                          amountAndAddresses:(NSArray *) amountAndAddresses
                                     withFee:(NSInteger) fee
                                  walletKeys:(NSArray<BTCKey *> *) walletKeys
                                  andHandler:(void (^)(TransactionManagerErrorType errorType, BTCTransaction *transaction)) completion;


@end

NS_ASSUME_NONNULL_END
