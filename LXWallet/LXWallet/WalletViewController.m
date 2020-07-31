//
//  ViewController.m
//  LXWallet
//
//  Created by leex on 2020/7/28.
//  Copyright © 2020 leex. All rights reserved.
//

#import "WalletViewController.h"
#import "TransferController.h"
#import "HomeViewController.h"
@interface WalletViewController ()<UITableViewDelegate,UITableViewDataSource>;
@property(strong,nonatomic) UITableView *tableView;

@end

@implementation WalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self setupUI];
    // Do any additional setup after loading the view.
}
#pragma mark -UI
- (void)setupNav
{
    self.navigationItem.title = @"LXWallet";
    UIButton *walletBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    walletBtn.frame = CGRectMake(0, 0, 40,40);
    [walletBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [walletBtn setTitle:@"ETH" forState:UIControlStateNormal];
    [walletBtn setTitle:@"BTC" forState:UIControlStateSelected];
    [walletBtn addTarget:self action:@selector(changeWallet:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:walletBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    logoutBtn.frame = CGRectMake(0, 0, 40,40);
    [logoutBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [logoutBtn setTitle:@"注销" forState:UIControlStateNormal];
    [logoutBtn addTarget:self action:@selector(logoutAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:logoutBtn];
    self.navigationItem.leftBarButtonItem = leftItem;

}

- (void)logoutAction
{
    
    [SAMKeychain deletePasswordForService:@"service" account:@"account"];
//    退出清空缓存信息
    [[LXWalletManager sharedInstance] logout];
    [UIView transitionWithView:[UIApplication sharedApplication].keyWindow duration:0.3f options:UIViewAnimationOptionTransitionCurlUp animations:^{

        BOOL oldState = [UIView areAnimationsEnabled];

        HomeViewController * vc = [[HomeViewController alloc] init];
        UINavigationController * navVc = [[UINavigationController alloc] initWithRootViewController:vc];
        [UIApplication sharedApplication].keyWindow.rootViewController = navVc;

        [UIView setAnimationsEnabled:oldState];

    } completion:nil];
}

- (void)setupUI
{
    [self.view addSubview:self.tableView];
}
#pragma mark -action
- (void)changeWallet:(UIButton*)btn
{
    btn.selected = !btn.selected;
    if (btn.selected) {
        [LXWalletManager sharedInstance].currentWallet = WalletType_ETH;
    }else
    {
        [LXWalletManager sharedInstance].currentWallet = WalletType_BTC;
    }
    [self.tableView reloadData];
}

#pragma mark -delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.detailTextLabel.numberOfLines = 0;
    }
    switch (indexPath.row) {
        case 0:
        {
            cell.imageView.image = UIIMAGE([LXWalletManager sharedInstance].walletModel.icon);
            cell.textLabel.text = [LXWalletManager sharedInstance].walletModel.name;
            cell.detailTextLabel.text = [LXWalletManager sharedInstance].walletModel.address;
        }
            break;
        case 1:
        {
            cell.imageView.image = UIIMAGE([LXWalletManager sharedInstance].contract.icon);
            cell.textLabel.text = [LXWalletManager sharedInstance].contract.name;
            cell.detailTextLabel.text = [LXWalletManager sharedInstance].contract.contract;
        }
            break;
        default:
            break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TransferController *vc = [TransferController new];
    if (indexPath.row == 0) {
        vc.model = [LXWalletManager sharedInstance].walletModel;
    }else
    {
        vc.contract = [LXWalletManager sharedInstance].contract;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -lazy
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 60;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}
@end
