//
//  HYCJHomeSearchViewController.m
//  HuoYanCaiJing
//
//  Created by ZPF Mac Pro on 2018/2/4.
//  Copyright © 2018年 shilei. All rights reserved.
//

#import "HYCJHomeSearchViewController.h"
#import "HYCJHomeCollectionViewCell.h"
#import "HYCJHomeLiveListModel.h"
#import "HYCJHomeLiveDetailViewController.h"
#import "HYCJLoginViewController.h"

@interface HYCJHomeSearchViewController ()<UITextFieldDelegate,UICollectionViewDataSource,UICollectionViewDelegate>{
    NSInteger page;

}
@property (nonatomic ,strong) UITextField *searchTF;
@property (strong,nonatomic) NSMutableArray *dataArray;
@property (nonatomic,strong) UICollectionView *collectionView;

@end

@implementation HYCJHomeSearchViewController
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
    self.searchTF.placeholder = @"输入搜索内容";
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

    //初始化布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumInteritemSpacing = 0.6 * KWidth_Scale;
    layout.minimumLineSpacing = 0.6* KWidth_Scale;
//    layout.headerReferenceSize=CGSizeMake(WIDTH, 250*KWidth_Scale); //设置collectionView头视图的大小
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64) collectionViewLayout:layout];
    _collectionView.backgroundColor = RGB(255, 255, 255, 1);
    [self.collectionView registerClass:[HYCJHomeCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    //注册头视图
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self resignTextResponder];
    
    if(textField.returnKeyType==UIReturnKeySearch)
    {
        if ([self.searchTF.text length] > 0)
        {
            page = 1;
            [self loadLiveListDataWithContent:self.searchTF.text];
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
#pragma mark -- UICollectionViewDataSource UICollectionViewDelegate
//指定分区个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
//指定分区对应item的数量
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake((WIDTH - 2)/2, 170*KHEIGHT_Scale);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0.1, 0.1, 0.1, 0.1);
}

//配置每一个item
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HYCJHomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.indexCell = indexPath.row + 1;
    if (self.dataArray.count > 0) {
        HYCJHomeLiveListModel *model = self.dataArray[indexPath.row];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.logourl]] placeholderImage:PlaceholderImageView];
        cell.titleLab.text = [NSString stringWithFormat:@"%@",model.liveTitle];
        cell.titleLabTwo.text = [NSString stringWithFormat:@"%@",model.location];
        cell.numberLab.text = [NSString stringWithFormat:@"%@ 人正在看",model.watchingCount];
//        [cell.titleButton setTitle:[NSString stringWithFormat:@"%@",model.liveTypeName] forState:UIControlStateNormal];
        cell.titleType.text = [NSString stringWithFormat:@" %@ ",model.liveTypeName];
        
    }
    
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
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
    
    //    HYCJHomeLiveListModel *model = self.dataArray[indexPath.row];
    //    HYCJHomeLiveDetailMessageViewController *HYCJVC = [[HYCJHomeLiveDetailMessageViewController alloc] initWithConversationChatter:model.roomId conversationType:EMConversationTypeGroupChat];
    
    //    NSLog(@"-----------------%ld",indexPath.row);
    HYCJHomeLiveDetailViewController *HYCJVC = [[HYCJHomeLiveDetailViewController alloc] init];
    HYCJVC.model = self.dataArray[indexPath.row];
    //    HYCJHomeLiveListModel *model = self.dataArray[indexPath.row];
    
    //    EaseMessageViewController *chatController = [[EaseMessageViewController alloc] initWithConversationChatter:model.roomId conversationType:EMConversationTypeGroupChat];
    [self presentViewController:HYCJVC animated:YES completion:^{
        
    }];
}
- (void)loadLiveListDataWithContent:(NSString *)content{
    
    NSDictionary *dic;
    dic = @{@"liveTypeId":@"",@"recommend":@"0",@"liveVip":@"0",@"keyword":content,@"page":@(page),@"limit":@"10"};
    [SVProgressHUD show];
    [XZFHttpManager GET:LiveListUrl parameters:dic requestSerializer:NO requestToken:NO success:^(id respondseObject) {
        NSLog(@"--------直播列表--------%@",respondseObject);
        if (page == 1) {
            [self.dataArray removeAllObjects];
        }
        NSArray *arr = respondseObject[@"liveList"][@"list"];
        if (arr.count == 0) {
            
            [self.collectionView.mj_header endRefreshing];
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        }else{
            
            [self.collectionView.mj_header endRefreshing];
            [self.collectionView.mj_footer endRefreshing];
        }
        
        [self.dataArray addObjectsFromArray:[HYCJHomeLiveListModel mj_objectArrayWithKeyValuesArray:respondseObject[@"liveList"][@"list"]]];
        
        
        [self.collectionView reloadData];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
