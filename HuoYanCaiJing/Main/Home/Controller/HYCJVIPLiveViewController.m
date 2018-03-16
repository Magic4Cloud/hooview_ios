//
//  HYCJVIPLiveViewController.m
//  HuoYanCaiJing
//
//  Created by ZPF Mac Pro on 2018/1/15.
//  Copyright © 2018年 shilei. All rights reserved.
//

#import "HYCJVIPLiveViewController.h"
#import "HYCJVIPLiveTableViewCell.h"
#import "HYCJBuyViewController.h"
#import "HYCJHomeLiveListModel.h"
#import "HYCJNoDataTableViewCell.h"
#import "HYCJLoginViewController.h"
#import "HYCJHomeLiveDetailViewController.h"

static NSString *identify = @"cell";
@interface HYCJVIPLiveViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSInteger page;
}
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSMutableArray *dataArray;

@end

@implementation HYCJVIPLiveViewController
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"VIP直播";
    page = 1;
    UIButton *backmainButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 52/3, 52/3)];
    [backmainButton setImage:[UIImage imageNamed:@"return_white"] forState:UIControlStateNormal];
    [backmainButton addTarget:self action:@selector(backmain) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backmainItem = [[UIBarButtonItem alloc] initWithCustomView:backmainButton];
    [self.navigationItem setLeftBarButtonItem:backmainItem];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = RGB(241, 241, 241, 1.0);
    [self.tableView registerNib:[UINib nibWithNibName:@"HYCJVIPLiveTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:identify];
    [self.tableView registerClass:[HYCJNoDataTableViewCell class] forCellReuseIdentifier:NSStringFromClass([HYCJNoDataTableViewCell class])];
    
    [self.view addSubview:self.tableView];
    [self loadLiveListData];
}
- (void)backmain{
    [self dismissViewControllerAnimated:NO completion:nil];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray ? (_dataArray.count == 0 ? 1 : _dataArray.count) : 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_dataArray.count == 0) {
        return HEIGHT;
    }
    return 285;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HYCJHomeLiveListModel *model = _dataArray ? (_dataArray.count == 0 ? nil : _dataArray[indexPath.section]) : nil;
    if (model) {
        HYCJVIPLiveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell) {
            cell = [[HYCJVIPLiveTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identify];
        }
        cell.lookButton.layer.borderColor = RGB(234, 72, 96, 1).CGColor;
        cell.lookButton.layer.borderWidth = 0.5;
        cell.lookButton.layer.cornerRadius = 14;
        cell.bgImg.clipsToBounds = YES;
        [cell.lookButton addTarget:self action:@selector(lookButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        if (self.dataArray.count > 0) {
//            HYCJHomeLiveListModel *model = self.dataArray[indexPath.section];
            [cell.bgImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.logourl]] placeholderImage:PlaceholderImageView];
            cell.titleLab.text = [NSString stringWithFormat:@"%@",model.liveTitle];
            cell.locationLab.text = [NSString stringWithFormat:@"%@",model.location];
            cell.numberLab.text = [NSString stringWithFormat:@"%@ 人正在看",model.watchingCount];
            
            [cell.typeButton setTitle:[NSString stringWithFormat:@" %@ ",model.liveTypeName] forState:UIControlStateNormal];
            cell.moneyL.hidden = YES;
            cell.moneyLab.hidden = YES;
            cell.lookButton.hidden = YES;
        }
        
        return cell;
    } else{
        HYCJNoDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HYCJNoDataTableViewCell class])];
        return cell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    BOOL tokenBool = [BTToolFormatJudge iSStringNull:token];
    if (tokenBool == YES) {
        //        [SVProgressHUD setMinimumDismissTimeInterval:1];
        //        [SVProgressHUD showErrorWithStatus:@"请登录"];
        HYCJLoginViewController *HYCJ = [[HYCJLoginViewController alloc] init];
        HYCJ.hidesBottomBarWhenPushed = YES;
        [self presentViewController:HYCJ animated:NO completion:nil];
        return;
    }
    if (self.dataArray.count == 0) {
        return;
    }
    HYCJHomeLiveDetailViewController *HYCJVC = [[HYCJHomeLiveDetailViewController alloc] init];
    HYCJVC.model = self.dataArray[indexPath.section];
    
    [self presentViewController:HYCJVC animated:YES completion:^{
        
    }];
}
- (void)lookButtonAction:(UIButton *)sender{
    HYCJBuyViewController *HYCJVC = [[HYCJBuyViewController alloc] init];
    [self.navigationController pushViewController:HYCJVC animated:YES];
}

- (void)loadLiveListData{
    
    NSDictionary *dic;
    dic = @{@"liveTypeId":@"",@"recommend":@"0",@"liveVip":@"1",@"keyword":@"",@"page":@(page),@"limit":@"10"};
    [SVProgressHUD show];
    [XZFHttpManager GET:LiveListUrl parameters:dic requestSerializer:NO requestToken:NO success:^(id respondseObject) {
        NSLog(@"--------直播列表--------%@",respondseObject);
        if (page == 1) {
            [self.dataArray removeAllObjects];
        }
        NSArray *arr = respondseObject[@"liveList"][@"list"];
        if (arr.count == 0) {
            
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
        
        [self.dataArray addObjectsFromArray:[HYCJHomeLiveListModel mj_objectArrayWithKeyValuesArray:respondseObject[@"liveList"][@"list"]]];
        
        
        [self.tableView reloadData];
        [SVProgressHUD dismiss];
        
    } failure:^(NSError *error) {
        
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
