//
//  LoginVC.m
//  SJMicroBlog
//
//  Created by qingyun on 15/12/25.
//  Copyright © 2015年 iGhibli. All rights reserved.
//

#import "LoginVC.h"
#import "Common.h"
#import "AFNetworking.h"
#import "Account.h"

@interface LoginVC ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.delegate = self;
    NSString *URLString = [NSString stringWithFormat:@"https://api.weibo.com/oauth2/authorize?client_id=%@&redirect_uri=%@&response_type=code",kAppKey ,KRedirectURL];
//    NSLog(@"%@",URLString);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    [self.webView loadRequest:request];
}
- (IBAction)cancelAction:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //
    NSURL *loadURL = request.URL;
    NSString *URLString = [loadURL absoluteString];
    //
    if ([URLString hasPrefix:KRedirectURL]) {
        NSArray *subURLString = [URLString componentsSeparatedByString:@"code="];
        NSString *code = subURLString.lastObject;
        //
        NSString *requestURLString = @"https://api.weibo.com/oauth2/access_token";
        //
        NSDictionary *params = @{@"client_id":kAppKey,
                                 @"client_secret":kAppSecret,
                                 @"grant_type":@"authorization_code",
                                 @"code":code,
                                 @"redirect_uri":KRedirectURL
                                 };
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
        [manager POST:requestURLString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //查看网络请求结果
            NSLog(@"%@",responseObject);
            //保存网络请求结果数据
            [[Account currentAccount] saveLogin:responseObject];
            //模态消失当前登录界面
            [self dismissViewControllerAnimated:YES completion:nil];
            //登录完成通过注册好的通知跳转到首页
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccess object:nil];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"!!!!!!%@",error);
        }];
    }
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
