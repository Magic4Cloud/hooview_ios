//
//  HYCJMyFavoriteFinanceViewController.m
//  HuoYanCaiJing
//
//  Created by ZPF Mac Pro on 2018/2/9.
//  Copyright © 2018年 shilei. All rights reserved.
//

#import "HYCJMyFavoriteFinanceViewController.h"
#import "HYCJMyFavoriteFinanceTableViewCell.h"
#import "HYCJNoDataTableViewCell.h"
#import "HYCJMyFavoriteModel.h"
#import "HYCJCriticalDetailViewController.h"

static NSString *financeIdentify = @"financeCell";

@interface HYCJMyFavoriteFinanceViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSInteger indexType;
    NSInteger page;
}
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSMutableArray *dataArray;

@end

@implementation HYCJMyFavoriteFinanceViewController

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    indexType = 1;
    page = 1;
    self.view.backgroundColor = RGB(241, 241, 241, 1);
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, WIDTH, HEIGHT - 114 - 10) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = RGB(241, 241, 241, 1.0);
    [self.tableView registerNib:[UINib nibWithNibName:@"HYCJMyFavoriteFinanceTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:financeIdentify];
    [self.tableView registerClass:[HYCJNoDataTableViewCell class] forCellReuseIdentifier:NSStringFromClass([HYCJNoDataTableViewCell class])];
    
    __weak typeof(self)weaskself = self;
    _tableView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        page = 1;
        [weaskself loadLiveOrFinanceData];
    }];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page++;
        [weaskself loadLiveOrFinanceData];
    }];
    [self.view addSubview:self.tableView];
    [self loadLiveOrFinanceData];
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
    
    
    HYCJMyFavoriteModel *model = _dataArray ? (_dataArray.count == 0 ? nil : _dataArray[indexPath.row]) : nil;
    if (model) {
        HYCJMyFavoriteFinanceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:financeIdentify];
        if (!cell) {
            cell = [[HYCJMyFavoriteFinanceTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:financeIdentify];
        }
        if (self.dataArray.count > 0) {
            //                HYCJMyFavoriteModel *model = self.dataArray[indexPath.row];
            cell.contentLab.text = [NSString stringWithFormat:@"%@",model.title];
            [cell.bgIconImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.coverPic]] placeholderImage:PlaceholderImageView];
        }
        
        return cell;
    }
    else{
        HYCJNoDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HYCJNoDataTableViewCell class])];
        return cell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArray.count == 0) {
        return;
    }
    HYCJCriticalDetailViewController *HYCJVC = [[HYCJCriticalDetailViewController alloc] init];
    HYCJMyFavoriteModel *model = self.dataArray[indexPath.row];
    HYCJVC.financeInfoId = [NSString stringWithFormat:@"%@",model.financeInfoId];
    XZFNavigationController *nav=[[XZFNavigationController alloc]initWithRootViewController:HYCJVC];
    [self presentViewController :nav animated:NO completion:nil];
}
- (void)loadLiveOrFinanceData{
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    [XZFHttpManager GET:CollectionFinanceUrl parameters:@{@"page":@(page),@"limit":@(10),@"userId":userId} requestSerializer:NO requestToken:YES success:^(id respondseObject) {
        NSLog(@"--------我的财经--------%@",respondseObject);
        if (page == 1) {
            [self.dataArray removeAllObjects];
        }
        NSArray *arr = respondseObject[@"collectionList"][@"list"];
        if (arr.count == 0) {
            
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
        
        [self.dataArray addObjectsFromArray:[HYCJMyFavoriteModel mj_objectArrayWithKeyValuesArray:respondseObject[@"collectionList"][@"list"]]];
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
