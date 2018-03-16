//
//  HYCJOpenAccountViewController.m
//  HuoYanCaiJing
//
//  Created by ZPF Mac Pro on 2018/1/15.
//  Copyright © 2018年 shilei. All rights reserved.
//

#import "HYCJOpenAccountViewController.h"
#import "HYCJOpenAccountFinishViewController.h"

@interface HYCJOpenAccountViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconW;
@property (weak, nonatomic) IBOutlet UIButton *applyButton;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;

@end

@implementation HYCJOpenAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageHeight.constant = 243*KHEIGHT_Scale;
    self.backHeight.constant = 30*KHEIGHT_Scale;
    self.iconHeight.constant = 64*KHEIGHT_Scale;
    self.phoneHeight.constant = 42*KHEIGHT_Scale;
    self.iconH.constant = 90*KHEIGHT_Scale;
    self.iconW.constant = 90*KHEIGHT_Scale;
    self.iconImg.layer.borderWidth = 2.5;
    self.iconImg.layer.borderColor = RGB(255, 255, 255, 1).CGColor;
    
    
}
- (IBAction)applyButtonAction:(UIButton *)sender {
    
    if (self.nameTF.text.length==0) {
        [SVProgressHUD setMinimumDismissTimeInterval:1];
        [SVProgressHUD showErrorWithStatus:@"请输入真实姓名"];
        return;
    }
    
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
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    
    [XZFHttpManager POST:ApplyOpenUrl parameters:@{@"userName":self.nameTF.text,@"mobile":self.phoneTF.text} requestSerializer:YES requestToken:YES success:^(id respondseObject) {
        NSLog(@"-----申请开户----%@",respondseObject);
        HYCJOpenAccountFinishViewController *HYCJVC = [[HYCJOpenAccountFinishViewController alloc] init];
        XZFNavigationController *nav=[[XZFNavigationController alloc]initWithRootViewController:HYCJVC];
        [self presentViewController :nav animated:NO completion:nil];
        
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
