//
//  TransferController.h
//  LXWallet
//
//  Created by leex on 2020/7/31.
//  Copyright © 2020 leex. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TransferController : UIViewController
@property(strong,nonatomic)WalletModel *model;
@property(strong,nonatomic)Contract *contract;
@end

NS_ASSUME_NONNULL_END
