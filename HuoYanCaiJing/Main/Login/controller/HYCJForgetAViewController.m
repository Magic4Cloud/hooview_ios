//
//  HYCJForgetAViewController.m
//  HuoYanCaiJing
//
//  Created by ZPF Mac Pro on 2018/1/14.
//  Copyright © 2018年 shilei. All rights reserved.
//

#import "HYCJForgetAViewController.h"
#import "HYCJForgetBViewController.h"

@interface HYCJForgetAViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;

@end

@implementation HYCJForgetAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"密码找回";
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
    
    HYCJForgetBViewController *HYCJVC = [[HYCJForgetBViewController alloc] init];
    //    [self pushToViewController:HYCJVC];
    XZFNavigationController *nav=[[XZFNavigationController alloc]initWithRootViewController:HYCJVC];
    HYCJVC.titleStr = @"密码找回";
    HYCJVC.phoneStr = self.phoneTF.text;
    HYCJVC.type = 2;
    [self presentViewController :nav animated:NO completion:nil];
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
