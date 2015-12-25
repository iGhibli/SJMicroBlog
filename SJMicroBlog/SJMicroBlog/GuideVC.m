//
//  GuideVC.m
//  SJMicroBlog
//
//  Created by qingyun on 15/12/25.
//  Copyright © 2015年 iGhibli. All rights reserved.
//

#import "GuideVC.h"
#import "Common.h"

@interface GuideVC ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *guideScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

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

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
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
