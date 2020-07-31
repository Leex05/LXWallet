//
//  LXTransferManager.m
//  LXWallet
//
//  Created by leex on 2020/7/28.
//  Copyright © 2020 leex. All rights reserved.
//

#import "LXTransferManager.h"
#import "UtxoModel.h"
#import "NSString+Category.h"
@interface LXTransferManager ()
@property(nonatomic,strong) BTCTransactionBuilder * transactionBuilder;
@property(nonatomic,strong) InfuraProvider * queryManager;
@end
@implementation LXTransferManager
static NSString *APIKEY_ETH = @"YourAPIKEY";


+ (instancetype)sharedInstance {
    static LXTransferManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once (&onceToken, ^{
        instance = [[super alloc] init];
    });
    return instance;
}

#pragma mark -ETH/合约转账
-(void)sendToAssress:(NSString *)toAddress amount:(NSString *)amount tokenETH:(NSString *)tokenETH decimal:(NSString *)decimal gasPrice:(NSString *)gasPrice gasLimit:(NSString *)gasLimit block:(void(^)(NSString *hashStr,BOOL success,NSString *ErrorMessage))block
{
    //创建账号
    __block Account * senderAccount = [Account accountWithMnemonicPhrase:[[LXWalletManager wordsArray] componentsJoinedByString:@" "]];
    __block InfuraProvider * queryManager = [[InfuraProvider alloc]initWithChainId:ChainIdHomestead accessToken:APIKEY_ETH];
    NSString *addressStr = senderAccount.address.checksumAddress;
    //从发送人地址，创建交易对象
    __block Transaction * transactionManager = [Transaction transactionWithFromAddress:[Address addressWithString:addressStr]];

    [[queryManager getTransactionCount:transactionManager.fromAddress] onCompletion:^(IntegerPromise *pro) {
        if (pro.error != nil)
        {
            NSLog(@"%@获取nonce失败",pro.error);

            block(@"",NO,@"创建交易失败");
        }

        else
        {
            NSLog(@"获取nonce成功 值为%ld",pro.value);
            transactionManager.nonce = pro.value;
            transactionManager.gasPrice = [[BigNumber bigNumberWithDecimalString:gasPrice] mul:[BigNumber bigNumberWithDecimalString:@"1000000000"]];;

            transactionManager.chainId = queryManager.chainId;

            //设置收件人地址
            transactionManager.toAddress = [Address addressWithString:toAddress];

            //设置转账数量
            NSInteger i = amount.doubleValue * pow(10.0, decimal.integerValue);
            BigNumber *b = [BigNumber bigNumberWithInteger:i];
            transactionManager.value = b;

            //默认ETH币
            if (tokenETH == nil)
            {

                if (gasLimit == nil)
                {

                    transactionManager.gasLimit = [BigNumber bigNumberWithDecimalString:@"21000"];
                }
                else
                {

                    NSLog(@"手动设置了gasLimit = %@",gasLimit);
                    transactionManager.gasLimit = [BigNumber bigNumberWithDecimalString:gasLimit];
                }


                transactionManager.data = [SecureData secureDataWithCapacity:0].data;

            }

            else
            {
                if (gasLimit == nil)
                {

                    transactionManager.gasLimit = [BigNumber bigNumberWithDecimalString:@"60000"];
                }
                else
                {
                    NSLog(@"手动设置了gasLimit = %@",gasLimit);
                    transactionManager.gasLimit = [BigNumber bigNumberWithDecimalString:gasLimit];
                }



                SecureData *data = [SecureData secureDataWithCapacity:68];
                [data appendData:[SecureData hexStringToData:@"0xa9059cbb"]];

                NSData *dataAddress = transactionManager.toAddress.data;//转入地址（真实代币转入地址添加到data里面）
                for (int i=0; i < 32 - dataAddress.length; i++)
                {
                    [data appendByte:'\0'];
                }

                [data appendData:dataAddress];

                NSData *valueData = transactionManager.value.data;//真实代币交易数量添加到data里面
                for (int i=0; i < 32 - valueData.length; i++)
                {
                    [data appendByte:'\0'];
                }
                [data appendData:valueData];

                transactionManager.value = [BigNumber constantZero];
                transactionManager.data = data.data;
                transactionManager.toAddress = [Address addressWithString:tokenETH];//合约地址（代币交易 转入地址为合约地址）
            }

            //设置签名
            [senderAccount sign:transactionManager];

            NSData * signedTransaction = [transactionManager serialize];

            //转账
            [[queryManager sendTransaction:signedTransaction] onCompletion:^(HashPromise *pro)
            {
                 NSLog(@"CloudKeychainSigner: Sent - signed=%@ hash=%@ error=%@", signedTransaction, pro.value, pro.error);
                if (!pro.error)
                {
                    NSLog(@"\n---------------【生成转账交易成功！！！！】--------------\n哈希值 = %@\n",transactionManager.transactionHash.hexString);
                    NSLog(@"哈希值 =  %@",pro.value.hexString);
                     block(pro.value.hexString,YES,@"发送成功");

                }
                else
                {
                    
                    block(@"",NO,[pro.error.userInfo objectForKey:@"reason"]?:@"发送失败");
                }

            }];
            
        }

    }];
}

