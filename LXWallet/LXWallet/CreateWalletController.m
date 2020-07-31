//
//  CreateWalletController.m
//  LXWallet
//
//  Created by leex on 2020/7/31.
//  Copyright © 2020 leex. All rights reserved.
//

#import "CreateWalletController.h"
#import "ProgressHUDManager.h"
#import "WalletViewController.h"
@interface CreateWalletController ()
@property (strong,nonatomic)UITextView *textView;
@property (strong,nonatomic)UIButton *createBtn;
@end

@implementation CreateWalletController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    if (self.type == CreateType_Create) {
        self.navigationItem.title = @"创建钱包";
        NSArray *array = [[LXWalletManager sharedInstance] generateWordsArray];
        self.textView.text = [array componentsJoinedByString:@" "];
        self.textView.editable = NO;
    }else{
        self.navigationItem.title = @"导入钱包";
    }
    // Do any additional setup after loading the view.
}

- (void)setupUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    [self.view addSubview:self.textView];
    [self.view addSubview:self.createBtn];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@16);
        make.right.equalTo(@-16);
        make.top.equalTo(@10);
        make.height.mas_equalTo(150);
    }];
    UILabel *tipLab = [UILabel labelWithFont:[UIFont systemFontOfSize:14] color:[UIColor blackColor] text:@"请输入12个单词用空格隔开"];
    [self.view addSubview:tipLab];
    [tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textView);
        make.top.mas_equalTo(self.textView.mas_bottom).mas_offset(5);
    }];
    
    [self.createBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tipLab.mas_bottom).mas_offset(20);
        make.left.equalTo(@16);
        make.right.equalTo(@-16);
        make.height.equalTo(@40);
    }];
}

- (void)createAction
{
    if (self.type == CreateType_Create) {
        NSData * wordsData = [NSKeyedArchiver archivedDataWithRootObject:[self.textView.text componentsSeparatedByString:@" "]];
        [SAMKeychain setPasswordData:wordsData forService:@"service" account:@"account"];
    }else
    {
        NSArray *array = [self.textView.text componentsSeparatedByString:@" "];
        if (![array isKindOfClass:[NSArray class]]||array.count != 12) {
            [[ProgressHUDManager sharedManager] showLabelOnlyHUD:self.view withText:@"请输入12个单词用空格隔开"];
            return;
        }
        NSData * wordsData = [NSKeyedArchiver archivedDataWithRootObject:array];
        [SAMKeychain setPasswordData:wordsData forService:@"service" account:@"account"];
    }
    [UIView transitionWithView:[UIApplication sharedApplication].keyWindow duration:0.3f options:UIViewAnimationOptionTransitionCurlUp animations:^{
        
        BOOL oldState = [UIView areAnimationsEnabled];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[WalletViewController new]];
        [UIApplication sharedApplication].keyWindow.rootViewController = nav;
        [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
        [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
        [UIView setAnimationsEnabled:oldState];
        
    } completion:nil];

    
}


- (UITextView *)textView
{
    if (!_textView) {
        _textView = [UITextView new];
        _textView.layer.borderColor = [UIColor blackColor].CGColor;
        _textView.layer.borderWidth = .5f;
    }
    return _textView;
}

- (UIButton *)createBtn
{
    if (!_createBtn) {
        _createBtn = [UIButton buttonWithFont:[UIFont systemFontOfSize:14] color:[UIColor whiteColor] backgroundColor:[UIColor blueColor] text:self.type == CreateType_Create?@"创建钱包":@"导入钱包"];
        [_createBtn addTarget:self action:@selector(createAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _createBtn;
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
