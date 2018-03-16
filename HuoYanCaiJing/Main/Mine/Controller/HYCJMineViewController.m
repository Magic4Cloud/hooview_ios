//
//  HYCJMineViewController.m
//  HuoYanCaiJing
//
//  Created by ZPF Mac Pro on 2018/1/7.
//  Copyright © 2018年 shilei. All rights reserved.
//

#import "HYCJMineViewController.h"
#import "HYCJMineTableViewCell.h"
#import "HYCJEditDataViewController.h"
#import "HYCJMyFavoriteViewController.h"
#import "HYCJMineHistoryViewController.h"
#import "HYCJMyBuyViewController.h"
#import "HYCJMyMessageViewController.h"
#import "HYCJMyAttentionViewController.h"
#import "HYCJMySetViewController.h"
#import "HYCJLoginViewController.h"
#import "HYCJApplyHostViewController.h"
#import "HYCJRegistViewController.h"
#import "HYCJLoginViewController.h"


static NSString *identify = @"cell";
@interface HYCJMineViewController ()<UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate>{
    UIView *bgView;
    NSDictionary *dataDic;
//    NSString *headUrl;
}
@property (strong,nonatomic) UITableView *tableView;

@end

@implementation HYCJMineViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    
}
//-(void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO];
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(241, 241, 241, 1.0);
    self.navigationController.delegate = self;
    
    
    _tableView = [[UITableView alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = RGB(241, 241, 241, 1.0);
    _tableView.scrollEnabled = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"HYCJMineTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:identify];
    
    [self.view addSubview:self.tableView];
    [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(-20);
        make.left.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(-50);
    }];
    
    [self setHeaderUI];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginChangeTableViewUI:) name:@"loginChangeTableViewUI" object:nil];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    BOOL tokenBool = [BTToolFormatJudge iSStringNull:token];
    if (tokenBool == NO) {
        [self loadUserInfoData];
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(MeFViewControllerUI:) name:@"MeFViewControllerUI" object:nil];
}

- (void)MeFViewControllerUI:(NSNotification *)notification{
    [self loadUserInfoData];
}

#pragma mark - UINavigationControllerDelegate
// 将要显示控制器
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}

- (void)loginChangeTableViewUI:(NSNotification *)notification{
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    BOOL tokenBool = [BTToolFormatJudge iSStringNull:token];
    if (tokenBool == NO) {
        [self loadUserInfoData];
    }else{
        [self.tableView reloadData];
    }
}
- (void)setHeaderUI{
    
    
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    BOOL tokenBool = [BTToolFormatJudge iSStringNull:token];
    
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 202)];
    bgView.backgroundColor = [UIColor redColor];
    UIImageView *navImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 202)];
    navImg.image = [UIImage imageNamed:@"login_back"];
    [bgView addSubview:navImg];
    
    UIImageView *headerImg = [[UIImageView alloc] initWithFrame:CGRectMake(11.5, 64, 64, 64)];
//    headerImg.image = [UIImage imageNamed:@"icon_face_01"];
    if (tokenBool == NO) {
        [headerImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dataDic[@"headUrl"]]] placeholderImage:[UIImage imageNamed:@"icon_face_01"]];
    }else{
        headerImg.image = [UIImage imageNamed:@"icon_face_01"];
    }