- (void)fetchETHGas:(void(^)(BigNumberPromise *proGasPrice))block{
    [[self.queryManager getGasPrice] onCompletion:^(BigNumberPromise *proGasPrice) {
        if (!proGasPrice.error)
        {
            block(proGasPrice);
        }
    }];
}


- (NSString *)convertToJsonData:(NSDictionary *)dic {

    NSData *data=[NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];

    NSString *jsonStr=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];

    //去除空格和回车：
    jsonStr = [jsonStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    NSLog(@"jsonStr==%@",jsonStr);
    jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"\\" withString:@""];

    NSMutableString *responseString = [NSMutableString stringWithString:jsonStr];

    NSString *character = nil;

    for (int i = 0; i < responseString.length; i ++) {

        character = [responseString substringWithRange:NSMakeRange(i, 1)];

        if ([character isEqualToString:@"\\"])

            [responseString deleteCharactersInRange:NSMakeRange(i, 1)];

    }
    return responseString;
}

#pragma mark-eth manager
- (InfuraProvider*)queryManager
{
    if (!_queryManager) {
        _queryManager = [[InfuraProvider alloc]initWithChainId:ChainIdHomestead accessToken:APIKEY_ETH];
    }
    return _queryManager;
}


#pragma mark -BTC转账
- (void)transferBTCTo:(NSString *)toAddress
    amount:(NSString *)amount
       fee:(NSString *)feeString
completion:(void(^)(NSString *txHash))completion
{
//    获取为花费
    [LXTransferManager unspentOutputsWithAddress:[LXWalletManager sharedInstance].walletModel.address completion:^(NSArray *array) {
        if (![array isKindOfClass:[NSArray class]]) {
            completion(nil);
            return;
        }
        long long fee = [NSDecimalNumber decimalNumberWithString:feeString].longLongValue;
//       构造交易，签名
        [LXTransferManager transactionTo:toAddress amount:amount fee:fee utxos:array transactionCallBack:^(NSError *error, BTCTransaction *transaction) {
            if (error||!transaction) {
                completion(nil);
                return;
            }
//            广播
            [LXTransferManager pushTx:transaction.hex completion:completion];
        }];
    }];
}


#pragma mark -OMNI转账
- (void)transactionOMNITo:(NSString *)toAddress
       fee:(NSString *)feeString
 omniValue:(NSString *)omniValue
    omniId:(NSString *)omniId
completion:(void(^)(NSString *txHash))completion
{
    [LXTransferManager unspentOutputsWithAddress:[LXWalletManager sharedInstance].walletModel.address completion:^(NSArray *array) {
        if (![array isKindOfClass:[NSArray class]]) {
            completion(nil);
            return;
        }
        long long fee = [NSDecimalNumber decimalNumberWithString:feeString].longLongValue;
        [self transactionTo:toAddress fee:fee omniValue:omniValue omniId:omniId utxos:array transactionCallBack:^(NSError *error, BTCTransaction *transaction) {
            if (error||!transaction) {
                completion(nil);
                return;
            }
            [LXTransferManager pushTx:transaction.hex completion:completion];
        }];

    }];
}

