//
//  TBCoinModel.h
//  TBWallet
//
//  Created by leex on 2020/7/15.
//  Copyright © 2020 TB. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Contract : NSObject<NSCoding>
@property(nonatomic,copy) NSString * name;
@property(nonatomic,strong) NSString * contract;
@property(nonatomic,copy) NSNumber * coin_decimals;
@property(nonatomic,copy) NSString * coin_pic;
@property(nonatomic,copy) NSString * icon;
@end

NS_ASSUME_NONNULL_END
