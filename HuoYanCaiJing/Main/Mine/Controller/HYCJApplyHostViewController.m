//
//  HYCJApplyHostViewController.m
//  HuoYanCaiJing
//
//  Created by ZPF Mac Pro on 2018/1/16.
//  Copyright © 2018年 shilei. All rights reserved.
//

#import "HYCJApplyHostViewController.h"
#import "HYCJApplyHostSeccessViewController.h"

@interface HYCJApplyHostViewController ()
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

@implementation HYCJApplyHostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageHeight.constant = 243*KHEIGHT_Scale;
    self.backHeight.constant = 30*KHEIGHT_Scale;
    self.iconHeight.constant = 64*KHEIGHT_Scale;
    self.phoneHeight.constant = 42*KHEIGHT_Scale;
    self.iconH.constant = 90*KHEIGHT_Scale;
    self.iconW.constant = 90*KHEIGHT_Scale;
    self.iconImg.layer.cornerRadius = 15*KWidth_Scale;
    self.iconImg.layer.borderWidth = 2.5;
    self.iconImg.layer.borderColor = RGB(255, 255, 255, 1).CGColor;
    
}
- (IBAction)backButtonAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
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

    [XZFHttpManager POST:UserApplyanchorUrl parameters:@{@"userId":userId,@"username":self.nameTF.text,@"phone":self.phoneTF.text} requestSerializer:YES requestToken:YES success:^(id respondseObject) {
        NSLog(@"-----申请主播----%@",respondseObject);
        HYCJApplyHostSeccessViewController *HYCJVC = [[HYCJApplyHostSeccessViewController alloc] init];
        XZFNavigationController *nav=[[XZFNavigationController alloc]initWithRootViewController:HYCJVC];
        [self presentViewController :nav animated:NO completion:nil];
        
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
