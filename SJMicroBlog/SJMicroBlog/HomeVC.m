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

@interface HomeVC ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *StatusArray;  //网络请求的数据

@end

@implementation HomeVC

- (void)awakeFromNib {
    //从故事版初始化后都会走的方法
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self loadDatas];
    
    //使用MJRefresh的下拉刷新控件
    // 设置自动切换透明度
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
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
            [tempArray addObjectsFromArray:self.StatusArray];
            self.StatusArray = tempArray;
            //刷新TableView
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            
#warning 显示更新数据数
            //将网络请求数据保存到SQLite3数据库
            [DataBaseEngine saveStatus:result];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"!!!!!!%@",error);
        }];
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
    [params setValue:@100 forKey:@"count"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:URLString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
//        NSLog(@">>>>%@",responseObject);
        NSArray *result = responseObject[@"statuses"];
        NSLog(@"%@",result);
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

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.StatusArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"homeCell" forIndexPath:indexPath];
    [cell bandingCellContentWithStatusModel:self.StatusArray[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    StatusModel *model = self.StatusArray[indexPath.row];
    return [HomeCell homeCellHeightWithStatusModel:model];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
