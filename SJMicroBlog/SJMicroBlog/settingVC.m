//
//  settingVC.m
//  SJMicroBlog
//
//  Created by qingyun on 15/12/25.
//  Copyright © 2015年 iGhibli. All rights reserved.
//

#import "settingVC.h"
#import "Account.h"
#import "MainTabBarVC.h"
#import "SDImageCache.h"

@interface settingVC ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *cellTitles;
@property (nonatomic, strong) NSArray *cellActions;
@end

@implementation settingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //根据是否登录显示不同的设置界面
    if ([[Account currentAccount] isLogin]) {
        //登录时的界面
        self.cellTitles = @[@[@"账号管理"],
                            @[@"通知", @"隐私与安全", @"通用设置"],
                            @[@"清理缓存", @"意见反馈", @"关于微博"],
                            @[@"退出当前账号"]
                            ];
    }else {
        //未登录时的界面
        self.cellTitles = @[@[@"通用设置"],
                            @[@"关于微博"]
                            ];
    }
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cellTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.cellTitles[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    //退出当前帐号Cell状态特殊处理
    if (indexPath.section == 3 && indexPath.row == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.textLabel.text = self.cellTitles[indexPath.section][indexPath.row];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = [UIColor redColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
        return cell;
    }
    //其他Cell共同状态设置
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingCell" forIndexPath:indexPath];
    
    cell.textLabel.text = self.cellTitles[indexPath.section][indexPath.row];
    //添加缓存大小数据显示
    if (indexPath.section == 2 && indexPath.row == 0) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f M",[[SDImageCache sharedImageCache] getSize] / 1024.f /1024.f];
    }else {
        cell.detailTextLabel.text = nil;
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 3 && indexPath.row == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            //删除登录信息
            [[Account currentAccount] logoutAndDeleteAllInfo];
            
            //清除cookies，解决退出登录后直接使用cookies记录直接登录完成问题
            NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
            [storage.cookies enumerateObjectsUsingBlock:^(NSHTTPCookie * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [storage deleteCookie:obj];
            }];
 
            //模态消失当前界面
            [self.navigationController popViewControllerAnimated:YES];
            //获取Window
            UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
            //通过Window的RootViewController取到MainTabBarVC
            MainTabBarVC *mainVC = (MainTabBarVC *)window.rootViewController;
            //退出跳转到发现界面
            [mainVC logoutJumpToFindVC];
            
        }];
        UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:firstAction];
        [alert addAction:secondAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
