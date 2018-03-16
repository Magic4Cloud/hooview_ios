//
//  HYCJMyAttentionViewController.m
//  HuoYanCaiJing
//
//  Created by ZPF Mac Pro on 2018/1/13.
//  Copyright © 2018年 shilei. All rights reserved.
//

#import "HYCJMyAttentionViewController.h"
#import "HYCJMainMyAttentionViewController.h"

static NSString *identify = @"cell";
@interface HYCJMyAttentionViewController (){
    NSInteger indexType;
    NSInteger page;
}
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) ZJScrollPageView *scrollPageView;
@property (strong,nonatomic) NSMutableArray *dataArray;

@end

@implementation HYCJMyAttentionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
    self.view.backgroundColor = RGB(241, 241, 241, 1);
    [self loadUserInfoData];
}


#pragma mark - private method
- (void)setup {
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    bgView.backgroundColor = [UIColor redColor];
    [self.view addSubview:bgView];
    
    ZJSegmentStyle *style = [[ZJSegmentStyle alloc] init];
    
    style.showCover = YES;
    style.segmentHeight = 40;
    //    style.coverCornerRadius = 12;
    style.coverHeight = 1;
    style.coverBackgroundColor = [UIColor whiteColor];
    style.showLine = YES;
    style.gradualChangeTitleColor = NO;
    style.scrollTitle = YES;
    style.autoCoverWidth = YES;
    style.titleFont = [UIFont pingfangRegularFontWithSize:16];
    style.selectedTitleFont = [UIFont pingfangRegularFontWithSize:16];
    style.titleBigScale = 5;
    style.scrollLineColor = RGB(224, 54, 102, 1);
    style.selectedTitleColor = RGB(234, 72 , 96, 1);
    style.normalTitleColor = RGB(74, 74, 74, 1);
    style.perWidth = 60;
    style.titleCoverLeftMargin = (WIDTH - 60*2)/2;
    style.titleMargin = 0;
    style.scrollVLineWidth = 60;
    style.xPlus = 5;
    style.titleCoverMargin = 5;
    NSArray *childVcs = [NSArray arrayWithArray:[self setupChildVcAndTitle]];
    self.scrollPageView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64) segmentStyle:style childVcs:childVcs parentViewController:self];
    [self.scrollPageView setSelectedIndex:self.type animated:YES];
    [bgView addSubview:self.scrollPageView];
    
}

- (NSArray *)setupChildVcAndTitle {
    NSArray *controllerStr = @[@"HYCJMainMyAttentionViewController",@"HYCJMainMyFansViewController"];
    NSArray *titles = @[@"关注",@"粉丝"];
    NSMutableArray *controllers = [NSMutableArray array];
    for (NSInteger index = 0; index < controllerStr.count; index ++) {
        Class class = NSClassFromString(controllerStr[index]);
        HYCJMainMyAttentionViewController *homeListVc = [[class alloc] init];
        homeListVc.title = titles[index];
        [controllers addObject:homeListVc];
    }
    return controllers;
}
- (void)loadUserInfoData{
    [SVProgressHUD show];
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    
    [XZFHttpManager GET:UserInfoUrl parameters:@{@"userId":userId} requestSerializer:NO requestToken:YES success:^(id respondseObject) {
        NSLog(@"--------获取个人信息--------%@",respondseObject);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self setup];
            [SVProgressHUD dismiss];
        });
        
    } failure:^(NSError *error) {
        
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
