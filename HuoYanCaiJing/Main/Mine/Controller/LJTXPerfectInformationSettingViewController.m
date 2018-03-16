//
//  LJTXPerfectInformationSettingViewController.m
//  LeJuTianXia
//
//  Created by ZPF Mac Pro on 2018/1/26.
//  Copyright © 2018年 shilei. All rights reserved.
//

#import "LJTXPerfectInformationSettingViewController.h"

@interface LJTXPerfectInformationSettingViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textTF;

@end

@implementation LJTXPerfectInformationSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.titleStr;
    [self setupNavigationBar];
    self.textTF.text = self.contentStr;
    self.textTF.placeholder = self.titleStr;
    
    UIButton *confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 21)];
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    confirmButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [confirmButton addTarget:self action:@selector(confirmButtonFinish) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *confirmButtonItem = [[UIBarButtonItem alloc] initWithCustomView:confirmButton];
    [self.navigationItem setRightBarButtonItem:confirmButtonItem];
}

- (void)confirmButtonFinish{
    
    if (self.textTF.text.length==0) {
        [SVProgressHUD setMinimumDismissTimeInterval:1];
        [SVProgressHUD showErrorWithStatus:@"请输入内容"];
        return;
    }
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    NSString *postStr = @"";
    if (self.cellInt == 1) {
        postStr = @"nickname";
        if (self.textTF.text.length > 10) {
            [SVProgressHUD setMinimumDismissTimeInterval:1];
            [SVProgressHUD showErrorWithStatus:@"昵称最多10个字符"];
            return;
        }
    }else if (self.cellInt == 3){
        postStr = @"region";
        if (self.textTF.text.length > 50) {
            [SVProgressHUD setMinimumDismissTimeInterval:1];
            [SVProgressHUD showErrorWithStatus:@"地区最多50个字符"];
            return;
        }
    }else{
        if (self.textTF.text.length > 225) {
            [SVProgressHUD setMinimumDismissTimeInterval:1];
            [SVProgressHUD showErrorWithStatus:@"介绍最多225个字符"];
            return;
        }
        postStr = @"introduce";
    }
    [XZFHttpManager POST:UserUpdateUrl parameters:@{@"userId":userId,postStr:self.textTF.text} requestSerializer:NO requestToken:YES success:^(id respondseObject) {
        
        NSLog(@"----修改上传-----%@",respondseObject);
        [SVProgressHUD setMinimumDismissTimeInterval:1];
        [SVProgressHUD showSuccessWithStatus:@"修改成功"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter]postNotificationName:@"MeFViewControllerUI" object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"HYCJEditDataViewControllerUI" object:nil userInfo:nil];
            
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    } failure:^(NSError *error) {
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
