//
//  TransferController.m
//  LXWallet
//
//  Created by leex on 2020/7/31.
//  Copyright © 2020 leex. All rights reserved.
//

#import "TransferController.h"
#import "ProgressHUDManager.h"
@interface TransferController ()
@property (strong,nonatomic)UITextField *addressTF;
@property (strong,nonatomic)UITextField *amountTF;
@property (strong,nonatomic)UITextField *feeTF;
@property (strong,nonatomic)NSString *gasPrice;
@property (strong,nonatomic)NSString *gasLimit;

@end

@implementation TransferController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    [self setupUI];
    [self fetchFee];
    // Do any additional setup after loading the view.
}

- (void)setupUI
{
    self.navigationItem.title = [NSString stringWithFormat:@"%@转账",self.model?self.model.name:self.contract.name];
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *addressLab = [UILabel labelWithFont:[UIFont systemFontOfSize:14] color:[UIColor blackColor] text:@"地址"];
    UILabel *amountLab = [UILabel labelWithFont:[UIFont systemFontOfSize:14] color:[UIColor blackColor] text:@"金额"];
    UILabel *feeLab = [UILabel labelWithFont:[UIFont systemFontOfSize:14] color:[UIColor blackColor] text:@"手续费"];
    NSString *address = ([LXWalletManager sharedInstance].currentWallet == WalletType_BTC)?@"3DUGBKHbNn7RhEkeFZvLYCd2ijXKncGhMJ":@"0x71436d6e4F5EA69dCe337D51aF9fB159EFCCF84B";
    self.addressTF = [self createTFwithPlaceHolder:@"地址" text:address];
    self.amountTF = [self createTFwithPlaceHolder:@"金额" text:@""];
    self.amountTF.keyboardType = UIKeyboardTypeDecimalPad;
    self.feeTF = [self createTFwithPlaceHolder:@"手续费" text:@""];
    self.feeTF.text = [NSString stringWithFormat:@"0.0002 %@",[LXWalletManager sharedInstance].walletModel.name];
    self.feeTF.enabled = NO;
    self.feeTF.keyboardType = UIKeyboardTypeDecimalPad;
    UIButton *transferBtn = [UIButton buttonWithFont:[UIFont systemFontOfSize:14] color:[UIColor whiteColor] backgroundColor:[UIColor blueColor] text:@"转账"];
    [transferBtn addTarget:self action:@selector(transferAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addressLab];
    [self.view addSubview:amountLab];
    [self.view addSubview:feeLab];
    [self.view addSubview:self.addressTF];
    [self.view addSubview:self.amountTF];
    [self.view addSubview:self.feeTF];
    [self.view addSubview:transferBtn];
    [addressLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(10);
    }];
    [self.addressTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addressLab);
        make.height.mas_equalTo(30);
        make.right.equalTo(self.view).offset(-16);
        make.top.mas_equalTo(addressLab.mas_bottom).mas_offset(10);
    }];
    [amountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addressLab);
        make.top.mas_equalTo(self.addressTF.mas_bottom).mas_offset(10);
    }];
    [self.amountTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.addressTF);
        make.top.mas_equalTo(amountLab.mas_bottom).mas_offset(10);
    }];
    [feeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addressLab);
        make.top.mas_equalTo(self.amountTF.mas_bottom).mas_offset(10);
    }];
    [self.feeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.addressTF);
        make.top.mas_equalTo(feeLab.mas_bottom).mas_offset(10);
    }];
    
    [transferBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.addressTF);
        make.height.mas_equalTo(49);
        make.top.mas_equalTo(self.feeTF.mas_bottom).mas_offset(30);
    }];
}

