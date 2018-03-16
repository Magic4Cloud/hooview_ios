//
//  HYCJBannerDetailViewController.m
//  HuoYanCaiJing
//
//  Created by ZPF Mac Pro on 2018/2/4.
//  Copyright © 2018年 shilei. All rights reserved.
//

#import "HYCJBannerDetailViewController.h"

@interface HYCJBannerDetailViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation HYCJBannerDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *backmainButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 13, 22)];
    [backmainButton setImage:[UIImage imageNamed:@"return_white"] forState:UIControlStateNormal];
    [backmainButton addTarget:self action:@selector(backmain) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backmainItem = [[UIBarButtonItem alloc] initWithCustomView:backmainButton];
    [self.navigationItem setLeftBarButtonItem:backmainItem];
    
    self.webView.delegate = self;
    // 2.创建URL
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",self.urlStr]];
    // 3.创建Request
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    // 4.加载网页
    [self.webView loadRequest:request];
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
