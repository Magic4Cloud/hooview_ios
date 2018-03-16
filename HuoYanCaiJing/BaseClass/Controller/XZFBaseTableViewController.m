//
//  XZFBaseTableViewController.m
//  XueZhiFei
//
//  Created by ZPF Mac Pro on 2017/11/3.
//  Copyright © 2017年 ZPF Mac Pro. All rights reserved.
//

#import "XZFBaseTableViewController.h"

@interface XZFBaseTableViewController ()<UIGestureRecognizerDelegate>

/**导航左边图片*/
@property (nonatomic, copy) NSString *leftBtnImg;
/**导航右边图片*/
@property (nonatomic, copy) NSString *rightBtnImg;

@property (nonatomic, copy) NSString *titleColor;


@end

@implementation XZFBaseTableViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [SVProgressHUD dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStatusDidChange:) name:@"WYXNetworkStatusDidChangedNote" object:nil];
    
    // Do any additional setup after loading the view.
    
    //self.automaticallyAdjustsScrollViewInsets = YES;
    
    self.returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
    self.returnKeyHandler.lastTextFieldReturnKeyType = UIReturnKeyDone;
    
    //导航栏下的线
    self.navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    
    // 当当前控制器是根控制器时，不可以侧滑返回，所以不能使其触发手势
    if(self.navigationController.childViewControllers.count == 1)
    {
        
    }
    
    
    
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
    self.leftBtnImg = @"d2_fanhui";
    [self.leftButton setImage:[UIImage imageNamed:@"d2_fanhui"] forState:UIControlStateNormal];
    [self.leftButton addTarget:self action:@selector(leftButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftButton];
}

- (void)leftButtonClicked {
    [self popViewController];
}

- (void)popViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pushToViewController:(UIViewController *)controller {
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark 添加导航栏右边边按钮
- (void)setupRightNavigationBarWithTitle:(NSString *)title image:(NSString *)image frame:(CGRect)frame color:(UIColor *)color{
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightBtn.frame = frame;
    self.rightBtn.titleLabel.font = [UIFont pingfangRegularFontWithSize:15];
    self.rightBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    if (title) {
        [self.rightBtn setTitle:title forState:UIControlStateNormal];
    }
    if (image) {
        self.rightBtnImg = image;
    }
    [self.rightBtn setTitleColor:color forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
}



- (void)setSelectedRightBtnImg:(NSString *)selectedRightBtnImg {
    [self.rightBtn setImage:[UIImage imageNamed:selectedRightBtnImg] forState:UIControlStateSelected];
}

#pragma mark 设置左右导航图片和文字颜色
//- (void)setRightBtnImg:(NSString *)rightBtnImg  {
//
//    [self.rightBtn setImage:[UIImage imageNamed:rightBtnImg forState:UIControlStateNormal];
//    [self.rightBtn setTitleColor:[UIColor colorWithHexString:model.navTextColor] forState:UIControlStateNormal];
//}
//
//- (void)setLeftBtnImg:(NSString *)leftBtnImg {
//    CDSkinModel *model = [[CDSkinManager sharedInstence] getCurrentSkinModel];
//    [self.leftButton setImage:[UIImage imageNamed:[model completeImgNameWithImgName:leftBtnImg]] forState:UIControlStateNormal];
//}

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
