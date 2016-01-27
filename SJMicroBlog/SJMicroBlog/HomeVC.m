//
//  HomeVC.m
//  SJMicroBlog
//
//  Created by qingyun on 15/12/26.
//  Copyright © 2015年 iGhibli. All rights reserved.
//

#import "HomeVC.h"
#import "Common.h"
#import "Account.h"
#import "AFNetworking.h"
#import "HomeCell.h"
#import "StatusModel.h"
#import "UserModel.h"
#import "DataBaseEngine.h"
#import "MJRefresh.h"
#import "FooterView.h"

@interface HomeVC ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *StatusArray;  //网络请求的数据
@property (nonatomic, assign) BOOL isRefreshing;
@end

@implementation HomeVC

- (void)awakeFromNib {
    //从故事版初始化后都会走的方法
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"FooterView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"FooterView"];
    [self loadDatas];
    //添加下拉刷新控件
    [self addMJRefresh];
}

- (void)addMJRefresh
{
    //使用MJRefresh的下拉刷新控件
    // 设置自动切换透明度
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadNewData];
    }];
}

#pragma mark - Geeter & Setter
- (NSMutableArray *)StatusArray {
    if (_StatusArray == nil) {
        _StatusArray = [NSMutableArray array];
    }
    return _StatusArray;
}

#pragma mark - CustomMethod
- (void)loadDatas
{
    NSString *URLString = [kBaseURL stringByAppendingPathComponent:@"statuses/home_timeline.json"];
    NSDictionary *params = [[Account currentAccount] requestToken];
    if (!params) {
        return;
    }
    [params setValue:@10 forKey:@"count"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:URLString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
//        NSLog(@">>>>%@",responseObject);
        NSArray *result = responseObject[@"statuses"];
//        NSLog(@"%@",result);
        //
        [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            StatusModel *model = [[StatusModel alloc]initStatusWithDictionary:obj];
            [self.StatusArray addObject:model];
        }];

        //刷新TableView
        [self.tableView reloadData];
        
        //将网络请求数据保存到SQLite3数据库
        [DataBaseEngine saveStatus:result];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"!!!!!!%@",error);
    }];
    
}

- (void)loadNewData
{
    NSString *URLString = [kBaseURL stringByAppendingPathComponent:@"statuses/home_timeline.json"];
    NSDictionary *params = [[Account currentAccount] requestToken];
    if (!params) {
        return;
    }
    [params setValue:[self.StatusArray.firstObject statusID] forKey:@"since_id"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:URLString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *result = responseObject[@"statuses"];
        //
        NSMutableArray *tempArray = [NSMutableArray array];
        [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            StatusModel *model = [[StatusModel alloc]initStatusWithDictionary:obj];
            [tempArray addObject:model];
        }];
        int count = (int)tempArray.count;
        [tempArray addObjectsFromArray:self.StatusArray];
        self.StatusArray = tempArray;
        //刷新TableView
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        
        UILabel *popLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 64 - 30, kScreenW, 30)];
        popLabel.textAlignment = NSTextAlignmentCenter;
        popLabel.font = [UIFont systemFontOfSize:12];
        popLabel.text = [NSString stringWithFormat:@"更新了 %d 条数据",count];
        popLabel.backgroundColor = [UIColor orangeColor];
        [self.navigationController.navigationBar.superview insertSubview:popLabel belowSubview:self.navigationController.navigationBar];
        
        [UIView animateWithDuration:0.3 animations:^{
            popLabel.frame = CGRectMake(0, 64, kScreenW, 30);
        }];
        //将网络请求数据保存到SQLite3数据库
        [DataBaseEngine saveStatus:result];
        [UIView animateWithDuration:0.2 delay:1.0 options:0 animations:^{
            popLabel.frame = CGRectMake(0, 64 - 30, kScreenW, 30);
        } completion:^(BOOL finished) {
            [popLabel removeFromSuperview];
        }];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"!!!!!!%@",error);
    }];
}

- (void)loadMoreData
{
    if (self.isRefreshing) {
        return;
    }
    self.isRefreshing = YES;
    NSString *URLString = [kBaseURL stringByAppendingPathComponent:@"statuses/home_timeline.json"];
    NSDictionary *params = [[Account currentAccount] requestToken];
    if (!params) {
        return;
    }
    [params setValue:[self.StatusArray.lastObject statusID] forKey:@"max_id"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:URLString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *result = responseObject[@"statuses"];
        //
        [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            StatusModel *model = [[StatusModel alloc]initStatusWithDictionary:obj];
            [self.StatusArray addObject:model];
        }];
        //刷新TableView
        [self.tableView reloadData];
        
        //将网络请求数据保存到SQLite3数据库
        [DataBaseEngine saveStatus:result];
        self.isRefreshing = NO;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"!!!!!!%@",error);
        self.isRefreshing = NO;
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.StatusArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"homeCell" forIndexPath:indexPath];
    [cell bandingCellContentWithStatusModel:self.StatusArray[indexPath.section]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"homeCell"];
    [cell bandingCellContentWithStatusModel:self.StatusArray[indexPath.section]];
    return [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    FooterView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"FooterView"];
    [footer bandingStatusModel:self.StatusArray[section]];
    return footer;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == self.StatusArray.count - 3) {
        [self loadMoreData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
