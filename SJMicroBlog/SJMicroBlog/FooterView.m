//
//  FooterView.m
//  SJMicroBlog
//
//  Created by qingyun on 16/1/27.
//  Copyright © 2016年 iGhibli. All rights reserved.
//

#import "FooterView.h"
#import "StatusModel.h"

@implementation FooterView

- (void)awakeFromNib {
    self.backgroundView = [[UIView alloc]init];
    self.backgroundView.backgroundColor = [UIColor whiteColor];
}

- (void)bandingStatusModel:(StatusModel *)model
{
    [self.reCount setTitle:[model.reposts_count stringValue] forState:UIControlStateNormal];
    [self.commentCount setTitle:[model.comments_count stringValue] forState:UIControlStateNormal];
    [self.likeCount setTitle:[model.attitudes_count stringValue] forState:UIControlStateNormal];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
