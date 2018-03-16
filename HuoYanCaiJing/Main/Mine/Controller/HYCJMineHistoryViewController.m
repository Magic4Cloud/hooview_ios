//
//  HYCJMineHistoryViewController.m
//  HuoYanCaiJing
//
//  Created by ZPF Mac Pro on 2018/1/13.
//  Copyright © 2018年 shilei. All rights reserved.
//

#import "HYCJMineHistoryViewController.h"
#import "HYCJMineHistoryTableViewCell.h"
#import "HYCJMineHistoryModel.h"
#import "HYCJNoDataTableViewCell.h"
#import "HYCJCriticalDetailViewController.h"
#import "HYCJHomeLiveListModel.h"
#import "HYCJHomeLiveDetailViewController.h"

static NSString *identify = @"cell";

@interface HYCJMineHistoryViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSInteger page;
}
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSMutableArray *dataArray;

@end

@implementation HYCJMineHistoryViewController
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    page = 1;
    self.title = @"历史记录";
    [self setupNavigationBar];
    UIButton *deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH- 10 - 30, 0, 40, 30)];
    [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(deleteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backmainItem = [[UIBarButtonItem alloc] initWithCustomView:deleteButton];
    [self.navigationItem setRightBarButtonItem:backmainItem];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = RGB(241, 241, 241, 1.0);
    [self.tableView registerNib:[UINib nibWithNibName:@"HYCJMineHistoryTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:identify];
    [self.tableView registerClass:[HYCJNoDataTableViewCell class] forCellReuseIdentifier:NSStringFromClass([HYCJNoDataTableViewCell class])];
    __weak typeof(self)weaskself = self;
    _tableView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        page = 1;
        [weaskself loadHistoryData];
    }];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page++;
        [weaskself loadHistoryData];
    }];
    
    [self.view addSubview:self.tableView];
    
    [self loadHistoryData];
}
- (void)deleteButtonAction:(UIButton *)sender{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"你将删除历史记录" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [SVProgressHUD show];
        NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
        
        [XZFHttpManager POST:UserDeleteHistoryUrl parameters:@{@"userId":userId} requestSerializer:NO requestToken:YES success:^(id respondseObject) {
            
            NSLog(@"----删除历史记录-----%@",respondseObject);
            
            page = 1;
            [self loadHistoryData];
            
            [SVProgressHUD dismiss];
        } failure:^(NSError *error) {
            
        }];
        
        
    }];
    UIAlertAction *backAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];
    [alertController addAction:backAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_dataArray.count == 0) {
        return HEIGHT;
    }
    return 102.5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return self.dataArray.count;
    return _dataArray ? (_dataArray.count == 0 ? 1 : _dataArray.count) : 1;

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HYCJMineHistoryModel *model = _dataArray ? (_dataArray.count == 0 ? nil : _dataArray[indexPath.row]) : nil;

    if (model) {
        HYCJMineHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell) {
            cell = [[HYCJMineHistoryTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identify];
        }
        cell.titleLab.text = [NSString stringWithFormat:@"%@",model.title];
        cell.nameLab.text = [NSString stringWithFormat:@"%@",model.nickName];
        cell.timeLab.text = [NSString stringWithFormat:@"%@",model.createTime];
        [cell.cellImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.logoUrl]] placeholderImage:PlaceholderImageView];
        
        NSString *cellType = [NSString stringWithFormat:@"%@",model.sourceType];
        if ([cellType isEqualToString:@"0"]) {
            cell.typeLab.text = [NSString stringWithFormat:@" %@ ",model.liveTypeName];
            cell.typeLab.hidden = NO;
            cell.liveView.hidden = NO;
            cell.numberLab.hidden = NO;
            
            NSString *liveStatusSre = [NSString stringWithFormat:@"%@",model.liveStatus];
            
            if ([liveStatusSre isEqualToString:@"0"]) {
                cell.liveView.backgroundColor = RGB(234, 72, 96, 1);
                cell.numberLab.text = @"直播已结束";
            }else{
                cell.liveView.backgroundColor = RGB(67, 255, 0, 1);
                cell.numberLab.text = @"20人正在看";
            }
        }else{
            cell.typeLab.hidden = YES;
            cell.liveView.hidden = YES;
            cell.numberLab.hidden = YES;
        }
        return cell;
    }
    else{
        HYCJNoDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HYCJNoDataTableViewCell class])];
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HYCJMineHistoryModel *model = _dataArray[indexPath.row];
    NSString *cellType = [NSString stringWithFormat:@"%@",model.sourceType];
    if ([cellType isEqualToString:@"1"]) {
        HYCJCriticalDetailViewController *HYCJVC = [[HYCJCriticalDetailViewController alloc] init];
        HYCJVC.financeInfoId = [NSString stringWithFormat:@"%@",model.sourceId];
        //    HYCJVC.hidesBottomBarWhenPushed = YES;
        //    [self.navigationController pushViewController:HYCJVC animated:YES];
        XZFNavigationController *nav=[[XZFNavigationController alloc]initWithRootViewController:HYCJVC];
        [self presentViewController :nav animated:NO completion:nil];
    }else if ([cellType isEqualToString:@"0"]){
        NSString *liveStatusStr = [NSString stringWithFormat:@"%@",model.liveStatus];
        if ([liveStatusStr isEqualToString:@"0"]) {
            [SVProgressHUD setMinimumDismissTimeInterval:1];
            [SVProgressHUD showErrorWithStatus:@"直播已结束"];
        }else{
            
            NSString *userId = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]];
            NSString *liveId = [NSString stringWithFormat:@"%@",model.sourceId];
            [SVProgressHUD show];
            [XZFHttpManager GET:liveInfoUrl parameters:@{@"userId":userId,@"liveId":liveId} requestSerializer:NO requestToken:NO success:^(id respondseObject) {
                NSLog(@"--------直播详情--------%@",respondseObject);
                NSDictionary *dic = respondseObject[@"liveInfo"];
                HYCJHomeLiveListModel *liveModel = [[HYCJHomeLiveListModel alloc] init];
                liveModel.watchingCount = [NSString stringWithFormat:@"%@",dic[@"watchingCount"]];
                liveModel.roomId = [NSString stringWithFormat:@"%@",dic[@"roomId"]];
                liveModel.logourl = [NSString stringWithFormat:@"%@",dic[@"logourl"]];
                liveModel.liveId = [NSString stringWithFormat:@"%@",dic[@"liveId"]];
                liveModel.liveTitle = [NSString stringWithFormat:@"%@",dic[@"liveTitle"]];
                liveModel.liveInfo = [NSString stringWithFormat:@"%@",dic[@"liveInfo"]];
                liveModel.nickname = [NSString stringWithFormat:@"%@",dic[@"nickname"]];
                liveModel.vid = [NSString stringWithFormat:@"%@",dic[@"vid"]];
                
                HYCJHomeLiveDetailViewController *HYCJVC = [[HYCJHomeLiveDetailViewController alloc] init];
                HYCJVC.model = liveModel;
                [self presentViewController:HYCJVC animated:YES completion:^{
                    [SVProgressHUD dismiss];
                }];
                
                [SVProgressHUD dismiss];
                
            } failure:^(NSError *error) {
                
            }];
            
            
        }
        
        
    }
}
- (void)loadHistoryData{
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    [SVProgressHUD show];
    [XZFHttpManager GET:UserHistoryUrl parameters:@{@"page":@(page),@"limit":@(10),@"userId":userId} requestSerializer:NO requestToken:YES success:^(id respondseObject) {
        NSLog(@"--------历史记录--------%@",respondseObject);
        if (page == 1) {
            [self.dataArray removeAllObjects];
        }
        NSArray *arr = respondseObject[@"historyList"][@"list"];
        if (arr.count == 0) {
            
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
        
        [self.dataArray addObjectsFromArray:[HYCJMineHistoryModel mj_objectArrayWithKeyValuesArray:respondseObject[@"historyList"][@"list"]]];
        
        [self.tableView reloadData];
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        
    }];
    
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
