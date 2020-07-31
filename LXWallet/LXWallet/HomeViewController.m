//
//  HomeViewController.m
//  LXWallet
//
//  Created by leex on 2020/7/31.
//  Copyright © 2020 leex. All rights reserved.
//

#import "HomeViewController.h"
#import "CreateWalletController.h"
@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    
    // Do any additional setup after loading the view.
}

- (void)setupUI
{
    self.navigationItem.title = @"LXWallet";
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *createBtn = [UIButton buttonWithFont:[UIFont systemFontOfSize:14] color:[UIColor whiteColor] backgroundColor:[UIColor blueColor] text:@"创建钱包"];
    createBtn.tag = 100;
    UIButton *importBtn = [UIButton buttonWithFont:[UIFont systemFontOfSize:14] color:[UIColor whiteColor] backgroundColor:[UIColor blueColor] text:@"导入钱包"];
    [createBtn addTarget:self action:@selector(createWallet:) forControlEvents:UIControlEventTouchUpInside];
    [importBtn addTarget:self action:@selector(createWallet:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:createBtn];
    [self.view addSubview:importBtn];
    [createBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@16);
        make.right.equalTo(@-16);
        make.height.equalTo(@40);
        make.centerY.equalTo(self.view).offset(-30);
    }];
    [importBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@16);
        make.right.equalTo(@-16);
        make.height.equalTo(@40);
        make.centerY.equalTo(self.view).offset(30);
    }];
}

- (void)createWallet:(UIButton*)btn
{
    CreateWalletController *vc = [CreateWalletController new];
    if (btn.tag == 100) {
        vc.type = CreateType_Create;
    }else
    {
        vc.type = CreateType_Import;
    }
    [self.navigationController pushViewController:vc animated:YES];
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
