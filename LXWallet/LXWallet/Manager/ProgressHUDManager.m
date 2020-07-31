//
//  ProgressHudManager.m
//  lubanpay
//
//  Created by Curly_Lin on 15/11/24.
//  Copyright © 2015年 Curly_Lin. All rights reserved.
//

#import "ProgressHUDManager.h"
#import <UIKit/UIKit.h>
#import <MBProgressHUD.h>

@implementation ProgressHUDManager
{
    MBProgressHUD *_hud;
}

+ (instancetype)sharedManager
{
    static ProgressHUDManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    
    return sharedManager;
}

- (void)showLabelOnlyHUD:(UIView *)view withText:(NSString *)text
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = text;
    hud.margin = 15.f;
    hud.removeFromSuperViewOnHide = YES;
    
    hud.yOffset = -32;
    
    [hud hide:YES afterDelay:1];
}

- (void)showIndicatorAndLabelHUD:(UIView *)view withText:(NSString *)text withTaskBlock:(TaskBlock)taskBlock
{
    _hud = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:_hud];
    
    _hud.delegate = self;
    _hud.labelText = text;
    
    [_hud showAnimated:YES whileExecutingBlock:^{
        //在taskBlock中之行任务，任务之行完毕后，HUD会自动隐藏
        taskBlock();
    }];
}

- (void)showHUD:(UIView *)view withText:(NSString *)text
{
    _hud = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:_hud];
    
    _hud.delegate = self;
    _hud.labelText = text;
    
    [_hud show:YES];
}

- (void)hideHUD
{
    [_hud hide:YES];
}

- (void)showHUDInTableView:(UITableView *)tableView withText:(NSString *)text
{
    tableView.scrollEnabled = NO;
    
    _hud = [[MBProgressHUD alloc] initWithView:tableView];
    [tableView addSubview:_hud];
    
    _hud.delegate = self;
    _hud.labelText = text;
    
    [_hud show:YES];
}

- (void)hideHUDInTableView:(UITableView *)tableView
{
    tableView.scrollEnabled = YES;
    
    [_hud hide:YES];
}

- (void)showHUDInView:(UIView *)view withText:(NSString *)text
{
    _hud = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:_hud];
    
    _hud.delegate = self;
    _hud.labelText = text;
    
    _hud.yOffset = -32;
    
    [_hud show:YES];
}

- (void)hideHUDInView:(UIView *)view
{    
    [_hud hide:YES];
}

#pragma mark - Custom Methods


#pragma mark - MBProgressHUDDelegate

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    // Remove HUD from screen when the HUD was hidded
    [_hud removeFromSuperview];
}

@end
