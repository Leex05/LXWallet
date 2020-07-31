//
//  CreateWalletController.h
//  LXWallet
//
//  Created by leex on 2020/7/31.
//  Copyright © 2020 leex. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    CreateType_Create,//BTC
    CreateType_Import,//ETH
} CreateType;
@interface CreateWalletController : UIViewController
@property (assign,nonatomic)CreateType type;
@end

NS_ASSUME_NONNULL_END
