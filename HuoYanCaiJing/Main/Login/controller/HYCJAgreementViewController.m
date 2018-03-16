//
//  HYCJAgreementViewController.m
//  HuoYanCaiJing
//
//  Created by ZPF Mac Pro on 2018/1/14.
//  Copyright © 2018年 shilei. All rights reserved.
//

#import "HYCJAgreementViewController.h"

@interface HYCJAgreementViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic ,strong) UIWebView *webView;

@end

@implementation HYCJAgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"用户协议";
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *backmainButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 52/3, 52/3)];
    [backmainButton setImage:[UIImage imageNamed:@"return_white"] forState:UIControlStateNormal];
    [backmainButton addTarget:self action:@selector(backmain) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backmainItem = [[UIBarButtonItem alloc] initWithCustomView:backmainButton];
    [self.navigationItem setLeftBarButtonItem:backmainItem];
    self.webView = [[UIWebView alloc]init];
    self.webView.delegate = self;
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
//    self.webView.scrollView.scrollEnabled = NO;
    self.webView.backgroundColor = [UIColor whiteColor];
    //        self.webView.scrollView.showsVerticalScrollIndicator = NO;
//    if (webStr.length > 0) {
//    }
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    [self loadData];
}

- (void)loadData{
    [XZFHttpManager GET:AgreementUrl parameters:@{} requestSerializer:NO requestToken:YES success:^(id respondseObject) {
        NSLog(@"--------获取注册协议--------%@",respondseObject);
        [self.webView loadHTMLString:[NSString stringWithFormat:@"%@",respondseObject[@"userAgreement"]] baseURL:nil];

    } failure:^(NSError *error) {
        
    }];
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
