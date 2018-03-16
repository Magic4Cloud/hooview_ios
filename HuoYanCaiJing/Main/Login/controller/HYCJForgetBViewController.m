//
//  HYCJForgetBViewController.m
//  HuoYanCaiJing
//
//  Created by ZPF Mac Pro on 2018/1/14.
//  Copyright © 2018年 shilei. All rights reserved.
//

#import "HYCJForgetBViewController.h"
#import "HYCJForgetCViewController.h"

@interface HYCJForgetBViewController (){
    NSTimer *get_timer;
    int time_index;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *numberWide;
@property (weak, nonatomic) IBOutlet UITextField *verificationTF;
@property (weak, nonatomic) IBOutlet UILabel *verificationlab;
@property (weak, nonatomic) IBOutlet UIButton *verificationButton;

@end

@implementation HYCJForgetBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.titleStr;
    UIButton *backmainButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 52/3, 52/3)];
    [backmainButton setImage:[UIImage imageNamed:@"return_white"] forState:UIControlStateNormal];
    [backmainButton addTarget:self action:@selector(backmain) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backmainItem = [[UIBarButtonItem alloc] initWithCustomView:backmainButton];
    [self.navigationItem setLeftBarButtonItem:backmainItem];
    
    self.numberWide.constant = 65*KWidth_Scale;
    [self sendVerificationAction];

}
- (IBAction)nextbuttonAction:(UIButton *)sender {
    
    if (self.verificationTF.text.length==0) {
        [SVProgressHUD setMinimumDismissTimeInterval:1];
        [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
        return;
    }
    [XZFHttpManager POST:CheckcodeUrl parameters:@{@"phone":self.phoneStr,@"code":self.verificationTF.text} requestSerializer:NO requestToken:NO success:^(id respondseObject) {
        
        NSLog(@"--验证验证码---%@",respondseObject);
        HYCJForgetCViewController *HYCJVC = [[HYCJForgetCViewController alloc] init];
        XZFNavigationController *nav=[[XZFNavigationController alloc]initWithRootViewController:HYCJVC];
        HYCJVC.titleStr = self.titleStr;
        HYCJVC.phoneStr = self.phoneStr;
        HYCJVC.type = self.type;
        HYCJVC.mineType = 2;
        HYCJVC.pwkey = [NSString stringWithFormat:@"%@",respondseObject[@"pwkey"]];
        [self presentViewController :nav animated:NO completion:nil];
        
    } failure:^(NSError *error) {
        
    }];
    
}
- (IBAction)VerificationButtonAction:(UIButton *)sender {
    
    [self sendVerificationAction];
//    NSDictionary *paramDict = @{@"phone":self.phoneStr,@"type":@(self.type)};
//    
//    [XZFHttpManager POST:VerifyUrl parameters:paramDict requestSerializer:NO requestToken:NO success:^(id respondseObject) {
//        NSLog(@"--验证码---%@",respondseObject);
//        get_timer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
//        time_index = 30;
//        [self.verificationButton  setEnabled:NO];
//        self.verificationlab.textColor = RGB(234, 72, 96, 1);
//        NSString *verificationStr = [NSString stringWithFormat:@"再次发送(%ds)",time_index];
//        NSMutableAttributedString *strShould = [[NSMutableAttributedString alloc]initWithString:verificationStr];
//        //设置：在0-3个单位长度内的内容显示成红色
//        [strShould addAttribute:NSForegroundColorAttributeName value:RGB(74, 74, 74, 1) range:NSMakeRange(0, 4)];
//        self.verificationlab.attributedText = strShould;
////        self.verificationlab.text = [NSString stringWithFormat:@"再次发送(%ds)",time_index];
//        [get_timer fire];
//        
//    } failure:^(NSError *error) {
//        
//    }];
}
- (void)sendVerificationAction{
    NSDictionary *paramDict = @{@"phone":self.phoneStr,@"type":@(self.type)};
    
    [XZFHttpManager POST:VerifyUrl parameters:paramDict requestSerializer:NO requestToken:NO success:^(id respondseObject) {
        NSLog(@"--验证码---%@",respondseObject);
        get_timer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        time_index = 30;
        [self.verificationButton  setEnabled:NO];
        self.verificationlab.textColor = RGB(234, 72, 96, 1);
        NSString *verificationStr = [NSString stringWithFormat:@"再次发送(%ds)",time_index];
        NSMutableAttributedString *strShould = [[NSMutableAttributedString alloc]initWithString:verificationStr];
        //设置：在0-3个单位长度内的内容显示成红色
        [strShould addAttribute:NSForegroundColorAttributeName value:RGB(74, 74, 74, 1) range:NSMakeRange(0, 4)];
        self.verificationlab.attributedText = strShould;
        //        self.verificationlab.text = [NSString stringWithFormat:@"再次发送(%ds)",time_index];
        [get_timer fire];
        
    } failure:^(NSError *error) {
        
    }];
}
-(void)timerAction{
    time_index = time_index-1;
    if (time_index<=0) {
        time_index =0;
        [get_timer invalidate];
        get_timer = nil;
        [self.verificationButton setEnabled:YES];
//        [self.verificationButton setTitle:@"获取验证码" forState:UIControlStateNormal];
//        [self.verificationButton setTitleColor:UIColorFromHex(0xFB1414) forState:UIControlStateNormal];
        self.verificationlab.text = @"获取验证码";
    }else{
//        [self.verificationButton setTitle:[NSString stringWithFormat:@"重新获取(%ds)",time_index] forState:UIControlStateNormal];
        self.verificationlab.textColor = RGB(234, 72, 96, 1);
        NSString *verificationStr = [NSString stringWithFormat:@"再次发送(%ds)",time_index];
        NSMutableAttributedString *strShould = [[NSMutableAttributedString alloc]initWithString:verificationStr];
        //设置：在0-3个单位长度内的内容显示成红色
        [strShould addAttribute:NSForegroundColorAttributeName value:RGB(74, 74, 74, 1) range:NSMakeRange(0, 4)];
        self.verificationlab.attributedText = strShould;

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
