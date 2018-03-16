//
//  HYCJCriticalViewController.m
//  HuoYanCaiJing
//
//  Created by ZPF Mac Pro on 2018/1/7.
//  Copyright © 2018年 shilei. All rights reserved.
//

#import "HYCJCriticalViewController.h"
#import "MyCollectionViewCell.h"
#import "CollectionLayout.h"
#import "HYCJCriticalSearchViewController.h"
#import "HYCJCriticalModel.h"
#import "HYCJCriticalDetailViewController.h"
#import "HYCJLoginViewController.h"
#import "UIImage+FEBoxBlur.h"

static NSString * const CVCell = @"WaterfallsCell";

@interface HYCJCriticalViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>{
//    NSArray *strArray;
//    NSArray *titleArray;
    NSArray *imageArray;
    NSInteger page;
}
@property (strong, nonatomic) UICollectionView * myCollectionView;
@property (strong, nonatomic) CollectionLayout * myCVLayout;
@property (strong,nonatomic) NSMutableArray *dataArray;
@property (strong,nonatomic) NSMutableArray *contentArray;
@property (strong,nonatomic) NSMutableArray *introduceArray;


@end

@implementation HYCJCriticalViewController
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(NSMutableArray *)contentArray{
    if (!_contentArray) {
        _contentArray = [NSMutableArray array];
    }
    return _contentArray;
}
-(NSMutableArray *)introduceArray{
    if (!_introduceArray) {
        _introduceArray = [NSMutableArray array];
    }
    return _introduceArray;
}
#pragma mark - 懒加载
- (UICollectionView *)myCollectionView
{
    if (!_myCollectionView) {
        _myCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 49) collectionViewLayout:self.myCVLayout];
        _myCollectionView.backgroundColor = [UIColor whiteColor];
        
        [_myCollectionView registerNib:[UINib nibWithNibName:@"MyCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:CVCell];
        
        _myCollectionView.dataSource = self;
        _myCollectionView.delegate = self;
        __weak typeof(self)weaskself = self;
        _myCollectionView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
            [[NSNotificationCenter defaultCenter]postNotificationName:@"CollectionLayoutNotification" object:nil userInfo:nil];
            page = 1;
            [weaskself loadListData];
        }];
        _myCollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            page++;
            [weaskself loadListData];
        }];
    }
    return _myCollectionView;
}

