//
//  ProgressHudManager.h
//  lubanpay
//
//  Created by Curly_Lin on 15/11/24.
//  Copyright © 2015年 Curly_Lin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MBProgressHUD.h>

typedef void (^TaskBlock)(void);

@interface ProgressHUDManager : NSObject <MBProgressHUDDelegate>

+ (instancetype)sharedManager;

- (void)showLabelOnlyHUD:(UIView *)view withText:(NSString *)text;

- (void)showIndicatorAndLabelHUD:(UIView *)view withText:(NSString *)text withTaskBlock:(TaskBlock)taskBlock;

- (void)showHUD:(UIView *)view withText:(NSString *)text;

- (void)hideHUD;

- (void)showHUDInTableView:(UITableView *)tableView withText:(NSString *)text;

- (void)hideHUDInTableView:(UITableView *)tableView;

- (void)showHUDInView:(UIView *)view withText:(NSString *)text;

- (void)hideHUDInView:(UIView *)view;

@end
