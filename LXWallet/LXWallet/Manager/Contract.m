//
//  TBCoinModel.m
//  TBWallet
//
//  Created by leex on 2020/7/15.
//  Copyright © 2020 TB. All rights reserved.
//

#import "Contract.h"

@implementation Contract
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.coin_pic forKey:@"coin_pic"];
    [aCoder encodeObject:self.coin_decimals forKey:@"coin_decimals"];
    [aCoder encodeObject:self.contract forKey:@"contract"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.coin_pic = [aDecoder decodeObjectForKey:@"coin_pic"];
        self.coin_decimals = [aDecoder decodeObjectForKey:@"coin_decimals"];
        self.contract = [aDecoder decodeObjectForKey:@"contract"];
    }
    return self;
}
@end
