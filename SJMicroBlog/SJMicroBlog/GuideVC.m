//
//  GuideVC.m
//  SJMicroBlog
//
//  Created by qingyun on 15/12/25.
//  Copyright © 2015年 iGhibli. All rights reserved.
//

#import "GuideVC.h"
#import "Common.h"
#import "AppDelegate.h"

@interface GuideVC ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *guideScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIButton *guideEndBtnAction;

@end

@implementation GuideVC

- (void)viewDidLoad {
    self.guideScrollView.contentSize = CGSizeMake(kScreenW * 4, kScreenH);
    self.guideScrollView.delegate = self;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)pageControlAction:(UIPageControl *)sender {
    self.guideScrollView.contentOffset = CGPointMake(kScreenW * self.pageControl.currentPage, 0);
}
- (IBAction)guideEndBtnAction:(UIButton *)sender {
    
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    [app guideEnd];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //有可能ScrollView没有减速效果就停止了
    if (!decelerate) {
        //未减速结束
        self.pageControl.currentPage = scrollView.contentOffset.x / kScreenW;
    }else {
        //减速结束
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //此处单独使用有漏洞，可能ScrollView没有减速效果
    self.pageControl.currentPage = scrollView.contentOffset.x / kScreenW;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
