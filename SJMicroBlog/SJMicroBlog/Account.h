//
//  Account.h
//  SJMicroBlog
//
//  Created by qingyun on 15/12/25.
//  Copyright © 2015年 iGhibli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Account : NSObject

//
+ (instancetype)currentAccount;

- (void)saveLogin:(NSDictionary *)info;

- (BOOL)isLogin;

//退出登录，清除登录信息。
- (void)logout;

@end