#pragma mark -广播
+ (void)pushTx:(NSString *)tx
    completion:(void(^)(NSString *hash))completion {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:tx forKey:@"tx"];

    NSString * testUrl = @"https://api.blockcypher.com/v1/btc/main/txs/push";

    NSDictionary *request = dic;
    NSError *error = nil;
    NSData *body = [NSJSONSerialization dataWithJSONObject:request options:0 error:&error];
    [LXTransferManager fetch:[NSURL URLWithString:testUrl] body:body callback:^(NSData *data, NSError *error) {
        if (!error) {
            NSDictionary *dic = [LXTransferManager dictionaryForJsonData:data];
            dispatch_async(dispatch_get_main_queue(), ^() {
                completion([[dic objectForKey:@"tx"] objectForKey:@"hash"]);
            });

        }else
        {
            dispatch_async(dispatch_get_main_queue(), ^() {
                completion(nil);
            });
        }
    }];
}

+ (void)fetch: (NSURL*)url body: (NSData*)body callback: (void (^)(NSData*, NSError*))callback {
    void (^handleResponse)(NSData*, NSURLResponse*, NSError*) = ^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
//            _errorCount++;
            NSDictionary *userInfo = @{@"error": error, @"url": url};
            callback(nil, [NSError errorWithDomain:ProviderErrorDomain code:ProviderErrorServerUnknownError userInfo:userInfo]);
            return;
        }
        
        if (![response isKindOfClass:[NSHTTPURLResponse class]]) {
//            _errorCount++;
            NSDictionary *userInfo = @{@"reason": @"response not NSHTTPURLResponse", @"url": url};
            callback(nil, [NSError errorWithDomain:ProviderErrorDomain code:ProviderErrorBadResponse userInfo:userInfo]);
            return;
        }
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
        if (httpResponse.statusCode != 200&&httpResponse.statusCode != 201) {
//            _errorCount++;
            NSDictionary *userInfo = @{@"statusCode": @(httpResponse.statusCode), @"url": url};
            callback(nil, [NSError errorWithDomain:ProviderErrorDomain code:ProviderErrorBadResponse userInfo:userInfo]);
            return;
        }
        
        callback(data, nil);
    };
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^() {
//        _requestCount++;
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
        [request setValue:[Provider userAgent] forHTTPHeaderField:@"User-Agent"];
        
        if (body) {
            [request setHTTPMethod:@"POST"];
            [request setValue:[NSString stringWithFormat:@"%d", (int)body.length] forHTTPHeaderField:@"Content-Length"];
            [request setHTTPBody:body];
        }
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:handleResponse];
        [task resume];
    });
    
}

+ (NSDictionary *)dictionaryForJsonData:(NSData *)jsonData

{

    if (![jsonData isKindOfClass:[NSData class]] || jsonData.length < 1) {

        return nil;

    }

    id jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];

    if (![jsonObj isKindOfClass:[NSDictionary class]]) {

        return nil;

    }

    return [NSDictionary dictionaryWithDictionary:(NSDictionary *)jsonObj];

}

#pragma mark - 构造签名btc交易
+ (void)transactionTo:(NSString *)toAddress
               amount:(NSString *)amountString
                  fee:(BTCAmount)fee
                utxos:(NSArray *)utxos
  transactionCallBack:(void(^)(NSError *error, BTCTransaction *transaction))transactionCallBack {
    long long amount = [NSString numberValueString:amountString decimal:@"8" isPositive:YES].longLongValue;
    [LXTransferManager createTransactionFrom:[LXWalletManager sharedInstance].walletModel.address to:toAddress amount:amount fee:fee omniId:nil omniValue:nil utxos:utxos transactionCallBack:^(NSError *error, BTCTransaction *transaction) {
        if (error||!transaction) {
            transactionCallBack(error,nil);
            return;
        }
        [LXTransferManager signTransaction:transaction btcKey:[LXWalletManager sharedInstance].keyChain.key transactionCallBack:transactionCallBack];

    }];
}

