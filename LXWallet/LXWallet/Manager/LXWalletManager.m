//
//  LXWalletManager.m
//  LXWallet
//
//  Created by leex on 2020/7/28.
//  Copyright © 2020 leex. All rights reserved.
//

#import "LXWalletManager.h"
#import "WordsArray.h"
@interface LXWalletManager ()
@property (strong,nonatomic)WalletModel *btcModel;
@property (strong,nonatomic)WalletModel *ethModel;
@property (strong,nonatomic)Contract *btcContract;
@property (strong,nonatomic)Contract *ethContract;
@end

@implementation LXWalletManager
static NSString *ethContractName = @"ethcontract";
static NSString *btcContractName = @"btccontract";

+ (instancetype)sharedInstance {

    static LXWalletManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once (&onceToken, ^{
        instance = [[super alloc] init];
    });
    return instance;
}

#pragma mark -助记词
//生成助记词
- (NSArray *)generateWordsArray {

    NSMutableArray *randomWords = [NSMutableArray new];
    
    NSInteger i = 0;
    
    while (i < 12) {
        uint32_t rnd = arc4random_uniform ((uint32_t)wordsArray ().count);
        NSString *randomWord = wordsArray ()[rnd];

        if (![randomWords containsObject:randomWord]) {
            [randomWords addObject:randomWord];
            i++;
        }
    }

    return randomWords;
}

#pragma mark -create
- (BTCKeychain *)createKeychainWithSeedWords:(NSArray *) seedWords {
    BTCMnemonic *mnemonic = [[BTCMnemonic alloc] initWithWords:seedWords password:nil wordListType:BTCMnemonicWordListTypeUnknown];
    //NSLog(@"seed = %@",mnemonic.seed);
    BTCKeychain *keyChain = [mnemonic.keychain derivedKeychainWithPath:@"m/44'/0'/0'/0/0"];
    return keyChain;
}

//获取助记词
+ (NSArray*)wordsArray
{
    NSData * wordsData = [SAMKeychain passwordDataForService:@"service" account:@"account"];
    NSArray * wordsArray = [NSKeyedUnarchiver unarchiveObjectWithData:wordsData];
    return wordsArray;
}

//当前钱包
- (WalletModel *)walletModel
{
    switch (self.currentWallet) {
        case WalletType_BTC:
        {
            return self.btcModel;
        }
            break;
        case WalletType_ETH:
        {
            return self.ethModel;
        }
            break;
        default:
            break;
    }
    return nil;
}

//当前合约
- (Contract *)contract
{
    switch (self.currentWallet) {
        case WalletType_BTC:
        {
            return self.btcContract;
        }
            break;
        case WalletType_ETH:
        {
            return self.ethContract;
        }
            break;
        default:
            break;
    }
    return nil;
}

#pragma mark -lazy
/*******
BTC Mdoel
*******/
- (WalletModel *)btcModel
{
    if (!_btcModel) {
        _btcModel = [WalletModel new];
        _btcModel.address = self.btcAddress;
        _btcModel.contractName = btcContractName;
        _btcModel.name = @"BTC";
        _btcModel.icon = @"BTC";
    }
    return _btcModel;
}

/*******
 ETH Mdoel
 *******/
- (WalletModel *)ethModel
{
    if (!_ethModel) {
        _ethModel = [WalletModel new];
        _ethModel.address = self.ethAddress;
        _ethModel.contractName = ethContractName;
        _ethModel.name = @"ETH";
        _ethModel.icon = @"ETH";
    }
    return _ethModel;
}

/****
 *OMNI USDT
 ****/
- (Contract *)btcContract
{
    if (!_btcContract) {
        _btcContract = [Contract new];
        _btcContract.contract = self.btcAddress;
        _btcContract.name = @"OMNI USDT";
        _btcContract.icon = @"OMNI_USDT";
        _btcContract.coin_decimals = @6;
    }
    return _btcContract;
}

/****
 *ERC20 USDT
 ****/
- (Contract *)ethContract
{
    if (!_ethContract) {
        _ethContract = [Contract new];
        _ethContract.contract = @"0xdac17f958d2ee523a2206206994597c13d831ec7";
        _ethContract.name = @"ERC20 USDT";
        _ethContract.icon = @"ERC20_USDT";
        _ethContract.coin_decimals = @6;
    }
    return _ethContract;
}

/*******
 BTC地址
 *******/
- (NSString *)btcAddress
{
    return self.keyChain.key.btcAddress.string;
}

/*******
 ETH地址
 *******/
- (NSString *)ethAddress
{
    NSArray * wordsArray = [LXWalletManager wordsArray];
    if (wordsArray) {
        Account *account = [Account accountWithMnemonicPhrase:[wordsArray componentsJoinedByString:@" "]];
        return account.address.checksumAddress;
    } else {
        return nil;
    }
}

/*******
 BTC子秘钥
 *******/
- (BTCKeychain*)keyChain
{
    if (!_keyChain) {
        NSArray * wordsArray = [LXWalletManager wordsArray];
        _keyChain = [self createBTCKeychainWithSeedWords:wordsArray];
    }
    return _keyChain;
}

//由根密钥（mnemonic.keychain）生成子密钥（keyChain）
- (BTCKeychain *)createBTCKeychainWithSeedWords:(NSArray *) seedWords {

    BTCMnemonic *mnemonic = [[BTCMnemonic alloc] initWithWords:seedWords password:nil wordListType:BTCMnemonicWordListTypeUnknown];
    //NSLog(@"seed = %@",mnemonic.seed);
    BTCKeychain *keyChain = [mnemonic.keychain derivedKeychainWithPath:@"m/44'/0'/0'/0/0"];

    return keyChain;
}
- (WalletType)currentWallet
{
    if (!_currentWallet) {
        _currentWallet = WalletType_BTC;
    }
    return _currentWallet;
}

- (void)logout
{
    self.btcModel = nil;
    self.ethModel = nil;
    self.keyChain = nil;
}
@end
