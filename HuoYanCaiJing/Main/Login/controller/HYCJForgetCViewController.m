//
//  HYCJForgetCViewController.m
//  HuoYanCaiJing
//
//  Created by ZPF Mac Pro on 2018/1/14.
//  Copyright © 2018年 shilei. All rights reserved.
//

#import "HYCJForgetCViewController.h"
#import "HYCJLoginViewController.h"

@interface HYCJForgetCViewController ()
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

@end

@implementation HYCJForgetCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.titleStr;
    UIButton *backmainButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 52/3, 52/3)];
    [backmainButton setImage:[UIImage imageNamed:@"return_white"] forState:UIControlStateNormal];
    [backmainButton addTarget:self action:@selector(backmain) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backmainItem = [[UIBarButtonItem alloc] initWithCustomView:backmainButton];
    [self.navigationItem setLeftBarButtonItem:backmainItem];
}
- (IBAction)finishButtonAction:(UIButton *)sender {
    
    if (self.passwordTF.text.length==0) {
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
    if (self.type == 1) {
        
        [XZFHttpManager POST:RegisterUrl parameters:@{@"phone":self.phoneStr,@"password":self.passwordTF.text,@"pwkey":self.pwkey} requestSerializer:NO  requestToken:NO success:^(id respondseObject) {
            
            NSLog(@"--注册---%@",respondseObject);
            if (self.mineType == 2) {
                [self loginAction];
            }else{
                [SVProgressHUD dismiss];
                HYCJLoginViewController *target = [[HYCJLoginViewController alloc] init];
                
                UIViewController *vc = self.presentingViewController;
                
                if (!vc.presentingViewController) return;
                
                while (![vc isKindOfClass:[target class]])  {
                    vc = vc.presentingViewController;
                }
                
                [vc dismissViewControllerAnimated:NO completion:nil];
            }
            
            
        } failure:^(NSError *error) {
            
        }];
    }else{
        
        [XZFHttpManager POST:ForgetUrl parameters:@{@"phone":self.phoneStr,@"password":self.passwordTF.text,@"pwkey":self.pwkey} requestSerializer:NO requestToken:NO success:^(id respondseObject) {
            
            NSLog(@"--修改密码---%@",respondseObject);
            HYCJLoginViewController *target = [[HYCJLoginViewController alloc] init];
            
            UIViewController *vc = self.presentingViewController;
            
            if (!vc.presentingViewController) return;
            
            while (![vc isKindOfClass:[target class]])  {
                vc = vc.presentingViewController;
            }
            
            [vc dismissViewControllerAnimated:NO completion:nil];
            
        } failure:^(NSError *error) {
            
        }];
    }
    
}
- (IBAction)hiddenPasswordAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.passwordTF.secureTextEntry = YES;
    }else{
        self.passwordTF.secureTextEntry = NO;
    }
    
}

- (void)loginAction{
    [XZFHttpManager POST:LoginUrl parameters:@{@"phone":self.phoneStr,@"password":self.passwordTF.text} requestSerializer:NO requestToken:NO success:^(id respondseObject) {
        
        NSLog(@"--登录---%@",respondseObject);
        
        //        [self dismissViewControllerAnimated:NO completion:nil];
        //
        //        [[NSNotificationCenter defaultCenter]postNotificationName:@"loginChangeTableViewUI" object:nil userInfo:nil];
        [[EMClient sharedClient] loginWithUsername:self.phoneStr
                                          password:self.passwordTF.text
                                        completion:^(NSString *aUsername, EMError *aError) {
                                            if (!aError) {
                                                NSLog(@"登录成功");
                                                [SVProgressHUD dismiss];
                                                NSString *token = [NSString stringWithFormat:@"%@",respondseObject[@"token"]];
                                                [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"token"];
                                                NSString *userId = [NSString stringWithFormat:@"%@",respondseObject[@"userId"]];
                                                [[NSUserDefaults standardUserDefaults] setObject:userId forKey:@"userId"];
                                                
                                                [[NSUserDefaults standardUserDefaults] setObject:self.phoneStr forKey:@"loginPhone"];
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
