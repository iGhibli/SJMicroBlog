//
//  FooterView.h
//  SJMicroBlog
//
//  Created by qingyun on 16/1/27.
//  Copyright © 2016年 iGhibli. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StatusModel;
@interface FooterView : UITableViewHeaderFooterView
@property (weak, nonatomic) IBOutlet UIButton *reCount;
@property (weak, nonatomic) IBOutlet UIButton *commentCount;
@property (weak, nonatomic) IBOutlet UIButton *likeCount;

- (void)bandingStatusModel:(StatusModel *)model;

@end
