//
//  HYCJOpenAccountFinishViewController.m
//  HuoYanCaiJing
//
//  Created by ZPF Mac Pro on 2018/1/15.
//  Copyright © 2018年 shilei. All rights reserved.
//

#import "HYCJOpenAccountFinishViewController.h"
#import "HYCJHomeViewController.h"

@interface HYCJOpenAccountFinishViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeght;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backButtonHeight;
@property (weak, nonatomic) IBOutlet UIButton *backHomeButton;

@end

@implementation HYCJOpenAccountFinishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *backmainButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 52/3, 52/3)];
    [backmainButton setImage:[UIImage imageNamed:@"return_white"] forState:UIControlStateNormal];
    [backmainButton addTarget:self action:@selector(backmain) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backmainItem = [[UIBarButtonItem alloc] initWithCustomView:backmainButton];
    [self.navigationItem setLeftBarButtonItem:backmainItem];
    
    self.imageHeght.constant = 134*KHEIGHT_Scale;
    self.imageH.constant = 90*KHEIGHT_Scale;
    self.imageW.constant = 90*KWidth_Scale;
    self.backButtonHeight.constant = 135*KWidth_Scale;
    self.backHomeButton.layer.borderWidth = 1;
    self.backHomeButton.layer.borderColor = RGB(155, 155, 155, 1).CGColor;
    self.backHomeButton.layer.cornerRadius = 14;
    
}
- (void)backmain{
    [self dismissViewControllerAnimated:NO completion:nil];
}
- (IBAction)backHomeButtonAction:(UIButton *)sender {
//    HYCJHomeViewController *target = [[HYCJHomeViewController alloc] init];
    MainTabBarController *target = [[MainTabBarController alloc] init];

    
    UIViewController *vc = self.presentingViewController;
    
    if (!vc.presentingViewController) return;
    
    while (![vc isKindOfClass:[target class]])  {
        vc = vc.presentingViewController;
    }
    
    [vc dismissViewControllerAnimated:NO completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
