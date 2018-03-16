//
//  HYCJCriticalSearchViewController.m
//  HuoYanCaiJing
//
//  Created by ZPF Mac Pro on 2018/1/16.
//  Copyright © 2018年 shilei. All rights reserved.
//

#import "HYCJCriticalSearchViewController.h"
#import "HYCJCriticalSearchTableViewCell.h"
#import "HYCJCriticalModel.h"
#import "HYCJCriticalDetailViewController.h"
#import "HYCJLoginViewController.h"

static NSString *identify = @"cell";
@interface HYCJCriticalSearchViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>{
    NSInteger page;
}
@property (nonatomic ,strong) UITextField *searchTF;
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSMutableArray *dataArray;

@end

@implementation HYCJCriticalSearchViewController
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    page = 1;
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(10.5, 25, WIDTH - 65, 32)];
    searchView.backgroundColor = [UIColor whiteColor];
    searchView.layer.cornerRadius = 16;
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(14, 7, 21, 21)];
    image.image = [UIImage imageNamed:@"icon_top_search_gray"];
    [searchView addSubview:image];
    
    self.searchTF = [[UITextField alloc] initWithFrame:CGRectMake(40, 1, WIDTH - 120, 30)];
    self.searchTF.delegate = self;
    self.searchTF.placeholder = @"输入你想了解的内容";
    self.searchTF.textColor = RGB(71, 71, 76, 1);
    self.searchTF.font = [UIFont systemFontOfSize:14];
    self.searchTF.returnKeyType = UIReturnKeySearch;
    [searchView addSubview:self.searchTF];
    
    [self.navigationController.view addSubview: searchView];
    
    UIButton *backmainButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH- 45, 25, 40, 30)];
    [backmainButton setTitle:@"取消" forState:UIControlStateNormal];
    backmainButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [backmainButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backmainButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.navigationController.view addSubview: backmainButton];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = RGB(241, 241, 241, 1.0);
    [self.tableView registerNib:[UINib nibWithNibName:@"HYCJCriticalSearchTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:identify];
    __weak typeof(self)weaskself = self;
//    _tableView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
//        page = 1;
//        [weaskself loadListDataWithSearchText:self.searchTF.text];
//    }];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page++;
        [weaskself loadListDataWithSearchText:self.searchTF.text];
    }];
    [self.view addSubview:self.tableView];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self resignTextResponder];
    
    if(textField.returnKeyType==UIReturnKeySearch)
    {
        if ([self.searchTF.text length] > 0)
        {
            page = 1;
            [self loadListDataWithSearchText:self.searchTF.text];
        }
    }
    return YES;
}
- (void)resignTextResponder
{
    if ([self.searchTF isFirstResponder])
    {
        [self.searchTF resignFirstResponder];
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 121.5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HYCJCriticalSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[HYCJCriticalSearchTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identify];
    }
    if (self.dataArray.count > 0) {
        HYCJCriticalModel *model = self.dataArray[indexPath.row];
        
        //        cell.image.image = [UIImage imageNamed:imageArray[indexPath.row]];
        [cell.bgImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.coverPic]] placeholderImage:PlaceholderImageView];
        cell.nameLab.text = [NSString stringWithFormat:@"%@",model.nickname];
        cell.titleLab.text = [NSString stringWithFormat:@"%@",model.title];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    HYCJCriticalDetailViewController *HYCJVC = [[HYCJCriticalDetailViewController alloc] init];
    HYCJCriticalModel *model = self.dataArray[indexPath.row];
    HYCJVC.financeInfoId = [NSString stringWithFormat:@"%@",model.financeInfoId];
    XZFNavigationController *nav=[[XZFNavigationController alloc]initWithRootViewController:HYCJVC];
    [self presentViewController :nav animated:NO completion:nil];
}

- (void)loadListDataWithSearchText:(NSString *)text{
    NSDictionary *dic = @{@"page":@(page),@"limit":@(5),@"keyword":text};
    NSLog(@"-------------%@",dic);
    [SVProgressHUD show];
    [XZFHttpManager GET:FinanceinfoListUrl parameters:@{@"page":@(page),@"limit":@(5),@"keyword":text} requestSerializer:NO requestToken:NO success:^(id respondseObject) {
        NSLog(@"--------资讯搜索列表--------%@",respondseObject);
        if (page == 1) {
            [self.dataArray removeAllObjects];
        }
        NSArray *arr = respondseObject[@"financeList"][@"list"];
        if (arr.count == 0) {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
        
        [self.dataArray addObjectsFromArray:[HYCJCriticalModel mj_objectArrayWithKeyValuesArray:respondseObject[@"financeList"][@"list"]]];
        
        [self.tableView reloadData];
        [SVProgressHUD dismiss];
        
    } failure:^(NSError *error) {
        
    }];
}
- (void)backButtonAction{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