#pragma mark - 构造签名Omni交易
- (void)transactionTo:(NSString *)toAddress
                  fee:(BTCAmount)fee
            omniValue:(NSString *)omniValue
               omniId:(NSString *)omniId
                utxos:(NSArray *)utxos
  transactionCallBack:(void(^)(NSError *error, BTCTransaction *transaction))transactionCallBack {
    [LXTransferManager createTransactionFrom:[LXWalletManager sharedInstance].walletModel.address to:toAddress amount:546 fee:fee omniId:omniId omniValue:omniValue utxos:utxos transactionCallBack:^(NSError *error, BTCTransaction *transaction) {
        if (error||!transaction) {
            transactionCallBack(error,nil);
            return;
        }
        [LXTransferManager signTransaction:transaction btcKey:[LXWalletManager sharedInstance].keyChain.key transactionCallBack:transactionCallBack];
    }];
}

#pragma mark -获取未花费
+ (void)unspentOutputsWithAddress:(NSString *)address
                       completion:(void(^)(NSArray *array))completion {
    NSString * urlStr = [NSString stringWithFormat:@"https://chain.api.btc.com/v3/address/%@/unspent",address];
    [LXNetWork GET:urlStr parameters:nil headers:nil success:^(id responseObject) {
        NSMutableArray * temp = [NSMutableArray array];
        NSArray *array = [[responseObject objectForKey:@"data"] objectForKey:@"list"];
        if (![array isKindOfClass:[NSArray class]]) {
            completion(nil);
            return;
        }
        for (int i = 0; i < array.count; i++) {
            UtxoModel * utxo = [UtxoModel mj_objectWithKeyValues:array[i]];
            BTCTransactionOutput * output = [[BTCTransactionOutput alloc] init];
            output.index = utxo.tx_output_n;
            output.value = BTCAmountFromDecimalNumber([NSNumber numberWithLongLong:utxo.value.longLongValue]);
            //这步比较重要，txid是hexstring，先把hexstring转data，在reverse这个data，要用corebitcoin库提供的方法转
            output.transactionHash = BTCReversedData(BTCDataFromHex(utxo.tx_hash));
            //这步要是hex初始化，scriptPubKey也是hexstring
            output.script = [[BTCScript alloc] initWithAddress:[BTCPublicKeyAddress addressWithData:BTCHash160([LXWalletManager sharedInstance].keyChain.key.compressedPublicKey)]];
            [temp addObject:output];
        }
        completion(temp);
    } failure:^(NSError *error) {
        completion(nil);
    }];
}
     
#pragma mark - 签名交易
+ (void)signTransaction:(BTCTransaction *)tx
                 btcKey:(BTCKey *)key
    transactionCallBack:(void(^)(NSError *error, BTCTransaction *transaction))transactionCallBack {
    if (!key) {
        if (transactionCallBack) {
            transactionCallBack([NSError errorWithDomain:@"com.seal.BTCDemo.errorDomain" code:100 userInfo:@{NSLocalizedDescriptionKey: @"error account"}], nil);
        }
        return;
    }
    NSError *error;
    // Sign all inputs. We now have both inputs and outputs defined, so we can sign the transaction.
    for (int i = 0; i < tx.inputs.count; i++) {
        // Normally, we have to find proper keys to sign this txin, but in this
        // example we already know that we use a single private key.
        BTCTransactionInput *txin = tx.inputs[i];
        
        BTCSignatureHashType hashtype = BTCSignatureHashTypeAll;
        
        NSData *hash;
        BTCScript *txoutScript = txin.signatureScript;
        hash = [tx signatureHashForScript:txoutScript inputIndex:i hashType:hashtype error:&error];
        
        if (!hash) {
            if (transactionCallBack) {
                transactionCallBack(error, nil);
            }
            return;
        }
        NSData *signature = [key signatureForHash:hash hashType:hashtype];
        BTCScript *signatureScript = [[[BTCScript new] appendData:signature] appendData:key.publicKey];
        txin.signatureScript = signatureScript;
    }
    if (transactionCallBack) {
        transactionCallBack(nil, tx);
    }
}


