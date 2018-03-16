//
//  HYCJCommentsListViewController.m
//  HuoYanCaiJing
//
//  Created by ZPF Mac Pro on 2018/2/1.
//  Copyright © 2018年 shilei. All rights reserved.
//

#import "HYCJCommentsListViewController.h"
#import "PSCContentNTableViewCell.h"
#import "PSchoolModel.h"
#import "HYCJNoDataTableViewCell.h"
#import "BottomRecommView.h"

@interface HYCJCommentsListViewController ()<UITableViewDelegate,UITableViewDataSource,PSCContentNTableViewCellDelegate,BottomRecommViewDelegate>{
    NSInteger page;
}
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSMutableArray *tableData;
@property (strong,nonatomic) BottomRecommView *bottomView;

@end

@implementation HYCJCommentsListViewController


- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setupNavigationBar];
    
    self.title = @"所有评论";
    
    UIButton *backmainButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 13, 22)];
    [backmainButton setImage:[UIImage imageNamed:@"return_white"] forState:UIControlStateNormal];
    [backmainButton addTarget:self action:@selector(backmain) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backmainItem = [[UIBarButtonItem alloc] initWithCustomView:backmainButton];
    [self.navigationItem setLeftBarButtonItem:backmainItem];
    
    page = 1;
    self.tableView = [self tableView];
    [self.view addSubview:_tableView];
    [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(- 50);
    }];
    self.tableData = [NSMutableArray array];
    _bottomView = [[BottomRecommView alloc] init];
    _bottomView.delegate = self;
    [self.view addSubview:_bottomView];
    
    [_bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.mas_bottom).offset(0);
        make.right.left.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
        //        make.height.offset(50);
    }];
    [self loadListData];
}
- (void)backmain{
    [self dismissViewControllerAnimated:NO completion:nil];
}
- (UITableView *)tableView{
    if (_tableView) {
        //        [_tableView removeFromSuperview];
        return _tableView;
    }
    
    UITableView *table = [[UITableView alloc] init];
    table.delegate = self;
    table.dataSource = self;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.estimatedRowHeight = 120;
    table.rowHeight = UITableViewAutomaticDimension;
    
    [table registerClass:[PSCContentNTableViewCell class] forCellReuseIdentifier:NSStringFromClass([PSCContentNTableViewCell class])];
    [table registerClass:[HYCJNoDataTableViewCell class] forCellReuseIdentifier:NSStringFromClass([HYCJNoDataTableViewCell class])];
    
    return table;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _tableData ? (_tableData.count == 0 ? 1 : _tableData.count) : 1;
//    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PSchoolModel *mode = _tableData ? (_tableData.count == 0 ? nil : _tableData[indexPath.row]) : nil;
    if (mode) {
        PSCContentNTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PSCContentNTableViewCell class])];
        cell.delegate = self;
        cell.row = indexPath.row;
        cell.model =_tableData ? _tableData[indexPath.row] : nil;
        return cell;
    }
    else{
        HYCJNoDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HYCJNoDataTableViewCell class])];
        return cell;
    }
}
- (void)loadListData{
    NSString *userId = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]];
    
    [XZFHttpManager GET:FinanceCommentListUrl parameters:@{@"financeInfoId":self.financeInfoId,@"userId":userId,@"page":@(page),@"limit":@(10)} requestSerializer:NO requestToken:NO success:^(id respondseObject) {
        NSLog(@"--------评论列表--------%@",respondseObject);
        if (page == 1) {
            [self.tableData removeAllObjects];
        }
        NSArray *arr = respondseObject[@"commentList"][@"list"];
        if (arr.count == 0) {
            
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
        
//        [self.tableData addObjectsFromArray:[PSchoolModel mj_objectArrayWithKeyValuesArray:respondseObject[@"commentList"][@"list"]]];
        
        for (int i = 0; i < arr.count; i++) {
            PSchoolModel *model = [[PSchoolModel alloc] init];
            model.praise = [arr[i][@"praise"] integerValue];
            model.infoCommentId = [NSString stringWithFormat:@"%@",arr[i][@"infoCommentId"]];
            model.comment = [NSString stringWithFormat:@"%@",arr[i][@"comment"]];
            model.nickname = [NSString stringWithFormat:@"%@",arr[i][@"nickname"]];
            model.createTime = [NSString stringWithFormat:@"%@",arr[i][@"createTime"]];
            model.headUrl = [NSString stringWithFormat:@"%@",arr[i][@"headUrl"]];
            model.praiseNum = [NSString stringWithFormat:@"%@",arr[i][@"praiseNum"]];
            model.clickStatus = 0;
            [self.tableData addObject:model];
        }
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)giveLikeButtonPressedWithCell:(UIButton *)sender{
    PSchoolModel *model = _tableData[sender.tag];
    NSInteger praise = model.praise;
    if (praise == 0) {
        [XZFHttpManager POST:financeInfoCommentpraiseUrl parameters:@{@"infoCommentId":model.infoCommentId} requestSerializer:NO requestToken:YES success:^(id respondseObject) {
            NSLog(@"---点赞--%@",respondseObject);
            PSchoolModel *chooseModel = [[PSchoolModel alloc] init];
            chooseModel.praise = 1;
            chooseModel.infoCommentId = model.infoCommentId;
            chooseModel.comment = model.comment;
            chooseModel.nickname = model.nickname;
            chooseModel.createTime = model.createTime;
            chooseModel.headUrl = model.headUrl;
//            chooseModel.praiseNum = model.praiseNum;
            chooseModel.clickStatus = model.clickStatus;
            
            NSInteger num = [model.praiseNum integerValue];
            NSInteger newNum = num + 1;
            chooseModel.praiseNum = [NSString stringWithFormat:@"%ld",newNum];
            
            [self.tableData replaceObjectAtIndex:sender.tag withObject:chooseModel];
            
            [self.tableView reloadData];
            
        } failure:^(NSError *error) {
            
        }];
    }else{
        [XZFHttpManager POST:financeInfoCommentPraiseCancelUrl parameters:@{@"infoCommentId":model.infoCommentId} requestSerializer:NO requestToken:YES success:^(id respondseObject) {
            NSLog(@"---取消点赞--%@",respondseObject);
            PSchoolModel *chooseModel = [[PSchoolModel alloc] init];
            chooseModel.praise = 0;
            chooseModel.infoCommentId = model.infoCommentId;
            chooseModel.comment = model.comment;
            chooseModel.nickname = model.nickname;
            chooseModel.createTime = model.createTime;
            chooseModel.headUrl = model.headUrl;
            //            chooseModel.praiseNum = model.praiseNum;
            chooseModel.clickStatus = model.clickStatus;
            
            NSInteger num = [model.praiseNum integerValue];
            NSInteger newNum = num - 1;
            chooseModel.praiseNum = [NSString stringWithFormat:@"%ld",newNum];
            
            [self.tableData replaceObjectAtIndex:sender.tag withObject:chooseModel];
            
            [self.tableView reloadData];
            
        } failure:^(NSError *error) {
            
        }];
    }

    
}
#pragma mark --- 发送评论

-(void)senButtonPressedWith:(NSString *)content{
    NSString *userId = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]];
    [SVProgressHUD show];
    
    [XZFHttpManager POST:FinanceCommentUrl parameters:@{@"financeInfoId":self.financeInfoId,@"comment":content,@"userId":userId} requestSerializer:NO requestToken:YES success:^(id respondseObject) {
        
        NSLog(@"------发送评论--------%@",respondseObject);
        [self loadListData];
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
