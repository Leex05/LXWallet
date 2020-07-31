//
//  UtxoModel.h
//  TBWallet
//
//  Created by TB on 2020/6/24.
//  Copyright © 2020 TB. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UtxoModel : NSObject
@property(nonatomic,strong) NSString * address;
@property(nonatomic,strong) NSString * txid;
@property(nonatomic,assign)  uint32_t vout;
@property(nonatomic,strong) NSString * scriptPubKey;
@property(nonatomic,strong) NSString * amount;
@property(nonatomic,strong) NSString * satoshis;
@property(nonatomic,assign) BOOL isStake;
@property(nonatomic,strong) NSString * height;
@property(nonatomic,strong) NSString * confirmations;


@property(nonatomic,strong) NSString * value;
@property(nonatomic) uint32_t tx_output_n;
@property(nonatomic,strong) NSString * tx_hash;

@end

NS_ASSUME_NONNULL_END
