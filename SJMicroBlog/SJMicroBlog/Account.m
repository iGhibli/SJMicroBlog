//
//  Account.m
//  SJMicroBlog
//
//  Created by qingyun on 15/12/25.
//  Copyright © 2015年 iGhibli. All rights reserved.
//

#import "Account.h"
#import "Common.h"
#import "NSString+FilePath.h"

@interface Account ()<NSCoding>

@property (nonatomic, strong) NSString *accessToken;    //author认证
@property (nonatomic, strong) NSDate *expires;          //有效期
@property (nonatomic, strong) NSString *UID;            //用户ID

@end

@implementation Account

+ (instancetype)currentAccount {
    static Account *account;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        //
        NSString *filePath = [NSString filePathInDocumentsWithFileName:kAccountFileName];
        //
        account = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        //
        if (account == nil) {
            account = [[Account alloc]init];
        }
    });
    return account;
}

- (void)saveLogin:(NSDictionary *)info {
    self.accessToken = info[access_token];
    NSNumber *expires = info[expires_in];
    //
    self.expires = [[NSDate date]dateByAddingTimeInterval:expires.integerValue];
    self.UID = info[userID];
    
    //
    [NSKeyedArchiver archiveRootObject:self toFile:[NSString filePathInDocumentsWithFileName:kAccountFileName]];
}

- (BOOL)isLogin {
    //
    if (self.accessToken && [[NSDate date]compare:self.expires] < 0) {
        return YES;
    }
    return NO;
}

#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    //
    [aCoder encodeObject:self.accessToken forKey:access_token];
    [aCoder encodeObject:self.expires forKey:expires_in];
    [aCoder encodeObject:self.UID forKey:userID];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    //
    if (self = [super init]) {
        //
        self.accessToken = [aDecoder decodeObjectForKey:access_token];
        self.expires = [aDecoder decodeObjectForKey:expires_in];
        self.UID = [aDecoder decodeObjectForKey:userID];
    }
    return self;
}

@end
