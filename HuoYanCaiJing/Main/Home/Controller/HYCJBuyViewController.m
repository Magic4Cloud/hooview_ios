//
//  HYCJBuyViewController.m
//  HuoYanCaiJing
//
//  Created by ZPF Mac Pro on 2018/1/15.
//  Copyright © 2018年 shilei. All rights reserved.
//

#import "HYCJBuyViewController.h"
#import "HYCJBuySeccessViewController.h"

@interface HYCJBuyViewController ()
@property (weak, nonatomic) IBOutlet UIButton *weixinButton;
@property (weak, nonatomic) IBOutlet UIButton *zhifubaoButton;
@property (weak, nonatomic) IBOutlet UIImageView *weixinImage;
@property (weak, nonatomic) IBOutlet UIImageView *zhifubaoImage;

@end

@implementation HYCJBuyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"支付购买";
}
- (IBAction)weixinButtonAction:(UIButton *)sender {
    _zhifubaoImage.image = [UIImage imageNamed:@"icon_check_x"];
    _weixinImage.image = [UIImage imageNamed:@"icon_check_x_sure"];
}
- (IBAction)zhifubaoButtonAction:(UIButton *)sender {
    _zhifubaoImage.image = [UIImage imageNamed:@"icon_check_x_sure"];
    _weixinImage.image = [UIImage imageNamed:@"icon_check_x"];

}
- (IBAction)buyButtonAction:(UIButton *)sender {
    HYCJBuySeccessViewController *HYCJVC = [[HYCJBuySeccessViewController alloc] init];
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
