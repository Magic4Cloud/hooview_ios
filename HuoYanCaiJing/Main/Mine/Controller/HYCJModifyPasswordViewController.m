//
//  HYCJModifyPasswordViewController.m
//  HuoYanCaiJing
//
//  Created by ZPF Mac Pro on 2018/1/13.
//  Copyright © 2018年 shilei. All rights reserved.
//

#import "HYCJModifyPasswordViewController.h"
#import "HYCJModifyPasswordBViewController.h"

@interface HYCJModifyPasswordViewController (){
    NSTimer *get_timer;
    int time_index;
}
@property (weak, nonatomic) IBOutlet UIButton *VerificationButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labWidth;
@property (weak, nonatomic) IBOutlet UILabel *buttonLab;
@property (weak, nonatomic) IBOutlet UITextField *verificationTF;

@end

@implementation HYCJModifyPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码";
    [self setupNavigationBar];
    self.view.backgroundColor = [UIColor whiteColor];
    _VerificationButton.layer.borderColor = RGB(234, 72, 96, 1).CGColor;
    _VerificationButton.layer.borderWidth = 1;
}
- (IBAction)VerificationButtonAction:(UIButton *)sender {
    
    [self sendVerificationAction];
}
- (void)sendVerificationAction{
    NSDictionary *paramDict = @{@"phone":self.phoneNumber,@"type":@(2)};
    [SVProgressHUD show];
    [XZFHttpManager POST:VerifyUrl parameters:paramDict requestSerializer:NO requestToken:NO success:^(id respondseObject) {
        NSLog(@"--验证码---%@",respondseObject);
        get_timer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        time_index = 60;
        [self.VerificationButton  setEnabled:NO];
        self.buttonWidth.constant = 130;
        self.labWidth.constant = 130;
        _VerificationButton.layer.borderColor = RGB(216, 216, 216, 1).CGColor;
        NSString *verificationStr = [NSString stringWithFormat:@"%d秒后重新获取",time_index];
        NSMutableAttributedString *strShould = [[NSMutableAttributedString alloc]initWithString:verificationStr];
        //设置：在0-3个单位长度内的内容显示成红色
        NSString *numberStr = [NSString stringWithFormat:@"%d",time_index];
        [strShould addAttribute:NSForegroundColorAttributeName value:RGB(74, 74, 74, 1) range:NSMakeRange(numberStr.length, 6)];
        self.buttonLab.attributedText=strShould;
        
        [get_timer fire];
        [SVProgressHUD dismiss];
        
    } failure:^(NSError *error) {
        
    }];
}
-(void)timerAction{
    time_index = time_index-1;
    if (time_index<=0) {
        time_index =0;
        [get_timer invalidate];
        get_timer = nil;
        [self.VerificationButton setEnabled:YES];
        self.buttonLab.textColor = RGB(234, 72, 96, 1);
        self.buttonLab.text = @"获取验证码";
        self.buttonWidth.constant = 90;
        self.labWidth.constant = 90;
        _VerificationButton.layer.borderColor = RGB(234, 72, 96, 1).CGColor;
    }else{
        self.buttonLab.textColor = RGB(234, 72, 96, 1);
        self.buttonWidth.constant = 130;
        self.labWidth.constant = 130;
        _VerificationButton.layer.borderColor = RGB(216, 216, 216, 1).CGColor;
        self.VerificationButton.titleLabel.textAlignment = NSTextAlignmentLeft;
        NSString *verificationStr = [NSString stringWithFormat:@"%d秒后重新获取",time_index];
        NSMutableAttributedString *strShould = [[NSMutableAttributedString alloc]initWithString:verificationStr];
        //设置：在0-3个单位长度内的内容显示成红色
        NSString *numberStr = [NSString stringWithFormat:@"%d",time_index];
        [strShould addAttribute:NSForegroundColorAttributeName value:RGB(74, 74, 74, 1) range:NSMakeRange(numberStr.length, 6)];
        self.buttonLab.attributedText=strShould;
    }
}
- (IBAction)nextButton:(UIButton *)sender {
    if (self.verificationTF.text.length==0) {
        [SVProgressHUD setMinimumDismissTimeInterval:1];
        [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
        return;
    }
    [XZFHttpManager POST:CheckcodeUrl parameters:@{@"phone":self.phoneNumber,@"code":self.verificationTF.text} requestSerializer:NO requestToken:NO success:^(id respondseObject) {
        NSLog(@"--验证验证码---%@",respondseObject);
        
        HYCJModifyPasswordBViewController *HYCJVC = [[HYCJModifyPasswordBViewController alloc] init];
        HYCJVC.phoneStr = self.phoneNumber;
        HYCJVC.pwkey = [NSString stringWithFormat:@"%@",respondseObject[@"pwkey"]];
        [self.navigationController pushViewController:HYCJVC animated:YES];
        
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
