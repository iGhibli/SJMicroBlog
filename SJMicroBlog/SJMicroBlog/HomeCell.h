//
//  HomeCell.h
//  SJMicroBlog
//
//  Created by qingyun on 15/12/26.
//  Copyright © 2015年 iGhibli. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StatusModel;
@interface HomeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *source;
@property (weak, nonatomic) IBOutlet UIView *imageSup;
@property (weak, nonatomic) IBOutlet UILabel *reContent;
@property (weak, nonatomic) IBOutlet UIView *reImageSup;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageSupHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *reImageSupHeight;

- (void)bandingCellContentWithStatusModel:(StatusModel *)model;

//
//+ (CGFloat)homeCellHeightWithStatusModel:(StatusModel *)model;

@end