- (CollectionLayout *)myCVLayout {
    if (!_myCVLayout) {
        _myCVLayout = [[CollectionLayout alloc]initOptionWithColumnNum:2 rowSpacing:10.0f columnSpacing:10.0f sectionInset:UIEdgeInsetsMake(10, 10, 10, 10)];
    }
    return _myCVLayout;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"火眼金睛";
    page = 1;
    UIButton *backmainButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH- 10 - 30, 0, 30, 30)];
    backmainButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    [backmainButton setImage:[UIImage imageNamed:@"icon_top_search_gray"] forState:UIControlStateNormal];
    [backmainButton addTarget:self action:@selector(searchButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backmainItem = [[UIBarButtonItem alloc] initWithCustomView:backmainButton];
    [self.navigationItem setRightBarButtonItem:backmainItem];
    
    [self.view addSubview:self.myCollectionView];
    
//    titleArray = @[@"四部门：新能源汽车免征车辆购置税延至2020年",@"四部门：新能源汽车免征车辆购置税延至2020年",@"四部门：新能源汽车免征车辆购置税延至2020年",@"四部门：新能源汽车免征车辆购置税延至2020年",@"四部门：新能源汽车免征车辆购置税延至2020年",@"四部门：新能源汽车免征车辆购置税延至2020年",@"四部门：新能源汽车免征车辆购置税延至2020年",@"四部门：新能源汽车免征车辆购置税延至2020年",@"四部门：新能源汽车免征车辆购置税延至2020年",@"四部门：新能源汽车免征车辆购置税延至2020年",@"四部门：新能源汽车免征车辆购置税延至2020年",@"四部门：新能源汽车免征车辆购置税延至2020年",@"四部门：新能源汽车免征车辆购置税延至2020年",@"四部门：新能源汽车免征车辆购置税延至2020年",@"四部门：新能源汽车免征车辆购置税延至2020年",@"四部门：新能源汽车免征车辆购置税延至2020年"];
//    
//    strArray = @[@"很多年前看的书了，懵懵懂懂的时候。记忆里最深的是陆之昂成了通缉犯后有一次在便利店看见了傅小司的画就哭了",@"很多年前看的书了，懵懵懂懂的时候。",@"记忆里最深的是陆之昂成了通缉犯后有一次在便利店看见了傅小司的画就哭了，后来警察来了陆之昂无期徒刑。以前看到这里的时候泣不成声。",@"最阳光最干净的男生因为种种变得最沉默寡言。好心疼谢谢白敬亭愿意来演绎他的人生，你会很喜欢他的",@"“何为孤寂？”“清风，艳日，无笑意。”“可否具体？”“左拥，右抱，无情欲。”“可否再具体？”“不得你。”",@"时代峰峻看来时代峻峰卢卡斯",@"“何为良辰？” “皓月当空晴万里。” “可否具体？” “明月，晴空，心欢喜。” “可否再具体？” “与君初识。”",@"那时候的by2多单纯多可爱多好看，现在整容整得都跟个黑山老妖似的",@"撒发生的借款方尽快啦",@"时代峻峰卡见识到了会计分录卡金士顿六块腹肌阿里斯顿积分辣椒水砥砺奋进案例数",@"束带结发老实交代六块腹肌阿拉斯加打开房间卡手机登录开发机莱克斯顿",@"OK了圣诞节福利卡加上了看大家福利卡机施蒂利克福晶科技",@"第三节课发简历开始的开发廊坊金坷垃开始了",@"圣诞节快乐放假埃里克森搭建了开发量开始搭建付款啦",@"卡机圣诞快乐福建卡了圣诞节快乐发",@"很多年前看的书了，懵懵懂懂的时候。记忆里最深的是陆之昂成了通缉犯后有一次在便利店看见了傅小司的画就哭了"];
//    self.myCVLayout.dataArr = [self addData];
    imageArray = [self addData];
    self.myCVLayout.titleDataArr = self.introduceArray;
    self.myCVLayout.contentDataArr = self.contentArray;
    
    [self loadListData];
}

- (void)searchButtonAction{
    HYCJCriticalSearchViewController *HYCJVC = [[HYCJCriticalSearchViewController alloc] init];
    XZFNavigationController *nav=[[XZFNavigationController alloc]initWithRootViewController:HYCJVC];
    [self presentViewController :nav animated:NO completion:nil];
}

- (NSArray *)addData {
    NSMutableArray * arr = [NSMutableArray array];
    
    for (int i = 0; i<=16 ; i++) {
        NSString * imageName = [NSString stringWithFormat:@"%d.jpg",i];
        [arr addObject:imageName];
    }
    return arr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UICollectionView dataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.myCVLayout.titleDataArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MyCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CVCell forIndexPath:indexPath];
    
    if (self.dataArray.count > 0) {
        HYCJCriticalModel *model = self.dataArray[indexPath.row];
        
//        cell.image.image = [UIImage imageNamed:imageArray[indexPath.row]];
//        [cell.image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.coverPic]] placeholderImage:PlaceholderImageView];
        
        [cell.image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.coverPic]] placeholderImage:[UIImage imageNamed:@"morentu"] completed:^(UIImage *image, NSError *error, EMSDImageCacheType cacheType, NSURL *imageURL) {
            if (image == nil) {
                image =  [UIImage imageNamed:@"morentu"];
            }
            image = [UIImage boxblurImage:image withBlurNumber:0.3];
            cell.image.image = image;
        }];
        
        [cell.headerImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.headUrl]] placeholderImage:PlaceholderImg];
        cell.titleLab.text = self.myCVLayout.titleDataArr[indexPath.row];
        cell.contentLab.text = self.myCVLayout.contentDataArr[indexPath.row];
        cell.nameLab.text = [NSString stringWithFormat:@"%@",model.nickname];
        NSString *introduceStr = [NSString stringWithFormat:@"%@",model.introduce];
        if ([introduceStr isEqualToString:@"<null>"] || [introduceStr isEqualToString:@"(null)"]) {
            cell.titleLabel.text = @"";
        }else{
            cell.titleLabel.text = [NSString stringWithFormat:@"%@",model.introduce];
        }
    }
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"-----------------%ld",indexPath.row);
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
    
    NSLog(@"--------资讯id--------%@",[NSString stringWithFormat:@"%@",model.financeInfoId]);

    HYCJVC.model = model;
    XZFNavigationController *nav=[[XZFNavigationController alloc]initWithRootViewController:HYCJVC];
    [self presentViewController :nav animated:NO completion:nil];
}
- (void)loadListData{
    [XZFHttpManager GET:FinanceinfoListUrl parameters:@{@"page":@(page),@"limit":@(5)} requestSerializer:NO requestToken:NO success:^(id respondseObject) {
        NSLog(@"--------资讯列表--------%@",respondseObject);
        if (page == 1) {
            [self.dataArray removeAllObjects];
            [self.introduceArray removeAllObjects];
            [self.contentArray removeAllObjects];
        }
        NSArray *arr = respondseObject[@"financeList"][@"list"];
        if (arr.count == 0) {
            
            [self.myCollectionView.mj_header endRefreshing];
            [self.myCollectionView.mj_footer endRefreshingWithNoMoreData];
        }else{
            for (int i = 0; i < arr.count; i ++) {
//                NSString *introduceStr = [NSString stringWithFormat:@"%@",arr[i][@"introduce"]];
//                NSString *contentStr = [NSString stringWithFormat:@"%@",arr[i][@"content"]];
                NSString *introduceStr = [NSString stringWithFormat:@"%@",@""];
                NSString *contentStr = [NSString stringWithFormat:@"%@",arr[i][@"summary"]];
                
                [self.introduceArray addObject:introduceStr];
                [self.contentArray addObject:contentStr];
                
            }
            [self.myCollectionView.mj_header endRefreshing];
            [self.myCollectionView.mj_footer endRefreshing];
        }
        
        [self.dataArray addObjectsFromArray:[HYCJCriticalModel mj_objectArrayWithKeyValuesArray:respondseObject[@"financeList"][@"list"]]];
        
        [self.myCollectionView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}
@end
