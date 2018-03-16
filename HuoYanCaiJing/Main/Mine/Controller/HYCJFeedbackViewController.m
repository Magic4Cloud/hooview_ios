//
//  HYCJFeedbackViewController.m
//  HuoYanCaiJing
//
//  Created by ZPF Mac Pro on 2018/1/13.
//  Copyright © 2018年 shilei. All rights reserved.
//

#import "HYCJFeedbackViewController.h"

@interface HYCJFeedbackViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation HYCJFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"意见反馈";
    self.textView.delegate = self;
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)sendButtonAction:(UIButton *)sender {
    if (self.textView.text.length==0) {
        [SVProgressHUD setMinimumDismissTimeInterval:1];
        [SVProgressHUD showErrorWithStatus:@"请输入反馈内容"];
        return;
    }
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    [XZFHttpManager POST:UserOpinionUrl parameters:@{@"userId":userId,@"opinionContent":_textView.text} requestSerializer:NO requestToken:YES success:^(id respondseObject) {
        
        NSLog(@"--意见反馈---%@",respondseObject);
        self.textView.text = @"";
        [SVProgressHUD setMinimumDismissTimeInterval:1];
        [SVProgressHUD showSuccessWithStatus:@"反馈成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    } failure:^(NSError *error) {
        
    }];
}
//正在改变
- (void)textViewDidChange:(UITextView *)textView
{
    //字数限制操作
    if (textView.text.length >= 225) {
        
        textView.text = [textView.text substringToIndex:225];
        return;
    }
    
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
