//
//  StatusModel.h
//  SJMicroBlog
//
//  Created by qingyun on 15/12/27.
//  Copyright © 2015年 iGhibli. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserModel;
@interface StatusModel : NSObject

@property (nonatomic, strong) NSDate *created_at;//created_at	string	微博创建时间
@property (nonatomic, strong) NSString *statusID;//id	int64	微博ID
@property (nonatomic, strong) NSString *text;//text	string	微博信息内容
@property (nonatomic, strong) NSString *source;//source	string	微博来源
//geo	object	地理信息字段 详细
@property (nonatomic, strong) UserModel *user;//user	object	微博作者的用户信息字段 详细
@property (nonatomic, strong) StatusModel *retweeted_status;//retweeted_status	object	被转发的原微博信息字段，当该微博为转发微博时返回 详细
@property (nonatomic, strong) NSString *timeAgo;

- (instancetype)initStatusWithDictionary:(NSDictionary *)info;

@end
