//
//  LXWalletManager.h
//  LXWallet
//
//  Created by leex on 2020/7/28.
//  Copyright © 2020 leex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WalletModel.h"
#import "Contract.h"
/*******
 * 钱包类型
 *******/
typedef enum : NSUInteger {
    WalletType_BTC,//BTC
    WalletType_ETH,//ETH
} WalletType;
@interface LXWalletManager : NSObject
@property(strong,nonatomic)WalletModel *walletModel;//当前钱包
@property(strong,nonatomic)Contract *contract;//合约
@property(assign,nonatomic)WalletType currentWallet;//钱包类型
@property (strong,nonatomic)BTCKeychain *keyChain;
+ (instancetype)sharedInstance;
+ (NSArray*)wordsArray;

- (NSArray *)generateWordsArray;
- (void)logout;
@end

