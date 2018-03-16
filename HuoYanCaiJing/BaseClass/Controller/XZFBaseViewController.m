//
//  XZFBaseViewController.m
//  XueZhiFei
//
//  Created by ZPF Mac Pro on 2017/11/3.
//  Copyright © 2017年 ZPF Mac Pro. All rights reserved.
//

#import "XZFBaseViewController.h"

@interface XZFBaseViewController ()<UIGestureRecognizerDelegate>

/**导航左边图片*/
@property (nonatomic, copy) NSString *leftBtnImg;
/**导航右边图片*/
@property (nonatomic, copy) NSString *rightBtnImg;

@property (nonatomic, copy) NSString *titleColor;


@end

@implementation XZFBaseViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 导航栏背景颜色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_back"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setBackgroundColor:UIColorFromHex(0x2EA2FD)];
    // 导航栏标题字体颜色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont pingfangFontWithSize:18],NSForegroundColorAttributeName:UIColorFromHex(0xFFFFFF)}];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@""
                                                                style:UIBarButtonItemStylePlain
                                                               target:nil
                                                               action:nil];
    
    self.navigationController.navigationBar.backIndicatorImage = [UIImage imageNamed:@"return_white.png"];
    self.navigationController.navigationBar.backIndicatorTransitionMaskImage = [UIImage imageNamed:@"return_white.png"];
    self.navigationItem.backBarButtonItem = backItem;
}



- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [SVProgressHUD dismiss];
}

- (void)back{
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        [self dismissViewControllerAnimated:YES completion:^{
            ;
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //self.automaticallyAdjustsScrollViewInsets = YES;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bac_a12"]forBarMetrics:UIBarMetricsDefault];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStatusDidChange:) name:WYXNetworkStatusDidChangedNote object:nil];
    
    self.returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
    self.returnKeyHandler.lastTextFieldReturnKeyType = UIReturnKeyDone;
    
    //导航栏下的线
    self.navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    self.navBarHairlineImageView.hidden = YES;
    // 当当前控制器是根控制器时，不可以侧滑返回，所以不能使其触发手势
    if(self.navigationController.childViewControllers.count == 1)
    {
        
    }
    
    self.view.backgroundColor = RGB(242, 244, 245, 1.0);
    
    //策划手势代理
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
}

- (void)networkStatusDidChange:(NSNotification *)note {
    NSNumber *status = (NSNumber *)note.object;
    if (status.integerValue == 0 || status.integerValue == -1) {
        [SVProgressHUD showErrorWithStatus:@"你的网络状况有点糟糕"];
    }
}


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    // 当当前控制器是根控制器时，不可以侧滑返回，所以不能使其触发手势
    if(self.navigationController.childViewControllers.count == 1)
    {
        return NO;
    }
    return YES;
}


#pragma mark 拿到导航栏下面的线
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}


#pragma mark 添加导航栏左边按钮
- (void)setupNavigationBar {
    self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftButton.frame = CGRectMake(0, 0, 23/2, 38/2);
    self.leftButton.backgroundColor = [UIColor clearColor];
    self.leftBtnImg = @"return_white";
    [self.leftButton setImage:[UIImage imageNamed:@"return_white"] forState:UIControlStateNormal];
    [self.leftButton addTarget:self action:@selector(leftButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftButton];
}

- (void)setupNavigationBarWithImage:(NSString *)imageName {
    self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftButton.frame = CGRectMake(0, 0, 23/2, 38/2);
    self.leftButton.backgroundColor = [UIColor clearColor];
    self.leftBtnImg = imageName;
    [self.leftButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [self.leftButton addTarget:self action:@selector(leftButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftButton];
}

- (void)leftButtonClicked {
    [self popViewController];
}

- (void)popViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pushToViewController:(XZFBaseViewController *)controller {
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark 添加导航栏右边边按钮
- (void)setupRightNavigationBarWithTitle:(NSString *)title image:(NSString *)image frame:(CGRect)frame color:(UIColor *)color{
    
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightBtn.frame = frame;
    self.rightBtn.titleLabel.font = [UIFont pingfangRegularFontWithSize:15];
    
    if (title) {
        [self.rightBtn setTitle:title forState:UIControlStateNormal];
        
    }
    
    self.rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    
    if (image) {
        self.rightBtnImg = image;
    }
    [self.rightBtn setTitleColor:color forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
}

#pragma mark 添加导航栏右边边按钮
- (void)setupRightNavigationBarWithTitle:(NSString *)title selectedTitle:(NSString *)selectesTitle frame:(CGRect)frame color:(UIColor *)color{
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.rightBtn.titleLabel.font = [UIFont pingfangFontWithSize:15];
    
    self.rightBtn.frame = frame;
    
    if (title) {
        [self.rightBtn setTitle:title forState:UIControlStateNormal];
        
    }
    
    if (selectesTitle) {
        [self.rightBtn setTitle:selectesTitle forState:UIControlStateSelected];
    }
    
    [self.rightBtn setTitleColor:color forState:UIControlStateNormal];
    
    
    
    [self.rightBtn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
}



- (void)setSelectedRightBtnImg:(NSString *)selectedRightBtnImg {
    [self.rightBtn setImage:[UIImage imageNamed:selectedRightBtnImg] forState:UIControlStateSelected];
}

#pragma mark 设置左右导航图片和文字颜色
- (void)setRightBtnImg:(NSString *)rightBtnImg  {
    
    [self.rightBtn setImage:[UIImage imageNamed:rightBtnImg] forState:UIControlStateNormal];
    
}

- (void)setLeftBtnImg:(NSString *)leftBtnImg {
    
    [self.leftButton setImage:[UIImage imageNamed:leftBtnImg] forState:UIControlStateNormal];
}

- (void)rightBtnClicked:(UIButton *)sender{
    
}

#pragma mark 返回指定页面
- (BOOL) popToViewController:(NSString *)controller {
    NSArray *controllers = self.navigationController.viewControllers;
    for (UIViewController *VC in controllers) {
        if ([NSStringFromClass([VC class]) isEqualToString:controller]) {
            [self.navigationController popToViewController:VC animated:YES];
            return YES;
        }
    }
    return NO;
}

- (BOOL)popToViewControllerWithNum:(NSInteger)num{
    NSArray *controllers = self.navigationController.viewControllers;
    NSInteger popIndex = controllers.count - num - 1;
    if (popIndex >= 0) {
        [self.navigationController popToViewController:controllers[popIndex] animated:YES];
        return YES;
    }
    return NO;
}



@end
