//
//  HYCJHomeViewController.m
//  HuoYanCaiJing
//
//  Created by ZPF Mac Pro on 2018/1/7.
//  Copyright © 2018年 shilei. All rights reserved.
//

#import "HYCJHomeViewController.h"
#import "HYCJHomeCollectionViewCell.h"
#import "HYCJOpenAccountViewController.h"
#import "HYCJVIPLiveViewController.h"
#import "HYCJHomeLiveListModel.h"
#import "HYCJHomeLiveDetailViewController.h"
#import "HYCJHomeLiveDetailMessageViewController.h"
#import "HYCJHomeSearchViewController.h"
#import "HYCJBannerDetailViewController.h"
#import "HYCJLoginViewController.h"
#import "HYCJHomeNoDataCollectionViewCell.h"

static NSString *headerViewIdentifier = @"hederview";
@interface HYCJHomeViewController ()<UINavigationControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,SDCycleScrollViewDelegate>{
    UIView *navView;
    NSInteger recommend;//是否热门（0-否，1-是）
    NSInteger page;
    NSString *liveTypeId;
    NSInteger liveTypeTitleInt;
    NSArray *bannerUrlStr;
    UICollectionViewFlowLayout *layout;
    UIView *headerView;
}
@property (strong,nonatomic) ZJScrollSegmentView *scrollPageView;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (strong,nonatomic) SDCycleScrollView *scrollView;
@property (nonatomic,strong) NSArray *liveTypeListArr;
@property (strong,nonatomic) NSMutableArray *dataArray;
@property (strong,nonatomic) NSMutableArray *bannerArr;
@property (strong,nonatomic) NSMutableArray *titleArray;
@end

@implementation HYCJHomeViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO];
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(NSMutableArray *)bannerArr{
    if (!_bannerArr) {
        _bannerArr = [NSMutableArray array];
    }
    return _bannerArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.delegate = self;
    
    page = 1;
    recommend = 1;
    liveTypeId = @"";
    liveTypeTitleInt = 0;
    navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 64)];
    navView.backgroundColor = [UIColor redColor];
    [self.view addSubview:navView];
    
    UIImageView *navImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 64)];
    navImg.image = [UIImage imageNamed:@"top_back"];
    [navView addSubview:navImg];
    
    UIImageView *navImageView = [[UIImageView alloc] initWithFrame:CGRectMake(3, 13, 50, 50)];
    navImageView.image = [UIImage imageNamed:@"icon_loading_s_logo"];
    [navView addSubview:navImageView];
    
    UIButton *navButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - 35, 25, 30, 30)];
    [navButton setImage:[UIImage imageNamed:@"icon_top_search_gray"] forState:UIControlStateNormal];
    navButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    [navButton addTarget:self action:@selector(navButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:navButton];
    
    
    //初始化布局
    layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumInteritemSpacing = 0.6 * KWidth_Scale;
    layout.minimumLineSpacing = 0.6* KWidth_Scale;
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT - 64 - 49) collectionViewLayout:layout];
    _collectionView.backgroundColor = RGB(255, 255, 255, 1);
    [self.collectionView registerClass:[HYCJHomeCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"HYCJHomeNoDataCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"noDataCell"];
    
    //注册头视图
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewIdentifier];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    __weak typeof(self)weaskself = self;
    _collectionView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        page = 1;
        [weaskself loadLiveListData];
    }];
