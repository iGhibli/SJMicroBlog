//
//  Common.h
//  SJMicroBlog
//
//  Created by qingyun on 15/12/25.
//  Copyright © 2015年 iGhibli. All rights reserved.
//

#ifndef Common_h
#define Common_h

/**
 *  Size
 *  常用的关于尺寸大小的宏定义
 */
#define kScreenB    [UIScreen mainScreen].bounds
#define kScreenH    [UIScreen mainScreen].bounds.size.height
#define kScreenW    [UIScreen mainScreen].bounds.size.width

/**
 *  URL
 *  要用到的一些URL地址字符串
 */
#define kBaseURL    @"https://api.weibo.com/2"
//回调地址URL
#define KRedirectURL    @"https://api.weibo.com/oauth2/default.html"

/**
 *  StatusModel Property
 *  解析微博所使用的关键字常量，也就是新浪服务器返回的数据由JSONKit解析后生成的字典关于微博信息的key值
 */
static NSString * const kStatusCreateTime = @"created_at";
static NSString * const kStatusID = @"id";
static NSString * const kStatusMID = @"mid";
static NSString * const kStatusText = @"text";
static NSString * const kStatusSource = @"source";
static NSString * const kStatusThumbnailPic = @"thumbnail_pic";
static NSString * const kStatusOriginalPic = @"original_pic";
static NSString * const kStatusPicUrls = @"pic_urls";
static NSString * const kStatusRetweetStatus = @"retweeted_status";
static NSString * const kStatusUserInfo = @"user";
static NSString * const kStatusRetweetStatusID = @"retweeted_status_id";
static NSString * const kStatusRepostsCount = @"reposts_count";
static NSString * const kStatusCommentsCount = @"comments_count";
static NSString * const kStatusAttitudesCount = @"attitudes_count";
static NSString * const kstatusFavorited = @"favorited";

/**
 *  UserModel Property
 *  解析微博用户数据所使用的关键字常量，也就是新浪服务器返回的数据由JSONKit解后生成的字典关于用户信息的Key值。
 */
static NSString * const kUserInfoScreenName = @"screen_name";
static NSString * const kUserInfoName = @"name";
static NSString * const kUserAvatarLarge = @"avatar_large";
static NSString * const kUserAvatarHd = @"avatar_hd";
static NSString * const kUserID = @"id";
static NSString * const kUserDescription = @"description";
static NSString * const kUserVerifiedReson = @"verified_reason";
static NSString * const kUserFollowersCount = @"followers_count";
static NSString * const kUserStatusCount = @"statuses_count";
static NSString * const kUserFriendCount = @"friends_count";
static NSString * const kUserStatusInfo = @"status";
static NSString * const kUserStatuses = @"statuses";
static NSString * const kUserProfileImageURL = @"profile_image_url";

/**
 *  Others
 */

//Author认证相关
#define kAppKey         @"3440529744"
#define kAppSecret      @"24bf8faff1ffea41b6c56f5d7fb02f4c"

#define kAppVersion     @"kAppversion"

#define access_token    @"access_token"
#define expires_in      @"expires_in"
#define userID          @"uid"

#define kAccountFileName    @"AccountFile"
#define kLoginSuccess       @"LoginSuccess"

#endif /* Common_h */
