//
//  XZFTabBarController.m
//  XueZhiFei
//
//  Created by ZPF Mac Pro on 2017/11/3.
//  Copyright © 2017年 ZPF Mac Pro. All rights reserved.
//

#import "XZFTabBarController.h"
#import "XZFNavigationController.h"

@interface XZFTabBarController ()<UITabBarControllerDelegate>

@property (nonatomic, strong) NSMutableArray *controllers;

@end

@implementation XZFTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
    
    [self creatViewController];
    
    [self userSkinModelToCreatViewColor];
    
}

#pragma mark 皮肤改变回调
- (void)userSkinModelToCreatViewColor {
    
    NSArray *img = @[@"tab_Live",@"tab_news",@"tab_mycenter"];
    NSArray *selectImg = @[@"tab_Live_sure",@"tab_news_sure",@"tab_mycenter_sure"];
    NSInteger index = 0;
    for (UITableViewController *baseVC in self.controllers) {
        // 设置子控制器的tabBarItem图片
        baseVC.tabBarItem.image = [UIImage imageNamed:img[index]];
        // 禁用图片渲染
        baseVC.tabBarItem.selectedImage = [[UIImage imageNamed:selectImg[index]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        // 设置文字的样式
        [baseVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:RGB(131, 131, 131, 1),NSFontAttributeName : [UIFont pingfangRegularFontWithSize:11]} forState:UIControlStateNormal];
        [baseVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:RGB(234, 72, 69, 1),NSFontAttributeName : [UIFont pingfangRegularFontWithSize:11]} forState:UIControlStateSelected];
        index ++;
    }
    //self.customTabBar.buttonImg = [model completeImgNameWithImgName:@"zhizao"];
}


- (NSMutableArray *)controllers {
    if (!_controllers) {
        _controllers = [NSMutableArray array];
    }
    return _controllers;
}

#pragma mark 创建控制器
- (void) creatViewController {
    NSArray *controllerStr = @[@"HYCJHomeViewController",@"HYCJCriticalViewController",@"HYCJMineViewController"];
    NSArray *title = @[@"在线直播",@"火眼金睛",@"个人中心"];
    NSInteger index = 0;
    for (NSString *str in controllerStr) {
        
        Class class = NSClassFromString(str);
        UIViewController *baseVC = [[class alloc] init];
        [self addChildVc:baseVC title:title[index]];
        [self.controllers addObject:baseVC];
        index ++;
        
        
    }
}

/**
 *  添加一个子控制器
 *
 *  @param childVc       子控制器
 *  @param title         标题
 */
- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title{
    // 设置子控制器的文字(可以设置tabBar和navigationBar的文字)
    childVc.title = title;
    [childVc.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0,-2)];
    //设置NavigationBar
    XZFNavigationController *navigationVc = [[XZFNavigationController alloc] initWithRootViewController:childVc];
    [self addChildViewController:navigationVc];
}


#pragma mark UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if ([viewController.tabBarItem.title isEqualToString:@"我的"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:WYXRefreshPersonDataNote object:nil];
    }
    return YES;
}


@end