//    _collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        page++;
//        [weaskself loadLiveListData];
//    }];
    [self.view addSubview:self.collectionView];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    BOOL tokenBool = [BTToolFormatJudge iSStringNull:token];
    if (tokenBool == YES) {
        
    }else{
        [self loadUserInfoData];
    }
    [self loadLiveTypeData];
    [self loadBannerListData];
}
- (void)navButtonAction:(UIButton *)sender{
    HYCJHomeSearchViewController *HYCJVC = [[HYCJHomeSearchViewController alloc] init];
    XZFNavigationController *nav=[[XZFNavigationController alloc]initWithRootViewController:HYCJVC];
    [self presentViewController :nav animated:NO completion:nil];
}
#pragma mark - UINavigationControllerDelegate
// 将要显示控制器
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}
- (void)setupSegmentWithTitleArray:(NSArray *)titleArray {
    
    ZJSegmentStyle *style = [[ZJSegmentStyle alloc] init];
    style.showCover = YES;
    style.segmentHeight = 40;
    //    style.coverCornerRadius = 12;
    style.coverHeight = 2;
    style.coverBackgroundColor = RGB(255, 229, 0, 1);
    style.showLine = YES;
    style.gradualChangeTitleColor = NO;
    style.scrollTitle = YES;
    style.autoCoverWidth = YES;
    style.autoScrollLineWidth = YES;
    style.titleFont = [UIFont pingfangRegularFontWithSize:13];
    style.selectedTitleFont = [UIFont pingfangRegularFontWithSize:13];
//    style.titleBigScale = 5;
    style.scrollLineColor = RGB(255, 229, 0, 1);
    style.selectedTitleColor = RGB(255, 229, 0, 1);
    style.normalTitleColor = RGB(255, 255, 255, 1);
//    style.perWidth = (WIDTH - 120*KWidth_Scale) / 6;
    style.titleMargin = 15;
//    style.scrollVLineWidth = (WIDTH - 120*KWidth_Scale) / 6 - 10;
    style.xPlus = 5;
    style.titleCoverLeftMargin = 0;
    style.titleCoverMargin = 5;
    
    //NSArray *childVcs = [NSArray arrayWithArray:[self setupChildVcAndTitle]];
    self.scrollPageView = [[ZJScrollSegmentView alloc] initWithFrame:CGRectMake(51*KWidth_Scale, 25, WIDTH - 112*KWidth_Scale, 30) segmentStyle:style titles:titleArray titleDidClick:^(UILabel *label, NSInteger index) {
        liveTypeTitleInt = index;
        if (index == 0) {
            recommend = 1;
            liveTypeId = @"";
        }else{
            recommend = 0;
            liveTypeId = _liveTypeListArr[index - 1][@"liveTypeId"];
        }
        page = 1;
        [self loadLiveListData];
    }];
    
    [self.scrollPageView setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]]];
    [self.scrollPageView setSelectedIndex:0 animated:YES];
    [navView addSubview:self.scrollPageView];
    
}

#pragma mark -- UICollectionViewDataSource UICollectionViewDelegate
//指定分区个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
//指定分区对应item的数量
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.dataArray.count == 0) {
        return 1;
    }
    return self.dataArray.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataArray.count == 0) {
        return CGSizeMake(WIDTH, 240);
    }
    return CGSizeMake((WIDTH - 2)/2, 170*KHEIGHT_Scale);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0.1, 0.1, 0.1, 0.1);
}
//  返回头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    //如果是头视图
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *header=[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerViewIdentifier forIndexPath:indexPath];
        //添加头视图的内容
        [headerView removeFromSuperview];
        headerView = [[UIView alloc] init];
        _scrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100*KWidth_Scale) delegate:self placeholderImage:nil];
        _scrollView.delegate = self;
        _scrollView.pageDotImage = [UIImage imageNamed:@"圆角矩形.png"];
        _scrollView.currentPageDotImage = [UIImage imageNamed:@"圆角矩形-2xh.png"];
        _scrollView.autoScrollTimeInterval = 3.0;
        _scrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _scrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _scrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        [headerView addSubview:_scrollView];
        [_scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(headerView.mas_top).offset(0);
            make.left.right.equalTo(headerView).offset(0);
            make.height.offset(100*KWidth_Scale);
        }];
        _scrollView.imageURLStringsGroup = self.bannerArr;
        
        if (recommend == 1) {
//            layout.headerReferenceSize=CGSizeMake(WIDTH, 250*KWidth_Scale); //设置collectionView头视图的大小
            NSLog(@"-------------%ld",recommend);
            headerView.frame = CGRectMake(0, 0, WIDTH, 250*KWidth_Scale);
            NSArray *imageArr = @[@"btn_opena_ccount",@"btn_vip_video",@"btn_news"];
            NSArray *nameArr = @[@"一键开户",@"VIP直播",@"火眼金睛"];
            for (int i = 0; i < 3; i ++) {
                UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH * i /3, 100*KWidth_Scale, WIDTH/3, 100*KWidth_Scale)];
                button.backgroundColor = [UIColor whiteColor];
                button.tag = i;
                [button addTarget:self action:@selector(headerButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                [headerView addSubview:button];
                
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(60*KWidth_Scale + (30*KWidth_Scale + (WIDTH - 210*KWidth_Scale)/2)*i, 123*KWidth_Scale, 30*KWidth_Scale, 30*KWidth_Scale)];
                imageView.image = [UIImage imageNamed:imageArr[i]];
                [headerView addSubview:imageView];
                
                UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(35*KWidth_Scale + (30*KWidth_Scale + (WIDTH - 210*KWidth_Scale)/2)*i, 165*KWidth_Scale, 80*KWidth_Scale, 20*KWidth_Scale)];
                nameLab.text = nameArr[i];
                nameLab.textAlignment = NSTextAlignmentCenter;
                nameLab.font = [UIFont systemFontOfSize:15*KWidth_Scale];
                nameLab.textColor = RGB(71, 71, 71, 1);
                [headerView addSubview:nameLab];
                
            }
            
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 200*KWidth_Scale, WIDTH, 5*KWidth_Scale)];
            lineView.backgroundColor = RGB(241, 241, 241, 1);
            [headerView addSubview:lineView];
            //头视图添加view
            [header addSubview:headerView];
            
            UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(10*KWidth_Scale, 219*KWidth_Scale, 100*KWidth_Scale, 20*KWidth_Scale)];
            titleLab.text = @"推荐直播";
            titleLab.textAlignment = NSTextAlignmentLeft;
            titleLab.font = [UIFont systemFontOfSize:18*KWidth_Scale];
            titleLab.textColor = RGB(234, 72, 96, 1);
            [headerView addSubview:titleLab];
        }else{
            
            headerView.frame = CGRectMake(0, 0, WIDTH, 100*KWidth_Scale);
            //头视图添加view
            [header addSubview:headerView];
        }
        
        
        
        return header;
    }
    return nil;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (recommend == 1) {
        return CGSizeMake(WIDTH, 250*KWidth_Scale);
    }else{
        return CGSizeMake(WIDTH, 100*KWidth_Scale);
    }
}
//配置每一个item
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArray.count == 0) {
        
        HYCJHomeNoDataCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"noDataCell" forIndexPath:indexPath];
        return cell;
    }
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
    if (self.dataArray.count == 0) {
        return;
    }
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
//banner点击事件

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    NSLog(@"------------%ld",index);
    HYCJBannerDetailViewController *HYCJVC = [[HYCJBannerDetailViewController alloc] init];
    XZFNavigationController *nav=[[XZFNavigationController alloc]initWithRootViewController:HYCJVC];
    HYCJVC.urlStr = [NSString stringWithFormat:@"%@",bannerUrlStr[index][@"bannerUrl"]];
    [self presentViewController :nav animated:NO completion:nil];
    
}
#pragma mark --- headerButtonAction

