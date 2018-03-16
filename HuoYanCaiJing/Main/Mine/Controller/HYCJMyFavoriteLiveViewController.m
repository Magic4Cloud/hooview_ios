//
//  HYCJMyFavoriteLiveViewController.m
//  HuoYanCaiJing
//
//  Created by ZPF Mac Pro on 2018/2/9.
//  Copyright © 2018年 shilei. All rights reserved.
//

#import "HYCJMyFavoriteLiveViewController.h"
#import "HYCJMyFavoriteTableViewCell.h"
#import "HYCJNoDataTableViewCell.h"
#import "HYCJMyFavoriteModel.h"
#import "HYCJHomeLiveDetailViewController.h"
#import "HYCJHomeLiveListModel.h"

static NSString *identify = @"cell";

@interface HYCJMyFavoriteLiveViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSInteger indexType;
    NSInteger page;
}
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSMutableArray *dataArray;

@end

@implementation HYCJMyFavoriteLiveViewController

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
    [self.tableView registerNib:[UINib nibWithNibName:@"HYCJMyFavoriteTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:identify];
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
        HYCJMyFavoriteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell) {
            cell = [[HYCJMyFavoriteTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identify];
        }
        if (self.dataArray.count > 0) {
            //                HYCJMyFavoriteModel *model = self.dataArray[indexPath.row];
            cell.typeLab.text = [NSString stringWithFormat:@" %@ ",model.liveTypeName];
            cell.titleLab.text = [NSString stringWithFormat:@"%@",model.liveTitle];
            cell.nameLab.text = [NSString stringWithFormat:@"%@",model.nickName];
            [cell.iconImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.logoUrl]] placeholderImage:PlaceholderImageView];
            NSString *typeStr = [NSString stringWithFormat:@"%@",model.liveStatus];
            if ([typeStr isEqualToString:@"0"]) {
                cell.liveView.backgroundColor = RGB(234, 72, 96, 1);
                cell.numberLab.text = @"直播已结束";
            }else{
                cell.liveView.backgroundColor = RGB(67, 255, 0, 1);
                cell.numberLab.text = [NSString stringWithFormat:@"%@ 人正在看",model.watchingCount];
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
    HYCJMyFavoriteModel *model = _dataArray[indexPath.row];
    if (self.dataArray.count == 0) {
        return;
    }
    NSString *liveStatusStr = [NSString stringWithFormat:@"%@",model.liveStatus];
    if ([liveStatusStr isEqualToString:@"0"]) {
        [SVProgressHUD setMinimumDismissTimeInterval:1];
        [SVProgressHUD showErrorWithStatus:@"直播已结束"];
    }else{
        
        NSString *userId = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]];
        NSString *liveId = [NSString stringWithFormat:@"%@",model.liveId];
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
- (void)loadLiveOrFinanceData{
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    [XZFHttpManager GET:CollectionLiveUrl parameters:@{@"page":@(page),@"limit":@(10),@"userId":userId} requestSerializer:NO requestToken:YES success:^(id respondseObject) {
        NSLog(@"--------我的直播--------%@",respondseObject);
        if (page == 1) {
            [self.dataArray removeAllObjects];
        }
        NSArray *arr = respondseObject[@"liveCollectionList"][@"list"];
        if (arr.count == 0) {
            
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
        
        [self.dataArray addObjectsFromArray:[HYCJMyFavoriteModel mj_objectArrayWithKeyValuesArray:respondseObject[@"liveCollectionList"][@"list"]]];
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
