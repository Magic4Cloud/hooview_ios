//
//  HYCJMyMessageViewController.m
//  HuoYanCaiJing
//
//  Created by ZPF Mac Pro on 2018/1/13.
//  Copyright © 2018年 shilei. All rights reserved.
//

#import "HYCJMyMessageViewController.h"
#import "HYCJMyMessageTableViewCell.h"
#import "HYCJMyMessageModel.h"
#import "HYCJNoDataTableViewCell.h"
#import "HYCJCriticalDetailViewController.h"
#import "HYCJHomeLiveDetailViewController.h"
#import "HYCJHomeLiveListModel.h"

static NSString *identify = @"cell";

@interface HYCJMyMessageViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSInteger page;
}
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSMutableArray *dataArray;
@property (strong,nonatomic) NSMutableArray *msgIdArr;

@end

@implementation HYCJMyMessageViewController
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (NSMutableArray *)msgIdArr{
    if (!_msgIdArr) {
        _msgIdArr = [NSMutableArray array];
    }
    return _msgIdArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的消息";
    page = 1;
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
    [self.tableView registerNib:[UINib nibWithNibName:@"HYCJMyMessageTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:identify];
    [self.tableView registerClass:[HYCJNoDataTableViewCell class] forCellReuseIdentifier:NSStringFromClass([HYCJNoDataTableViewCell class])];

    __weak typeof(self)weaskself = self;
    _tableView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        page = 1;
        [weaskself loadMessageListData];
    }];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page++;
        [weaskself loadMessageListData];
    }];
    [self.view addSubview:self.tableView];
    
    [self loadMessageListData];
}
- (void)deleteButtonAction:(UIButton *)sender{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"你将删除消息" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [SVProgressHUD show];
        NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
        
        [XZFHttpManager POST:UserDeleteMsgUrl parameters:@{@"toUserId":userId} requestSerializer:NO requestToken:YES success:^(id respondseObject) {
            
            NSLog(@"----删除消息-----%@",respondseObject);
            page = 1;
            [self loadMessageListData];
            
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
    return 170;
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
    
    HYCJMyMessageModel *model = _dataArray ? (_dataArray.count == 0 ? nil : _dataArray[indexPath.row]) : nil;
    if (model) {
        
        HYCJMyMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell) {
            cell = [[HYCJMyMessageTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identify];
        }
        if (self.dataArray.count > 0) {
//            HYCJMyMessageModel *model = self.dataArray[indexPath.row];
            cell.nameLab.text = [NSString stringWithFormat:@"%@",model.nickName];
            cell.titleLab.text = [NSString stringWithFormat:@"%@",model.msgContent];
            cell.timeLab.text = [NSString stringWithFormat:@"%@",model.createTime];
            cell.contentLab.text = [NSString stringWithFormat:@"%@",model.title];
            NSString *typeStr = [NSString stringWithFormat:@"%@",model.sourceType];//浏览类型（0-直播，1-资讯，2-评论）
            if ([typeStr isEqualToString:@"0"]) {
                cell.typeButton.hidden = NO;
                cell.liveView.hidden = NO;
                cell.numberLab.hidden = NO;
                [cell.typeButton setTitle:[NSString stringWithFormat:@" %@ ",model.liveTypeName] forState:UIControlStateNormal];
                NSString *liveStatusStr = [NSString stringWithFormat:@"%@",model.liveStatus];
                if ([liveStatusStr isEqualToString:@"0"]) {
                    cell.liveView.backgroundColor = RGB(234, 72, 96, 1);
                    cell.numberLab.text = @"直播已结束";
                }else{
                    cell.liveView.backgroundColor = RGB(67, 255, 0, 1);
                    cell.numberLab.text = [NSString stringWithFormat:@"%@ 人正在看",model.watchCount];
                }
                
                
            }else{
                cell.typeButton.hidden = YES;
                cell.liveView.hidden = YES;
                cell.numberLab.hidden = YES;
            }
            
        }
        
        return cell;
    }
    else{
        HYCJNoDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HYCJNoDataTableViewCell class])];
        return cell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArray.count > 0) {
        HYCJMyMessageModel *model = _dataArray[indexPath.row];
        NSString *sourceTypeStr = [NSString stringWithFormat:@"%@",model.sourceType];
        if ([sourceTypeStr isEqualToString:@"0"]) {
            
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
            
        }else if ([sourceTypeStr isEqualToString:@"1"]){
            HYCJCriticalDetailViewController *HYCJVC = [[HYCJCriticalDetailViewController alloc] init];
            HYCJVC.financeInfoId = [NSString stringWithFormat:@"%@",model.sourceId];
            XZFNavigationController *nav=[[XZFNavigationController alloc]initWithRootViewController:HYCJVC];
            [self presentViewController :nav animated:NO completion:nil];
        }
    }
}
- (void)loadMessageListData{
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    
    [XZFHttpManager GET:UserMyMsgUrl parameters:@{@"page":@(page),@"limit":@(10),@"userId":userId} requestSerializer:NO requestToken:YES success:^(id respondseObject) {
        NSLog(@"--------我的消息--------%@",respondseObject);
        if (page == 1) {
            [self.dataArray removeAllObjects];
        }
        NSArray *arr = respondseObject[@"messageList"][@"list"];
        if (arr.count == 0) {
            
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
        NSMutableArray *dataArr = [NSMutableArray array];
        
        for (int i = 0; i < arr.count; i ++) {
            NSString *sourceTypeStr = [NSString stringWithFormat:@"%@",arr[i][@"sourceType"]];
            NSString *msgIdStr = [NSString stringWithFormat:@"%@",arr[i][@"msgId"]];

            [self.msgIdArr addObject:msgIdStr];
            
            if (![sourceTypeStr isEqualToString:@"2"]) {
                [dataArr addObject:arr[i]];
            }
        }
        
        NSArray *messageArr = dataArr;
        
        [self.dataArray addObjectsFromArray:[HYCJMyMessageModel mj_objectArrayWithKeyValuesArray:messageArr]];
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];

}
- (void)loadData{
  
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