- (void)headerButtonAction:(UIButton *)sender{
    switch (sender.tag) {
        case 0:
        {
            HYCJOpenAccountViewController *HYCJVC = [[HYCJOpenAccountViewController alloc] init];
            [self presentViewController:HYCJVC animated:NO completion:nil];
        }
            break;
        case 1:
        {
            HYCJVIPLiveViewController *HYCJVC = [[HYCJVIPLiveViewController alloc] init];
            HYCJVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:HYCJVC animated:YES];
        }
            break;
        case 2:
        {
            self.tabBarController.selectedIndex = 1;
        }
            break;
        default:
            break;
    }
}
- (void)loadLiveTypeData{
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    
    [XZFHttpManager GET:LiveTypeListUrl parameters:@{} requestSerializer:NO requestToken:NO success:^(id respondseObject) {
        NSLog(@"--------直播分类--------%@",respondseObject);
//        NSArray *titleArray = @[@"热门",@"股票",@"期货",@"黄金",@"现货",@"外汇"];
        self.titleArray = [NSMutableArray array];
        self.liveTypeListArr = respondseObject[@"liveTypeList"];
        for (int i = 0; i < self.liveTypeListArr.count + 1; i ++) {
            if (i == 0) {
                [self.titleArray addObject:@"热门"];
            }else{
                NSString *titleStr = [NSString stringWithFormat:@"%@",self.liveTypeListArr[i - 1][@"typeName"]];
                [self.titleArray addObject:titleStr];
            }
        }
        
        [self setupSegmentWithTitleArray:self.titleArray];
        
        [self loadLiveListData];
    } failure:^(NSError *error) {
        
        
    }];
}
- (void)loadLiveListData{
    
    NSDictionary *dic;
    dic = @{@"liveTypeId":liveTypeId,@"recommend":@(recommend),@"liveVip":@"0",@"keyword":@"",@"page":@(page),@"limit":@"10"};
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
- (void)loadBannerListData{
    
    [XZFHttpManager GET:BannerListUrl parameters:@{} requestSerializer:NO requestToken:NO success:^(id respondseObject) {
        NSLog(@"--------轮播图--------%@",respondseObject);
        bannerUrlStr = respondseObject[@"bannerList"];
        
        for (int i = 0; i < bannerUrlStr.count ; i ++) {
            NSString *picStr = [NSString stringWithFormat:@"%@",bannerUrlStr[i][@"picUrl"]];
            [self.bannerArr addObject:picStr];
        }
        [self.collectionView reloadData];
        
    } failure:^(NSError *error) {
        
        
    }];
}
- (void)loadUserInfoData{
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    
    [XZFHttpManager GET:UserInfoUrl parameters:@{@"userId":userId} requestSerializer:NO requestToken:YES success:^(id respondseObject) {
        NSLog(@"--------获取个人信息--------%@",respondseObject);
        NSString *nickname = [NSString stringWithFormat:@"%@",respondseObject[@"userInfo"][@"nickname"]];
        [[NSUserDefaults standardUserDefaults] setObject:nickname forKey:@"nickname"];

    } failure:^(NSError *error) {
        
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
