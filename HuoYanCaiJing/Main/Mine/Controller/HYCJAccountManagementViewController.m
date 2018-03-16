//
//  HYCJAccountManagementViewController.m
//  HuoYanCaiJing
//
//  Created by ZPF Mac Pro on 2018/1/13.
//  Copyright © 2018年 shilei. All rights reserved.
//

#import "HYCJAccountManagementViewController.h"
#import "HYCJModifyPasswordViewController.h"

@interface HYCJAccountManagementViewController ()
@property (weak, nonatomic) IBOutlet UIButton *ModifyPasswordButton;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;

@end

@implementation HYCJAccountManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账号管理";
    NSString *phoneStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginPhone"];
    self.phoneLab.text = phoneStr;
}
- (IBAction)ModifyPasswordButton:(UIButton *)sender {
    HYCJModifyPasswordViewController *HYCJVC = [[HYCJModifyPasswordViewController alloc] init];
    NSString *phoneStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginPhone"];
    HYCJVC.phoneNumber = phoneStr;
    [self.navigationController pushViewController:HYCJVC animated:YES];
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
