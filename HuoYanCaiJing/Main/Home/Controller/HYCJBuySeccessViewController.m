//
//  HYCJBuySeccessViewController.m
//  HuoYanCaiJing
//
//  Created by ZPF Mac Pro on 2018/1/15.
//  Copyright © 2018年 shilei. All rights reserved.
//

#import "HYCJBuySeccessViewController.h"

@interface HYCJBuySeccessViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeght;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backButtonHeight;
@property (weak, nonatomic) IBOutlet UIButton *lookButton;
@end

@implementation HYCJBuySeccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"支付购买";
    self.imageHeght.constant = 132*KHEIGHT_Scale;
    self.imageH.constant = 90*KHEIGHT_Scale;
    self.imageW.constant = 90*KWidth_Scale;
    self.backButtonHeight.constant = 135*KWidth_Scale;
    self.lookButton.layer.borderWidth = 1;
    self.lookButton.layer.borderColor = RGB(155, 155, 155, 1).CGColor;
    self.lookButton.layer.cornerRadius = 14;

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
