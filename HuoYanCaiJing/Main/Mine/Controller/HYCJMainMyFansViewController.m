//
//  HYCJMainMyFansViewController.m
//  HuoYanCaiJing
//
//  Created by ZPF Mac Pro on 2018/2/10.
//  Copyright © 2018年 shilei. All rights reserved.
//

#import "HYCJMainMyFansViewController.h"
#import "HYCJMyFinceAndAttentionTableViewCell.h"
#import "HYCJMyAttentionModel.h"
#import "HYCJNoDataTableViewCell.h"

static NSString *identify = @"cell";
@interface HYCJMainMyFansViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSInteger page;
}
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) ZJScrollSegmentView *scrollPageView;
@property (strong,nonatomic) NSMutableArray *dataArray;

@end

@implementation HYCJMainMyFansViewController

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    page = 1;
    self.title = @"我的";
    self.view.backgroundColor = RGB(241, 241, 241, 1);
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, WIDTH, HEIGHT - 114 - 10) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = RGB(241, 241, 241, 1.0);
    [self.tableView registerNib:[UINib nibWithNibName:@"HYCJMyFinceAndAttentionTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:identify];
    [self.tableView registerClass:[HYCJNoDataTableViewCell class] forCellReuseIdentifier:NSStringFromClass([HYCJNoDataTableViewCell class])];
    __weak typeof(self)weaskself = self;
    _tableView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        page = 1;
        [weaskself loadUserMyfollowOrMyfansData];
    }];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page++;
        [weaskself loadUserMyfollowOrMyfansData];
    }];
    
    [self.view addSubview:self.tableView];
    
    [self loadUserMyfollowOrMyfansData];
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
    HYCJMyAttentionModel *model = _dataArray ? (_dataArray.count == 0 ? nil : _dataArray[indexPath.row]) : nil;
    if (model) {
        
        HYCJMyFinceAndAttentionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell) {
            cell = [[HYCJMyFinceAndAttentionTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identify];
        }
        if (self.dataArray.count > 0) {
            //                HYCJMyAttentionModel *model = self.dataArray[indexPath.row];
            cell.nicknameLab.text = [NSString stringWithFormat:@"%@",model.nickname];
            NSString *introduce = [NSString stringWithFormat:@"%@",model.introduce];
            if ([introduce isEqualToString:@"<null>"] || [introduce isEqualToString:@"(null)"]) {
                cell.introduceLab.text = @"";
            }else{
                cell.introduceLab.text = [NSString stringWithFormat:@"%@",model.introduce];
            }
            [cell.headerImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.headUrl]] placeholderImage:PlaceholderImg];
            NSInteger mutual = [model.mutual integerValue];
            cell.attentionButton.layer.cornerRadius = 10.5;
            [cell.attentionButton setEnabled:YES];
            cell.attentionButton.tag = indexPath.row;
            [cell.attentionButton addTarget:self action:@selector(attentionButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            if (mutual == 1) {
                [cell.attentionButton setTitle:@"相互关注" forState:UIControlStateNormal];
                [cell.attentionButton setTitleColor:RGB(155, 155, 155, 1) forState:UIControlStateNormal];
                [cell.attentionButton setImage:[UIImage imageNamed:@"icon_fans_mutual"] forState:UIControlStateNormal];
                cell.attentionButtonWidth.constant = 88;
                cell.attentionButton.layer.borderColor = RGB(155, 155, 155, 1).CGColor;
                cell.attentionButton.layer.borderWidth = 1;
                cell.attentionButton.titleLabel.font = [UIFont systemFontOfSize:12];
            }else{
                [cell.attentionButton setTitle:@"关注" forState:UIControlStateNormal];
                [cell.attentionButton setTitleColor:RGB(225, 54, 102, 1) forState:UIControlStateNormal];
                [cell.attentionButton setImage:[UIImage imageNamed:@"icon_fans_add"] forState:UIControlStateNormal];
                cell.attentionButtonWidth.constant = 70;
                cell.attentionButton.layer.borderColor = RGB(225, 54, 102, 1).CGColor;
                cell.attentionButton.layer.borderWidth = 1;
                cell.attentionButton.titleLabel.font = [UIFont systemFontOfSize:12];
            }
        }
        return cell;
    }
    else{
        HYCJNoDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HYCJNoDataTableViewCell class])];
        return cell;
    }
    
}
- (void)loadUserMyfollowOrMyfansData{
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    [XZFHttpManager GET:UserMyfansUrl parameters:@{@"page":@(page),@"limit":@(10),@"userId":userId} requestSerializer:NO requestToken:YES success:^(id respondseObject) {
        NSLog(@"--------我的粉丝--------%@",respondseObject);
        if (page == 1) {
            [self.dataArray removeAllObjects];
        }
        NSArray *arr = respondseObject[@"myFansList"];
        if (arr.count == 0) {
            
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
        
        [self.dataArray addObjectsFromArray:[HYCJMyAttentionModel mj_objectArrayWithKeyValuesArray:respondseObject[@"myFansList"]]];
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}
//关注
- (void)attentionButtonAction:(UIButton *)sender{
    [SVProgressHUD show];
    HYCJMyAttentionModel *model = _dataArray[sender.tag];
    NSInteger mutual = [model.mutual integerValue];
    if (mutual == 0) {
        //        UserFollowUrl
        NSString *userIdStr = [NSString stringWithFormat:@"%@",model.userId];
        [XZFHttpManager POST:UserFollowUrl parameters:@{@"userId":userIdStr} requestSerializer:NO requestToken:YES success:^(id respondseObject) {
            NSLog(@"---关注--%@",respondseObject);
            
            HYCJMyAttentionModel *clickModel = [[HYCJMyAttentionModel alloc] init];
            clickModel.userId = model.userId;
            clickModel.nickname = model.nickname;
            clickModel.headUrl = model.headUrl;
            clickModel.introduce = model.introduce;
            clickModel.mutual = @"1";
            
            [self.dataArray replaceObjectAtIndex:sender.tag withObject:clickModel];
            [self.tableView reloadData];
            [SVProgressHUD dismiss];
        } failure:^(NSError *error) {
            
        }];
    }else if (mutual == 1){
        
        NSString *userIdStr = [NSString stringWithFormat:@"%@",model.userId];
        [XZFHttpManager POST:UserDeleteFollowUrl parameters:@{@"userId":userIdStr} requestSerializer:NO requestToken:YES success:^(id respondseObject) {
            NSLog(@"---取消关注--%@",respondseObject);
            HYCJMyAttentionModel *clickModel = [[HYCJMyAttentionModel alloc] init];
            clickModel.userId = model.userId;
            clickModel.nickname = model.nickname;
            clickModel.headUrl = model.headUrl;
            clickModel.introduce = model.introduce;
            clickModel.mutual = @"0";
            
            [self.dataArray replaceObjectAtIndex:sender.tag withObject:clickModel];
            [self.tableView reloadData];
            
            [SVProgressHUD dismiss];
        } failure:^(NSError *error) {
            
        }];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
