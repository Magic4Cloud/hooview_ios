//
//  HYCJAboutViewController.m
//  HuoYanCaiJing
//
//  Created by ZPF Mac Pro on 2018/1/13.
//  Copyright © 2018年 shilei. All rights reserved.
//

#import "HYCJAboutViewController.h"

@interface HYCJAboutViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewHeight;

@end

@implementation HYCJAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于火眼";
    self.view.backgroundColor = [UIColor whiteColor];
    self.webView.delegate = self;
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    self.webView.scrollView.scrollEnabled = NO;
    self.webView.backgroundColor = [UIColor whiteColor];
    [self loadData];
}
#pragma mark - UIWebViewDelegate
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [SVProgressHUD showErrorWithStatus:@"加载失败"];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    if (self.webView) {
        CGFloat height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
        
        self.webView.scrollView.contentSize = CGSizeMake(0, height + 25);
        
        self.scrollViewHeight.constant = height + 125;
//        if (oneWebViewHeight == 0) {
//            oneWebViewHeight = height + 15;
//            NSLog(@"---------------%f",oneWebViewHeight);
//            [self.tableView reloadData];
//                        [SVProgressHUD dismiss];
//        }
    }
}
- (void)loadData{
    [XZFHttpManager GET:AboutUsInfoUrl parameters:@{} requestSerializer:NO requestToken:YES success:^(id respondseObject) {
        NSLog(@"--------关于火眼--------%@",respondseObject);
        [self.webView loadHTMLString:[NSString stringWithFormat:@"%@",respondseObject[@"aboutUs"]] baseURL:nil];
        
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