//调用接口API获取最佳手续费
- (void)fetchFee
{
    if ([LXWalletManager sharedInstance].currentWallet == WalletType_ETH) {
        __weak typeof(self)weakSelf=self;
        [[LXTransferManager sharedInstance] fetchETHGas:^(BigNumberPromise *proGasPrice) {
            if (!proGasPrice.error) {
                weakSelf.gasPrice = [proGasPrice.value div:[BigNumber bigNumberWithDecimalString:@"1000000000"]].decimalString;
            }else
            {
                weakSelf.gasPrice = [[[BigNumber bigNumberWithDecimalString:@"1000000000"] div:[BigNumber bigNumberWithDecimalString:@"500"]] div:[BigNumber bigNumberWithDecimalString:self.gasLimit]].decimalString;
            }
            double fee = weakSelf.gasPrice.doubleValue*weakSelf.gasLimit.doubleValue/1000000000.f;
            weakSelf.feeTF.text = [NSString stringWithFormat:@"%f ETH",fee];
        }];
    }else
    {
        self.feeTF.text = @"0.0002 BTC";
    }
    
}

- (UITextField*)createTFwithPlaceHolder:(NSString*)placeHolder text:(NSString*)text
{
    UITextField *tf = [UITextField new];
    tf.placeholder = placeHolder;
    tf.font = [UIFont systemFontOfSize:14];
    tf.text = text;
    return tf;
}

//ETH 21000 合约60000
-(NSString *)gasLimit
{
    if (self.contract) {
        _gasLimit = @"60000";
    }else
    {
        _gasLimit = @"21000";
    }
    return _gasLimit;
}

//转账
- (void)transferAction
{
    if (self.amountTF.text.doubleValue <= 0) {
        [[ProgressHUDManager sharedManager] showLabelOnlyHUD:self.view withText:@"请输入转账金额"];
        return;
    }
    if (self.amountTF.text.length == 0) {
        [[ProgressHUDManager sharedManager] showLabelOnlyHUD:self.view withText:@"请输入转账地址"];
        return;
    }
    __weak typeof(self)weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if ([LXWalletManager sharedInstance].currentWallet == WalletType_BTC) {
        NSString *fee = [[NSDecimalNumber decimalNumberWithString:[self.feeTF.text substringToIndex:self.feeTF.text.length - 4]] decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"100000000"]].stringValue;
        if (self.contract) {
            [[LXTransferManager sharedInstance] transactionOMNITo:self.addressTF.text fee:fee omniValue:self.addressTF.text omniId:@"31" completion:^(NSString * _Nonnull txHash) {
                [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                if (txHash) {
                    [[ProgressHUDManager sharedManager] showLabelOnlyHUD:weakSelf.view withText:@"转账成功"];
                }else
                {
                    [[ProgressHUDManager sharedManager] showLabelOnlyHUD:weakSelf.view withText:@"转账失败"];
                }
            }];
        }else
        {
            [[LXTransferManager sharedInstance] transferBTCTo:self.addressTF.text amount:self.addressTF.text fee:fee completion:^(NSString * _Nonnull txHash) {
                [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                if (txHash) {
                    [[ProgressHUDManager sharedManager] showLabelOnlyHUD:weakSelf.view withText:@"转账成功"];
                }else
                {
                    [[ProgressHUDManager sharedManager] showLabelOnlyHUD:weakSelf.view withText:@"转账失败"];
                }
            }];
        }
    }else if ([LXWalletManager sharedInstance].currentWallet == WalletType_ETH) {
        NSString *token = self.contract.contract;
        [[LXTransferManager sharedInstance] sendToAssress:self.addressTF.text amount:self.amountTF.text tokenETH:token decimal:@"18" gasPrice:self.gasPrice gasLimit:self.gasLimit block:^(NSString * _Nonnull hashStr, BOOL success, NSString * _Nonnull ErrorMessage) {
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            if (!success) {
                [[ProgressHUDManager sharedManager] showLabelOnlyHUD:self.view withText:ErrorMessage?:@"转账失败"];
            }else
            {
                [[ProgressHUDManager sharedManager] showLabelOnlyHUD:self.view withText:@"转账成功"];
            }
        }];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
