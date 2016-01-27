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
#import "StatusModel.h"
#import "UserModel.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"

@implementation HomeCell

//初始化代码
- (void)awakeFromNib {
    //label 预计显示的最大宽度
    self.content.preferredMaxLayoutWidth = kScreenW - 20;
    self.reContent.preferredMaxLayoutWidth = self.content.preferredMaxLayoutWidth;
}

- (void)bandingCellContentWithStatusModel:(StatusModel *)model {
#if 0
    //存在头像图片不对应的Bug，启用这种方式。
    //GCD异步加载头像图片
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
   
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:model.user.profile_image_url]];
        self.icon.image = [UIImage imageWithData:data];
        
    });
#endif
    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.user.profile_image_url]];
    
    //将头像图片剪成圆形，clipsToBounds、masksToBounds都可以实现。
    self.icon.layer.cornerRadius = 25;
    self.icon.clipsToBounds = YES;
//    self.icon.layer.masksToBounds = YES;
    
    self.name.text = model.user.name;
    self.time.text = model.timeAgo;
    self.content.text = model.text;
    self.source.text = model.source;
    //设置转发视图显示
    StatusModel *reTwitter = model.retweeted_status;
    self.reContent.text = reTwitter.text;
    [self layoutImages:reTwitter.pic_urls andHeight:self.reImageSupHeight forView:self.reImageSup];
    if (reTwitter) {
        //有转发微博的时候
        [self layoutImages:nil andHeight:self.imageSupHeight forView:self.imageSup];
    }else {
        //没有转发微博时
        [self layoutImages:model.pic_urls andHeight:self.imageSupHeight forView:self.imageSup];
    }
    
}

- (void)layoutImages:(NSArray *)images andHeight:(NSLayoutConstraint *)constraint forView:(UIView *)view
{
    //移走子视图
    NSArray *subViews = view.subviews;
    [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    //根据图片显示需要的高度设定View高度上的约束
    CGFloat height = [self imageSuperViewHeightWithCount:images.count];
    constraint.constant = height;
    [images enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //images中的元素obj是字典
        NSString *imageURL = [obj objectForKey:@"thumbnail_pic"];
        //初始化UIButton
        UIButton *imageBtn = [[UIButton alloc]initWithFrame:CGRectMake((idx % 3 * (90 + 5)), (idx / 3 * (90 + 5)), 90, 90)];
        [imageBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:imageURL] forState:UIControlStateNormal];
        imageBtn.tag = idx;
        [view addSubview:imageBtn];
    }];
}

- (CGFloat)imageSuperViewHeightWithCount:(NSInteger)count
{
    //0张时返回0
    if (count <= 0) {
        return 0;
    }
    //显示需要的行数(ceil取整)
    NSInteger line = ceil(count / 3.f);
    //计算显示需要的高度
    CGFloat height = line * 90 + (line - 1) * 5;
    return height;
}

+ (CGFloat)homeCellHeightWithStatusModel:(StatusModel *)model {
    //计算文字显示需要的高度
    NSString *text = model.text;
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:17] AndWidth:kScreenW - 20];
    return size.height + 80 + 1 + 1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
