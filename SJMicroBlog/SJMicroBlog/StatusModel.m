//
//  StatusModel.m
//  SJMicroBlog
//
//  Created by qingyun on 15/12/27.
//  Copyright © 2015年 iGhibli. All rights reserved.
//

#import "StatusModel.h"
#import "UserModel.h"
#import "Common.h"

@implementation StatusModel

- (instancetype)initStatusWithDictionary:(NSDictionary *)info {
    if (self = [super init]) {
        //处理微博创建时间信息
        //创建格式化对象
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        //设置时间格式字符串
        NSString *dateFormatterString = @"EEE MMM dd HH:mm:ss zzz yyyy";
        formatter.dateFormat = dateFormatterString;
        //设置时区信息
        NSLocale *local = [NSLocale currentLocale];
        formatter.locale = local;
        //将计算出的时间格式的时间数据赋值给Created_at
        self.created_at = [formatter dateFromString:info[kStatusCreateTime]];
        //从字典中取出对应数据并赋值
        self.statusID = info[kStatusID];
        self.text = info[kStatusText];
        self.source = [self sourceWithString:info[kStatusSource]];
        NSDictionary *userInfo = info[kStatusUserInfo];
        self.user = [[UserModel alloc] initUserModelWithDictionary:userInfo];
        NSDictionary *retweetedInfo = info[kStatusRetweetStatus];
        //判断转发内容信息是否存在
        if (retweetedInfo) {
            self.retweeted_status = [[StatusModel alloc]initStatusWithDictionary:retweetedInfo];
            
        }
    }
    return self;
}


/**
 *  处理TimeAgo，按格式显示时间数据。使时间显示能动态的计算出已过时间长短。
 *
 *  @return 按指定格式输出的时间
 */
- (NSString *)timeAgo {
    //计算当前时间和创建时间的差值，单位为秒s。
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:self.created_at];
    if (interval < 60) {
        return @"刚刚";
    }else if (interval < 60 * 60) {
        return [NSString stringWithFormat:@"%ld 分钟前", (NSInteger)interval / 60];
    }else if (interval < 60 * 60 *24) {
        return [NSString stringWithFormat:@"%ld 小时前", (NSInteger)interval / (60 * 60)];
    }else if (interval < 60 * 60 * 24 * 30) {
        return [NSString stringWithFormat:@"%ld 天前", (NSInteger)interval / (60 * 60 * 24)];
    }else {
        return [NSDateFormatter localizedStringFromDate:self.created_at dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle];
    }
}

/**
 *  从Source字符串中取出有用的字符串信息
 *
 *  @param str 未处理的源Source
 *
 *  @return 处理过后的有用信息
 */
- (NSString *)sourceWithString:(NSString *)str {
    //排除无效的字符串
    if ([str isKindOfClass:[NSNull class]] || [str isEqualToString:@""] || !str) {
        return nil;
    }
    //创建正则表达式条件
    NSString *patternStr = @">.*<";
    NSError *error;
    //初始化正则表达式对象
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:patternStr options:0 error:&error];
    //用正则表达式查找字符串中满足条件的结果
    NSTextCheckingResult *result = [expression firstMatchInString:str options:0 range:NSMakeRange(0, str.length)];
    if (result) {
        //根据结果取出满足条件的字符串
        NSRange range = result.range;
        NSString *source = [str substringWithRange:NSMakeRange(range.location + 1, range.length - 2)];
        return [@"来自" stringByAppendingString:source];
    }
    return nil;
}


@end
