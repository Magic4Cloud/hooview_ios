//
//  XZFBaseTableViewController.h
//  XueZhiFei
//
//  Created by ZPF Mac Pro on 2017/11/3.
//  Copyright © 2017年 ZPF Mac Pro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IQKeyboardReturnKeyHandler.h"

@interface XZFBaseTableViewController : UITableViewController

@property (nonatomic,copy) NSString *selectedRightBtnImg;
/**导航左边按钮*/
@property (nonatomic, strong) UIButton *leftButton;
/**导航右边按钮*/
@property (nonatomic, strong) UIButton *rightBtn;

/*导航栏下面的线条*/
@property (nonatomic, strong) UIImageView *navBarHairlineImageView;

/**处理键盘事件*/
@property (nonatomic, strong) IQKeyboardReturnKeyHandler  *returnKeyHandler;

@property (strong,nonatomic) NSMutableArray *smallImages;

@property (strong,nonatomic) NSMutableArray *dataImages;

@property (nonatomic, assign) NSInteger imageSize;

/*!
 @brief 导航栏左边返回按钮
 */
- (void)setupNavigationBar;

- (void)popViewController;

/*!
 @brief push到指定页面
 */
- (void) pushToViewController:(UIViewController *)controller;

/*!
 @brief 导航栏右边返回按钮
 */
- (void)setupRightNavigationBarWithTitle:(NSString *)title image:(NSString *)image frame:(CGRect)frame color:(UIColor *)color;

/*!
 @brief 导航栏右边返回按钮点击
 */
- (void)rightBtnClicked:(UIButton *)sender;

/*!
 @brief 返回指定页面
 @param controller 指定页面控制器字符串
 @return YES 成功返回 NO 失败
 */
- (BOOL) popToViewController:(NSString *)controller;

/*!
 @brief 返回指定页面
 @param num 指定页面相对于当前页面的层级数量 eg：A  B  C 从Apop到C num为2
 @return YES 成功返回 NO 失败
 */
- (BOOL)popToViewControllerWithNum:(NSInteger)num;


@end
