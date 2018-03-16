//
//  HYCJModifyPasswordBViewController.m
//  HuoYanCaiJing
//
//  Created by ZPF Mac Pro on 2018/1/13.
//  Copyright © 2018年 shilei. All rights reserved.
//

#import "HYCJModifyPasswordBViewController.h"
#import "HYCJMySetViewController.h"

@interface HYCJModifyPasswordBViewController ()
@property (weak, nonatomic) IBOutlet UITextField *passwordOneTf;
@property (weak, nonatomic) IBOutlet UITextField *passwordTwoTF;

@end

@implementation HYCJModifyPasswordBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码";
    [self setupNavigationBar];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)saveButtonAction:(UIButton *)sender {
    if (self.passwordOneTf.text.length==0) {
        [SVProgressHUD setMinimumDismissTimeInterval:1];
        [SVProgressHUD showErrorWithStatus:@"请输入新密码"];
        return;
    }
    if (![WYXFactory validatePassword:self.passwordOneTf.text]) {
        [SVProgressHUD setMinimumDismissTimeInterval:1];
        [SVProgressHUD showErrorWithStatus:@"请输入6-20位密码"];
        return;
    }
    if (self.passwordTwoTF.text.length==0) {
        [SVProgressHUD setMinimumDismissTimeInterval:1];
        [SVProgressHUD showErrorWithStatus:@"请确认密码"];
        return;
    }
    if (![self.passwordTwoTF.text isEqualToString:self.passwordOneTf.text]) {
        [SVProgressHUD setMinimumDismissTimeInterval:1];
        [SVProgressHUD showErrorWithStatus:@"确认密码输入错误"];
        return;
    }
    [XZFHttpManager POST:ForgetUrl parameters:@{@"phone":self.phoneStr,@"password":self.passwordOneTf.text,@"pwkey":self.pwkey} requestSerializer:NO requestToken:NO success:^(id respondseObject) {
        
        NSLog(@"--修改密码---%@",respondseObject);
//        HYCJMySetViewController *HYCJVC = [[HYCJMySetViewController alloc] init];
//        [self.navigationController popToViewController:HYCJVC animated:YES];
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[HYCJMySetViewController class]]) {
                HYCJMySetViewController *A =(HYCJMySetViewController *)controller;
                [self.navigationController popToViewController:A animated:YES];
            }
        }
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