//    [headerImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dataDic[@"headUrl"]]] placeholderImage:[UIImage imageNamed:@"icon_face_01"]];
    headerImg.backgroundColor = RGB(254, 254, 254, 1);
    headerImg.layer.cornerRadius = 32;
    headerImg.clipsToBounds = YES;
    [bgView addSubview:headerImg];
    
    UIButton *headerButton = [[UIButton alloc] initWithFrame:CGRectMake(11.5, 64, 64, 64)];
    [headerButton addTarget:self action:@selector(loginButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:headerButton];
    
    UIButton *setButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - 30-11.5, 25, 35, 35)];
    [setButton setImage:[UIImage imageNamed:@"icon_top_set"] forState:UIControlStateNormal];
    setButton.imageEdgeInsets = UIEdgeInsetsMake(2.5, 2.5, 2.5, 2.5);
    [setButton addTarget:self action:@selector(setButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:setButton];
    
    UIButton *loginButton = [[UIButton alloc] initWithFrame:CGRectMake(89.5, 78.5, 70, 20)];
    if (tokenBool == NO) {
        [loginButton setTitle:[NSString stringWithFormat:@"%@",dataDic[@"nickname"]] forState:UIControlStateNormal];
        loginButton.frame = CGRectMake(89.5, 78.5, 150, 20);
        [loginButton setEnabled:YES];
    }else{
        [loginButton setTitle:@"点击登录" forState:UIControlStateNormal];
        loginButton.frame = CGRectMake(89.5, 78.5, 70, 20);
        [loginButton setEnabled:YES];
    }
    loginButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    loginButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [loginButton setTitleColor:RGB(255, 255, 255, 1) forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(loginButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:loginButton];
    
    UILabel *titleLabelOne = [[UILabel alloc] initWithFrame:CGRectMake(89.5, 102, WIDTH - 165, 20)];
    if (tokenBool == NO) {
        NSString *introduce = [NSString stringWithFormat:@"%@",dataDic[@"introduce"]];
        if ([introduce isEqualToString:@"<null>"]) {
            titleLabelOne.text = @"设置昵称";
        }else{
            titleLabelOne.text = introduce;
        }
    }else{
        titleLabelOne.text = @"火眼让挣钱更简单";
    }
    titleLabelOne.font = [UIFont systemFontOfSize:14];
    titleLabelOne.textColor = RGB(255, 255, 255, 1);
    [bgView addSubview:titleLabelOne];
    
    
    if (tokenBool == NO) {
        
        UIButton *applyButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - 75, 97.5, 64, 21)];
        [applyButton setTitle:@"申请主播" forState:UIControlStateNormal];
        applyButton.titleLabel.font = [UIFont systemFontOfSize:13];
        applyButton.layer.cornerRadius = 10.5;
        applyButton.layer.borderWidth = 1;
        applyButton.layer.borderColor = RGB(248, 231, 28, 1).CGColor;
        [applyButton setTitleColor:RGB(248, 231, 28, 1) forState:UIControlStateNormal];
        [applyButton addTarget:self action:@selector(applyButtonButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:applyButton];
        int anchorAudit = [dataDic[@"anchorAudit"] intValue];
        if (anchorAudit == 0) {
            applyButton.hidden = NO;
            [applyButton setEnabled:YES];
            applyButton.frame = CGRectMake(WIDTH - 81, 97.5, 71, 21);
        }else if (anchorAudit == 2){
            applyButton.hidden = NO;
            [applyButton setEnabled:NO];
            [applyButton setTitle:@"主播" forState:UIControlStateNormal];
            [applyButton setImage:[UIImage imageNamed:@"icon_anchor"] forState:UIControlStateNormal];
        [applyButton setTitleColor:RGB(28, 37, 42, 1) forState:UIControlStateNormal];

            applyButton.frame = CGRectMake(WIDTH - 75, 97.5, 64, 21);
            applyButton.backgroundColor = RGB(248, 231, 28, 1);

        }else{
            applyButton.hidden = YES;
            [applyButton setEnabled:NO];
        }
    
        UILabel *titleLabelThree = [[UILabel alloc] initWithFrame:CGRectMake(89.5, 140, WIDTH - 120, 20)];
        titleLabelThree.text = [NSString stringWithFormat:@"%@ 关注  |  %@ 粉丝",dataDic[@"follow"],dataDic[@"fans"]];
        titleLabelThree.font = [UIFont systemFontOfSize:12];
        titleLabelThree.textColor = RGB(255, 255, 255, 1);
        [bgView addSubview:titleLabelThree];
        
    }else{
        UILabel *titleLabelTwo = [[UILabel alloc] initWithFrame:CGRectMake(89.5, 136.5, 86, 20)];
        titleLabelTwo.text = @"还没有帐号？";
        titleLabelTwo.font = [UIFont systemFontOfSize:14];
        titleLabelTwo.textColor = RGB(255, 255, 255, 1);
//        titleLabelTwo.hidden = YES;
        [bgView addSubview:titleLabelTwo];
        
        UIButton *registerButton = [[UIButton alloc] initWithFrame:CGRectMake(178, 136.5, 58, 20)];
        [registerButton setTitle:@"立即注册" forState:UIControlStateNormal];
        registerButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [registerButton setTitleColor:RGB(248, 231, 28, 1) forState:UIControlStateNormal];
        [registerButton addTarget:self action:@selector(registerButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//        registerButton.hidden = YES;
//        [registerButton setEnabled:NO];
        [bgView addSubview:registerButton];
    }
    
    
    return bgView;

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 202;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HYCJMineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[HYCJMineTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identify];
    }
//    NSArray *imageArr = @[@"icon_mycenter_follow",@"icon_mycenter_fans",@"icon_mycenter_message",@"icon_mycenter_buy",@"icon_mycenter_favorite",@"icon_mycenter_footprint"];
    NSArray *imageArr = @[@"icon_mycenter_follow",@"icon_mycenter_fans",@"icon_mycenter_message",@"icon_mycenter_favorite",@"icon_mycenter_footprint"];

//    NSArray *nameArr = @[@"我的关注",@"我的粉丝",@"我的消息",@"我的购买",@"我的收藏",@"浏览记录"];
    NSArray *nameArr = @[@"我的关注",@"我的粉丝",@"我的消息",@"我的收藏",@"浏览记录"];

    cell.iconImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageArr[indexPath.row]]];
    cell.titleLab.text = [NSString stringWithFormat:@"%@",nameArr[indexPath.row]];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
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
    
    
    switch (indexPath.row) {
        case 0:
        {
            HYCJMyAttentionViewController *HYCJVC = [[HYCJMyAttentionViewController alloc] init];
            HYCJVC.type = 0;
            HYCJVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:HYCJVC animated:YES];
        }
            break;
        case 1:
        {
            HYCJMyAttentionViewController *HYCJVC = [[HYCJMyAttentionViewController alloc] init];
            HYCJVC.type = 1;
            HYCJVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:HYCJVC animated:YES];
        }
            break;
        case 2:
        {
            HYCJMyMessageViewController *HYCJVC = [[HYCJMyMessageViewController alloc] init];
            HYCJVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:HYCJVC animated:YES];
        }
            
            break;
