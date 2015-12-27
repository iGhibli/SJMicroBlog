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

@interface HomeVC ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *StatusArray;  //网络请求的数据

@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self loadDatas];
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
#if 1
        [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            StatusModel *model = [[StatusModel alloc]initStatusWithDictionary:obj];
            [self.StatusArray addObject:model];
        }];
#else
        for (NSDictionary *dict in result) {
            StatusModel *model = [[StatusModel alloc]initStatusWithDictionary:dict];
            [self.StatusArray addObject:model];
        }
#endif
        //刷新TableView
        [self.tableView reloadData];
        
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