#pragma mark - 构造交易
+ (void)createTransactionFrom:(NSString *)fromAddress
                           to:(NSString *)toAddress
                       amount:(BTCAmount)amount
                          fee:(BTCAmount)fee
                       omniId:(NSString *)omniId
                    omniValue:(NSString *)omniValue
                        utxos:(NSArray *)utxos
          transactionCallBack:(void(^)(NSError *error, BTCTransaction *transaction))transactionCallBack {
    NSError* error = nil;
    
    if (!utxos) {
        if (transactionCallBack) {
            transactionCallBack(error, nil);
        }
        return;
    }
    if (utxos.count == 0) {
        if (transactionCallBack) {
            transactionCallBack([NSError errorWithDomain:@"com.seal.BTCDemo.errorDomain" code:100 userInfo:@{NSLocalizedDescriptionKey: @"No free outputs to spend"}], nil);
        }
        return;
    }
    
    BTCAddress *from = [BTCAddress addressWithString:fromAddress];
    BTCAddress *to = [BTCAddress addressWithString:toAddress];
    
    // Find enough outputs to spend the total amount.
    BTCAmount totalAmount = amount + fee;
    
    // Sort utxo in order of
    utxos = [utxos sortedArrayUsingComparator:^(BTCTransactionOutput *obj1, BTCTransactionOutput *obj2) {
        if (obj1.value > obj2.value) {
            return NSOrderedAscending;
        } else {
            return NSOrderedDescending;
        }
    }];
    
    NSMutableArray* txouts = [[NSMutableArray alloc] init];
    long total = 0;
    
    for (BTCTransactionOutput* txout in utxos) {
        [txouts addObject:txout];
        total += txout.value;
        if (total >= (totalAmount)) {
            break;
        }
    }
    
    if (total < totalAmount) {
        if (transactionCallBack) {
            transactionCallBack(error, nil);
        }
        return;
    }
    
    // Create a new transaction
    BTCTransaction *tx = [[BTCTransaction alloc] init];
    tx.fee = fee;
    BTCAmount spentCoins = 0;
    
    // Add all outputs as inputs
    
    for (BTCTransactionOutput *txout in txouts) {
        BTCTransactionInput *txin = [[BTCTransactionInput alloc] init];
        txin.previousHash = txout.transactionHash;
        txin.previousIndex = txout.index;
        txin.signatureScript = txout.script;
//        txin.sequence = 4294967295;
        txin.value = txout.value;
        
        [tx addInput:txin];
        spentCoins += txout.value;
    }
    
    
    if (omniId != nil) {
        //构造omni交易
        BTCScript *omniScript = [[BTCScript alloc] init];
        [omniScript appendOpcode:OP_RETURN];
        long long omniAmount = [NSString numberValueString:omniValue decimal:@"8" isPositive:YES].longLongValue;
        NSString *omniHex = [NSString stringWithFormat:@"6f6d6e69%016x%016llx", [omniId intValue], omniAmount];//6f6d6e69
        [omniScript appendData:BTCDataFromHex(omniHex)];
        BTCTransactionOutput *omniOutput = [[BTCTransactionOutput alloc] initWithValue:0 script:omniScript];
        [tx addOutput:omniOutput];
    }
    
    // Add required outputs - payment and change
    BTCTransactionOutput* paymentOutput = [[BTCTransactionOutput alloc] initWithValue:amount address:to];
    [tx addOutput:paymentOutput];


    BTCTransactionOutput* changeOutput = [[BTCTransactionOutput alloc] initWithValue:(spentCoins - totalAmount) address:from];
    // Idea: deterministically-randomly choose which output goes first to improve privacy.
    if (changeOutput.value > 0) {
        [tx addOutput:changeOutput];
    }
    
    if (transactionCallBack) {
        transactionCallBack(nil, tx);
    }
}
@end
