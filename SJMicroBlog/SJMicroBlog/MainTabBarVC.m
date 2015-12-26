//
//  MainTabBarVC.m
//  SJMicroBlog
//
//  Created by qingyun on 15/12/25.
//  Copyright © 2015年 iGhibli. All rights reserved.
//

#import "MainTabBarVC.h"
#import "Account.h"
#import "Common.h"
#import "AppDelegate.h"

@interface MainTabBarVC ()

@end

@implementation MainTabBarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if (![[Account currentAccount] isLogin]) {
        //未登录时直接进入发现页面
        self.selectedIndex = 3;
    }
    self.tabBar.tintColor = [UIColor orangeColor];

    //注册登录成功通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccesss) name:kLoginSuccess object:nil];
}

- (void)loginSuccesss {
    //登录成功，切换主控制器的选择
    self.selectedIndex = 0;
}

- (void)logoutJumpToFindVC
{
    //退出时切换到FindVC
    self.selectedIndex = 3;
    //再跳转到登录界面
    UIViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"loginNavigationID"];
    [self presentViewController:VC animated:YES completion:nil];
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
