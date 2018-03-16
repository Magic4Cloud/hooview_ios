//
//  HYCJRegistViewController.m
//  HuoYanCaiJing
//
//  Created by ZPF Mac Pro on 2018/1/14.
//  Copyright © 2018年 shilei. All rights reserved.
//

#import "HYCJRegistViewController.h"
#import "HYCJAgreementViewController.h"
#import "HYCJForgetBViewController.h"

@interface HYCJRegistViewController (){
    NSInteger type;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wideNumber;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UIButton *YesOrNoButton;

@end

@implementation HYCJRegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新用户注册";
    type = 1;
    self.wideNumber.constant = 130*KWidth_Scale;
    UIButton *backmainButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 52/3, 52/3)];
    [backmainButton setImage:[UIImage imageNamed:@"return_white"] forState:UIControlStateNormal];
    [backmainButton addTarget:self action:@selector(backmain) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backmainItem = [[UIBarButtonItem alloc] initWithCustomView:backmainButton];
    [self.navigationItem setLeftBarButtonItem:backmainItem];
}
- (IBAction)nextButtonAction:(UIButton *)sender {
    
    if (self.phoneTF.text.length==0) {
        [SVProgressHUD setMinimumDismissTimeInterval:1];
        [SVProgressHUD showErrorWithStatus:@"请输入手机号"];
        return;
    }
    
    if (![WYXFactory isMobileNumber:self.phoneTF.text]) {
        [SVProgressHUD setMinimumDismissTimeInterval:1];
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码"];
        return;
    }
    if (type == 1) {
        [SVProgressHUD showErrorWithStatus:@"请同意用户协议"];
        [SVProgressHUD setMinimumDismissTimeInterval:1];
        return;
    }
    HYCJForgetBViewController *HYCJVC = [[HYCJForgetBViewController alloc] init];
    XZFNavigationController *nav=[[XZFNavigationController alloc]initWithRootViewController:HYCJVC];
    HYCJVC.titleStr = @"新用户注册";
    HYCJVC.phoneStr = self.phoneTF.text;
    HYCJVC.type = 1;
    HYCJVC.mineType = 2;
    [self presentViewController :nav animated:NO completion:nil];
}
- (IBAction)agreementButtonAction:(UIButton *)sender {
    HYCJAgreementViewController *HYCJVC = [[HYCJAgreementViewController alloc] init];
    XZFNavigationController *nav=[[XZFNavigationController alloc]initWithRootViewController:HYCJVC];
    [self presentViewController :nav animated:NO completion:nil];
}
- (IBAction)YesOrNoButtonAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        type = 2;
    }else{
        type = 1;
    }
}

- (void)backmain{
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
