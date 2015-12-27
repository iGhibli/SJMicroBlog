//
//  UserModel.m
//  SJMicroBlog
//
//  Created by qingyun on 15/12/27.
//  Copyright © 2015年 iGhibli. All rights reserved.
//

#import "UserModel.h"
#import "Common.h"

@implementation UserModel

- (instancetype)initUserModelWithDictionary:(NSDictionary *)info {
    if (self = [super init]) {
        self.userModelID = [NSString stringWithFormat:@"%ld",(long int)info[kUserID]];
        self.name = info[kUserInfoName];
        self.userDescription = info[kUserDescription];
        self.profile_image_url = info[kUserProfileImageURL];
        self.avatar_large = info[kUserAvatarLarge];
        self.verified_reason = info[kUserVerifiedReson];
    }
    return self;
}

@end
