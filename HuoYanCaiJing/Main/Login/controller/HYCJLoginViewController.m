//
//  HYCJLoginViewController.m
//  HuoYanCaiJing
//
//  Created by ZPF Mac Pro on 2018/1/13.
//  Copyright © 2018年 shilei. All rights reserved.
//

#import "HYCJLoginViewController.h"
#import "HYCJForgetAViewController.h"
#import "HYCJRegistViewController.h"

@interface HYCJLoginViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *forgetButtonHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconW;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

@end

@implementation HYCJLoginViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageHeight.constant = 243*KHEIGHT_Scale;
    self.forgetButtonHeight.constant = 70*KHEIGHT_Scale;
    self.backHeight.constant = 30*KHEIGHT_Scale;
    self.iconHeight.constant = 70*KHEIGHT_Scale;
    self.phoneHeight.constant = 42*KHEIGHT_Scale;
    self.iconH.constant = 90*KHEIGHT_Scale;
    self.iconW.constant = 90*KHEIGHT_Scale;
    self.iconImg.layer.cornerRadius =15*KWidth_Scale;
    self.iconImg.layer.borderWidth = 2.5;
    self.iconImg.layer.borderColor = RGB(255, 255, 255, 1).CGColor;
}


- (IBAction)registeredButtonAction:(UIButton *)sender {
    HYCJRegistViewController *HYCJVC = [[HYCJRegistViewController alloc] init];
    XZFNavigationController *nav=[[XZFNavigationController alloc]initWithRootViewController:HYCJVC];
    HYCJVC.mineType = 2;
    [self presentViewController :nav animated:NO completion:nil];
}

- (IBAction)forgetButtonAction:(UIButton *)sender {
    HYCJForgetAViewController *HYCJVC = [[HYCJForgetAViewController alloc] init];
//    [self pushToViewController:HYCJVC];
    XZFNavigationController *nav=[[XZFNavigationController alloc]initWithRootViewController:HYCJVC];
    [self presentViewController :nav animated:NO completion:nil];
}

- (IBAction)loginButtonAction:(UIButton *)sender {
    if (_phoneTF.text.length==0) {
        [SVProgressHUD setMinimumDismissTimeInterval:1];
        [SVProgressHUD showErrorWithStatus:@"请输入手机号"];
        return;
    }
    
    if (![WYXFactory isMobileNumber:self.phoneTF.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码"];
        return;
    }
    if (_passwordTF.text.length==0) {
        [SVProgressHUD setMinimumDismissTimeInterval:1];
        [SVProgressHUD showErrorWithStatus:@"请输入密码"];
        return;
    }
    
    if (![WYXFactory validatePassword:self.passwordTF.text]) {
        [SVProgressHUD setMinimumDismissTimeInterval:1];
        [SVProgressHUD showErrorWithStatus:@"请输入6-20位密码"];
        return;
    }
    [SVProgressHUD show];
    [XZFHttpManager POST:LoginUrl parameters:@{@"phone":self.phoneTF.text,@"password":self.passwordTF.text} requestSerializer:NO requestToken:NO success:^(id respondseObject) {
        
        NSLog(@"--登录---%@",respondseObject);
       
        
//        [self dismissViewControllerAnimated:NO completion:nil];
//        
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"loginChangeTableViewUI" object:nil userInfo:nil];
        [[EMClient sharedClient] loginWithUsername:self.phoneTF.text
                                          password:self.passwordTF.text
                                        completion:^(NSString *aUsername, EMError *aError) {
                                            if (!aError) {
                                                NSLog(@"登录成功");
                                                NSString *token = [NSString stringWithFormat:@"%@",respondseObject[@"token"]];
                                                [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"token"];
                                                NSString *userId = [NSString stringWithFormat:@"%@",respondseObject[@"userId"]];
                                                [[NSUserDefaults standardUserDefaults] setObject:userId forKey:@"userId"];
                                                
                                                [[NSUserDefaults standardUserDefaults] setObject:self.phoneTF.text forKey:@"loginPhone"];
                                                
                                                [[EMClient sharedClient].options setIsAutoLogin:YES];//设置自动登录
                                                [SVProgressHUD dismiss];
                                                MainTabBarController *vc = [[MainTabBarController alloc] init];
                                                self.view.window.rootViewController = vc;
                                            } else {
                                                [SVProgressHUD setMinimumDismissTimeInterval:1];
                                                [SVProgressHUD showErrorWithStatus:@"登录失败"];
                                                NSLog(@"登录失败");
                                            }
                                        }];
        
    } failure:^(NSError *error) {
        
    }];
    
}

- (IBAction)backButtonAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