//        case 3:
//        {
//            HYCJMyBuyViewController *HYCJVC = [[HYCJMyBuyViewController alloc] init];
//            HYCJVC.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:HYCJVC animated:YES];
//        }
//            
//            break;
        case 3:
        {
            HYCJMyFavoriteViewController *HYCJVC = [[HYCJMyFavoriteViewController alloc] init];
            HYCJVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:HYCJVC animated:YES];
            
        }
            
            break;
        case 4:
        {
            HYCJMineHistoryViewController *HYCJVC = [[HYCJMineHistoryViewController alloc] init];
            HYCJVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:HYCJVC animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)setButtonAction:(UIButton*)sender{
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
    HYCJMySetViewController *HYCJ = [[HYCJMySetViewController alloc] init];
    HYCJ.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:HYCJ animated:YES];
}
- (void)loginButtonAction:(UIButton *)sender{
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    BOOL tokenBool = [BTToolFormatJudge iSStringNull:token];
    if (tokenBool == YES) {
        HYCJLoginViewController *HYCJ = [[HYCJLoginViewController alloc] init];
        HYCJ.hidesBottomBarWhenPushed = YES;
        [self presentViewController:HYCJ animated:NO completion:nil];
    }else{
        HYCJEditDataViewController *HYCJVC = [[HYCJEditDataViewController alloc] init];
        XZFNavigationController *nav=[[XZFNavigationController alloc]initWithRootViewController:HYCJVC];
        [self presentViewController :nav animated:NO completion:nil];
    }
    
}
- (void)registerButtonAction:(UIButton *)sender{
    
    HYCJRegistViewController *HYCJVC = [[HYCJRegistViewController alloc] init];
    XZFNavigationController *nav=[[XZFNavigationController alloc]initWithRootViewController:HYCJVC];
    HYCJVC.mineType = 2;
    [self presentViewController :nav animated:NO completion:nil];
}
- (void)applyButtonButtonAction:(UIButton *)sender{
    HYCJApplyHostViewController *HYCJ = [[HYCJApplyHostViewController alloc] init];
    HYCJ.hidesBottomBarWhenPushed = YES;
    [self presentViewController:HYCJ animated:NO completion:nil];
}
- (void)loadUserInfoData{
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    
    [XZFHttpManager GET:UserInfoUrl parameters:@{@"userId":userId} requestSerializer:NO requestToken:YES success:^(id respondseObject) {
        NSLog(@"--------获取个人信息--------%@",respondseObject);
        dataDic = respondseObject[@"userInfo"];
        NSString *nickname = [NSString stringWithFormat:@"%@",respondseObject[@"userInfo"][@"nickname"]];
        [[NSUserDefaults standardUserDefaults] setObject:nickname forKey:@"nickname"];
        [self.tableView reloadData];
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
