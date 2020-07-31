//
//  LXTransferManager.h
//  LXWallet
//
//  Created by leex on 2020/7/28.
//  Copyright © 2020 leex. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LXTransferManager : NSObject
+ (instancetype)sharedInstance;

/****
 * ETH请自行申请APIKEY，这里调用的infura.io第三方节点
 ****/
#pragma mark -ETH和合约转账
/****
 * ETH和合约转账
 * Params:
 * toAddress 转账地址
 * decimal 小数精度 18gwei
 * amount 转账金额
 * gasPrice 通过接口获取最佳gasPrice
 * gasLimit token合约默认60000，ETH为21000
 * tokenETH 合约地址，传空则为转账ETH
 * return:
 * hashStr 失败返回空，成功返回交易哈希txid
 * success 失败返回NO，成功返回YES
 * ErrorMessage 返回错误信息
 ****/
-(void)sendToAssress:(NSString *)toAddress amount:(NSString *)amount tokenETH:(NSString *)tokenETH decimal:(NSString *)decimal gasPrice:(NSString *)gasPrice gasLimit:(NSString *)gasLimit block:(void(^)(NSString *hashStr,BOOL success,NSString *ErrorMessage))block;


/****
 * 获取ETH手续费
 ****/
- (void)fetchETHGas:(void(^)(BigNumberPromise *proGasPrice))block;

#pragma mark -BTC转账
/****
 * BTC转账
 * Params:
 * toAddress 转账地址
 * feeString 手续费
 * amount 转账金额
 * return:
 * txHash 返回空则转账失败，成功返回交易哈希txid
 ****/
- (void)transferBTCTo:(NSString *)toAddress
    amount:(NSString *)amount
       fee:(NSString *)feeString
           completion:(void(^)(NSString *txHash))completion;



/****
 * OMNI转账
 * Params:
 * toAddress 转账地址
 * feeString 手续费
 * omniId OMNI USDT 31
 * omniValue 转账金额
 * return:
 * txHash 返回空则转账失败，成功返回交易哈希txid
 ****/
- (void)transactionOMNITo:(NSString *)toAddress
       fee:(NSString *)feeString
 omniValue:(NSString *)omniValue
    omniId:(NSString *)omniId
               completion:(void(^)(NSString *txHash))completion;
@end

NS_ASSUME_NONNULL_END
