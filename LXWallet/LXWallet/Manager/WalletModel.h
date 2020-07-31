//
//  WalletModel.h
//  LXWallet
//
//  Created by leex on 2020/7/28.
//  Copyright © 2020 leex. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WalletModel : NSObject
/*******
 钱包地址
 *******/
@property(nonatomic,strong) NSString * address;
/*******
 钱包币种
 *******/
@property(nonatomic,strong) NSString * name;
/*******
 合约名
 *******/
@property(nonatomic,strong) NSString * contractName;
/*******
 钱包icon
*******/
@property(nonatomic,strong) NSString * icon;
@end

NS_ASSUME_NONNULL_END
