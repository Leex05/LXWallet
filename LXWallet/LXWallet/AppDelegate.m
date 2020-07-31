//
//  AppDelegate.m
//  LXWallet
//
//  Created by leex on 2020/7/28.
//  Copyright © 2020 leex. All rights reserved.
//

#import "AppDelegate.h"
#import "WalletViewController.h"
#import "HomeViewController.h"
#import "LXWalletManager.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [NSThread sleepForTimeInterval:2.0f];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    if ([LXWalletManager wordsArray]) {
        self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[WalletViewController new]];
    }else
    {
        self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[HomeViewController new]];
    }
    [self.window makeKeyAndVisible];
    return YES;
}

@end
