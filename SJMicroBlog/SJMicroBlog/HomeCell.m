//
//  HomeCell.m
//  SJMicroBlog
//
//  Created by qingyun on 15/12/26.
//  Copyright © 2015年 iGhibli. All rights reserved.
//

#import "HomeCell.h"



@implementation HomeCell


- (void)bandingCellContentWithInfo:(NSDictionary *)info {
    NSDictionary *content = info[@"user"];
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:content[@"profile_image_url"]]];
    self.icon.image = [UIImage imageWithData:data];
    self.name.text = content[@"name"];
    self.time.text = content[@"created_at"];
    self.content.text = info[@"text"];
    self.source.text = info[@"source"];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
