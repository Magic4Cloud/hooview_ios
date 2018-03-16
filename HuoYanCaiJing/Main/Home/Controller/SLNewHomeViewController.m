//
//  SLNewHomeViewController.m
//  HuoYanCaiJing
//
//  Created by ZPF Mac Pro on 2018/2/10.
//  Copyright © 2018年 shilei. All rights reserved.
//

#import "SLNewHomeViewController.h"
#import "HYCJMyFavoriteLiveViewController.h"
#import "HYCJMyFavoriteFinanceViewController.h"
#import "HYCJHomeOneViewController.h"
#import "HYCJHomeTwoViewController.h"
#import "HYCJHomeSearchViewController.h"

@interface SLNewHomeViewController ()<XLBasePageControllerDelegate,XLBasePageControllerDataSource>{
    UIView *navView;
    NSArray *liveTypeIdArr;
}

@property (nonatomic,strong) NSArray *titleArray;
@property (nonatomic,strong) UIView *headerView;
@property (strong,nonatomic) NSMutableArray *liveTypeIdArray;
@property (strong,nonatomic) NSMutableArray *liveTitleArray;

@end

@implementation SLNewHomeViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
#pragma mark - UINavigationControllerDelegate
// 将要显示控制器
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.2];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _titleArray = @[@"热门",@"股票",@"国内期货",@"国际期货",@"外汇",@"港股/美股"];
    liveTypeIdArr = @[@"141",@"142",@"143",@"144",@"145"];
    
    UIImageView *navImageView = [[UIImageView alloc] initWithFrame:CGRectMake(3, 13, 50, 50)];
    navImageView.image = [UIImage imageNamed:@"icon_loading_s_logo"];
    [self.view addSubview:navImageView];
    
    UIButton *navButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - 35, 25, 30, 30)];
    [navButton setImage:[UIImage imageNamed:@"icon_top_search_gray"] forState:UIControlStateNormal];
    navButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    [navButton addTarget:self action:@selector(navButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:navButton];
    
    self.delegate = self;
    self.dataSource = self;
    
    //self.lineWidth = 2.0;//选中下划线宽度
    self.titleFont = [UIFont systemFontOfSize:16.0];
    self.defaultColor = RGB(255, 255, 255, 1);//默认字体颜色
    self.chooseColor = RGB(255, 229, 0, 1);//选中字体颜色
    self.selectIndex = 0;//默认选中第几页
    
    [self reloadScrollPage];
    
//    [self loadLiveTypeData];
    
}
- (void)navButtonAction:(UIButton *)sender{
    HYCJHomeSearchViewController *HYCJVC = [[HYCJHomeSearchViewController alloc] init];
    XZFNavigationController *nav=[[XZFNavigationController alloc]initWithRootViewController:HYCJVC];
    [self presentViewController :nav animated:NO completion:nil];
}
-(NSInteger)numberViewControllersInViewPager:(XLBasePageController *)viewPager
{
    return _titleArray.count;
}

-(UIViewController *)viewPager:(XLBasePageController *)viewPager indexViewControllers:(NSInteger)index
{
    if (index == 0) {
        HYCJHomeOneViewController *listVC = [[HYCJHomeOneViewController alloc] init];
        return listVC;
    }else{
        HYCJHomeTwoViewController *detailVC = [[HYCJHomeTwoViewController alloc] init];
        detailVC.liveTypeId = liveTypeIdArr[index - 1];
        return detailVC;
    }
}

-(CGFloat)heightForTitleViewPager:(XLBasePageController *)viewPager
{
    return 40;
}

-(NSString *)viewPager:(XLBasePageController *)viewPager titleWithIndexViewControllers:(NSInteger)index
{
    return self.titleArray[index];
}

-(void)viewPagerViewController:(XLBasePageController *)viewPager didFinishScrollWithCurrentViewController:(UIViewController *)viewController
{
    
    self.title = viewController.title;
}

//#pragma mark 预留--可不实现
//
//-(UIView *)headerViewForInViewPager:(XLBasePageController *)viewPager
//{
//    return self.headerView;
//}
//
//-(CGFloat)heightForHeaderViewPager:(XLBasePageController *)viewPager
//{
//    return 100;
//}

-(UIView *)headerView
{
    if (_headerView == nil) {
        _headerView = [[UIView alloc] init];
        _headerView.backgroundColor = [UIColor colorWithRed:120/255.0f green:210/255.0f blue:249/255.0f alpha:1];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, self.view.bounds.size.width, 40)];
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:12.0];
        label.text = @"固定的头View,不可跟随滑动,可不显示";
        label.textAlignment = NSTextAlignmentCenter;
        [_headerView addSubview:label];
    }
    return _headerView;
}
- (void)loadLiveTypeData{
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    
    [XZFHttpManager GET:LiveTypeListUrl parameters:@{} requestSerializer:NO requestToken:NO success:^(id respondseObject) {
        NSLog(@"--------直播分类--------%@",respondseObject);
        //        NSArray *titleArray = @[@"热门",@"股票",@"期货",@"黄金",@"现货",@"外汇"];
        self.liveTypeIdArray = [NSMutableArray array];
        self.liveTitleArray = [NSMutableArray array];
        NSArray *liveTypeListArr = respondseObject[@"liveTypeList"];
        for (int i = 0; i < liveTypeListArr.count; i ++) {
            NSString *liveTypeIdStr = [NSString stringWithFormat:@"%@",liveTypeListArr[i][@"liveTypeId"]];
            [self.liveTypeIdArray addObject:liveTypeIdStr];
        }
        for (int i = 0; i < liveTypeListArr.count + 1; i ++) {
            if (i == 0) {
                [self.liveTitleArray addObject:@"热门"];
            }else{
                NSString *titleStr = [NSString stringWithFormat:@"%@",liveTypeListArr[i - 1][@"typeName"]];
                NSLog(@"---------%@",titleStr);
                [self.liveTitleArray addObject:titleStr];
            }
        }
        NSLog(@"----1---%@",self.liveTypeIdArray);
        NSLog(@"----2----%@",self.liveTitleArray);
//        _titleArray = self.liveTitleArray;
        
//        [self reloadScrollPage];
        
    } failure:^(NSError *error) {
        
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
