//
//  HYCJMyBuyViewController.m
//  HuoYanCaiJing
//
//  Created by ZPF Mac Pro on 2018/1/13.
//  Copyright © 2018年 shilei. All rights reserved.
//

#import "HYCJMyBuyViewController.h"
#import "HYCJMyBuyTableViewCell.h"
#import "HYCJMyBuyModel.h"
#import "HYCJNoDataTableViewCell.h"

static NSString *identify = @"cell";

@interface HYCJMyBuyViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSInteger page;

}
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSMutableArray *dataArray;

@end

@implementation HYCJMyBuyViewController
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的购买";
    page = 1;
    [self setupNavigationBar];
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = RGB(241, 241, 241, 1.0);
    [self.tableView registerNib:[UINib nibWithNibName:@"HYCJMyBuyTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:identify];
    [self.tableView registerClass:[HYCJNoDataTableViewCell class] forCellReuseIdentifier:NSStringFromClass([HYCJNoDataTableViewCell class])];

    __weak typeof(self)weaskself = self;
    _tableView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        page = 1;
        [weaskself loadBuyData];
    }];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page++;
        [weaskself loadBuyData];
    }];
    [self.view addSubview:self.tableView];
    
    [self loadBuyData];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_dataArray.count == 0) {
        return HEIGHT;
    }
    return 95;
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
    HYCJMyBuyModel *model = _dataArray ? (_dataArray.count == 0 ? nil : _dataArray[indexPath.row]) : nil;
    if (model) {
        HYCJMyBuyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell) {
            cell = [[HYCJMyBuyTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identify];
        }
        if (self.dataArray.count > 0) {
//            HYCJMyBuyModel *model = self.dataArray[indexPath.row];
            cell.titleLab.text = [NSString stringWithFormat:@"%@",model.liveTitle];
            cell.timeLab.text = [NSString stringWithFormat:@"购买时间：%@",model.payTime];
            cell.moneyLab.text = [NSString stringWithFormat:@"总价：￥%@",model.orderPrice];
            cell.typeButton.text = [NSString stringWithFormat:@"%@",model.liveTypeName];
            NSString *typeStr = [NSString stringWithFormat:@"%@",model.liveStatus];
            
            if ([typeStr isEqualToString:@"1"]) {
                cell.liveLab.text = @"正在直播";
                cell.lookButton.layer.borderWidth = 1;
                cell.lookButton.layer.borderColor = RGB(234, 72, 96, 1).CGColor;
                cell.lookButton.layer.cornerRadius = 10.5;
                [cell.lookButton setEnabled:YES];
                cell.lookButton.hidden = NO;
            }else{
                
                cell.liveLab.text = @"直播已结束";
                cell.liveLab.textColor = RGB(234, 72, 96, 1);
                [cell.lookButton setEnabled:NO];
                cell.lookButton.hidden = YES;
            }
            
        }
        
        return cell;
    }
    else{
        HYCJNoDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HYCJNoDataTableViewCell class])];
        return cell;
    }
    
    
}

- (void)loadBuyData{
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    
    [XZFHttpManager GET:UserMymyOrderUrl parameters:@{@"page":@(page),@"limit":@(10),@"userId":userId} requestSerializer:NO requestToken:YES success:^(id respondseObject) {
        NSLog(@"--------我的购买--------%@",respondseObject);
        if (page == 1) {
            [self.dataArray removeAllObjects];
        }
        NSArray *arr = respondseObject[@"orderList"];
        if (arr.count == 0) {
            
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
        
        [self.dataArray addObjectsFromArray:[HYCJMyBuyModel mj_objectArrayWithKeyValuesArray:respondseObject[@"orderList"]]];
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
