//
//  GuideVC.m
//  SJMicroBlog
//
//  Created by qingyun on 15/12/25.
//  Copyright © 2015年 iGhibli. All rights reserved.
//

#import "GuideVC.h"
#import "Common.h"

@interface GuideVC ()
@property (weak, nonatomic) IBOutlet UIScrollView *guideScrollView;

@end

@implementation GuideVC

- (void)viewDidLoad {
    self.guideScrollView.contentSize = CGSizeMake(kScreenW * 4, kScreenH);
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
