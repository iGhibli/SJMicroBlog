//
//  HomeCell.m
//  SJMicroBlog
//
//  Created by qingyun on 15/12/26.
//  Copyright © 2015年 iGhibli. All rights reserved.
//

#import "HomeCell.h"
#import "NSString+Size.h"
#import "Common.h"

@implementation HomeCell


- (void)bandingCellContentWithInfo:(NSDictionary *)info {
    NSDictionary *content = info[@"user"];
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:content[@"profile_image_url"]]];
    self.icon.image = [UIImage imageWithData:data];
    
    //将头像图片剪成圆形，clipsToBounds、masksToBounds都可以实现。
    self.icon.layer.cornerRadius = 25;
    self.icon.clipsToBounds = YES;
//    self.icon.layer.masksToBounds = YES;
    
    self.name.text = content[@"name"];
    self.time.text = content[@"created_at"];
    self.content.text = info[@"text"];
    self.source.text = info[@"source"];
}

+ (CGFloat)heightWithHomeCellText:(NSDictionary *)info {
    //计算文字显示需要的高度
    NSString *text = info[@"text"];
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:17] AndWidth:kScreenW - 20];
    return size.height + 80 + 1 + 1;
}

- (void)awakeFromNib {
    // Initialization code
    //label 预计显示的最大宽度
    self.content.preferredMaxLayoutWidth = kScreenW - 20;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
