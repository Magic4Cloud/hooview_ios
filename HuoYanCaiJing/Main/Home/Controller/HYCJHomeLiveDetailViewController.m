//
//  HYCJHomeLiveDetailViewController.m
//  HuoYanCaiJing
//
//  Created by ZPF Mac Pro on 2018/1/28.
//  Copyright © 2018年 shilei. All rights reserved.
//

#import "HYCJHomeLiveDetailViewController.h"
#import "HYCJHomeLiveDetailMessageViewController.h"
#import <IJKMediaFramework/IJKFFMoviePlayerController.h>
#import "AppDelegate.h"

@interface HYCJHomeLiveDetailViewController ()<EMChatManagerDelegate,UIAlertViewDelegate>{
    UIButton *fullButton;
    UIButton *backmainButton;
    UIImageView *pointImageView;
    UILabel *numberLab;
}
@property (strong,nonatomic) ZJScrollPageView *scrollPageView;
@property (nonatomic ,strong) UIView *liveView;
@property(nonatomic,strong)IJKFFMoviePlayerController * player;

@end

@implementation HYCJHomeLiveDetailViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.player prepareToPlay];
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.player shutdown];
    //离开直播界面时退出聊天室
    EMError *error;
    
    [[EMClient sharedClient].roomManager leaveChatroom:self.model.roomId error:&error];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(28, 37, 42, 1);
    
    
    
    //注册当前类接收回调
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    
    ZJSegmentStyle *style = [[ZJSegmentStyle alloc] init];
    style.showLine = YES;
    style.gradualChangeTitleColor = NO;
    style.scrollTitle = NO;
    style.segmentHeight = 0;
    style.titleFont = [UIFont pingfangRegularFontWithSize:15];
    style.scrollLineColor = [UIColor colorWithHexString:@"#2EA2FD"];
    style.selectedTitleColor = [UIColor colorWithHexString:@"#2EA2FD"];
    style.normalTitleColor = [UIColor colorWithHexString:@"#BDBDBD"];
    style.scrollVLineWidth = 50;
    style.scrollLineHeight = 2;
    style.perWidth = WIDTH / 3;
    style.titleMargin = 0;
    style.leftMargin = 0;
    style.rightMargin = 0;
    NSArray *childVcs = [NSArray arrayWithArray:[self setupChildVcAndTitle]];
    self.scrollPageView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0, 225*KHEIGHT_Scale, WIDTH, HEIGHT - 225*KHEIGHT_Scale) segmentStyle:style childVcs:childVcs parentViewController:self];
    [self.scrollPageView setSelectedIndex:0 animated:YES];
    [self.view addSubview:self.scrollPageView];
    
    
    _liveView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 225*KHEIGHT_Scale)];
    _liveView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.liveView];
    
    IJKFFOptions *options = [IJKFFOptions optionsByDefault]; //使用默认配置
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"rtmp://wsrtmp.yizhibo.tv:1935/record/%@",_model.vid]];
    self.player = [[IJKFFMoviePlayerController alloc] initWithContentURL:url withOptions:options]; //初始化播放器，播放在线视频或直播(RTMP)
    self.player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    //    self.player.view.frame = self.view.bounds;
    self.player.view.frame = CGRectMake(0, 0, WIDTH, 225*KHEIGHT_Scale);
    
    self.player.scalingMode = IJKMPMovieScalingModeAspectFill; //缩放模式
    self.player.shouldAutoplay = YES; //开启自动播放
    
    self.view.autoresizesSubviews = YES;
    [_liveView addSubview:self.player.view];
    
    fullButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - 50, 225*KHEIGHT_Scale - 50, 50, 50)];
    fullButton.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
//    fullButton.backgroundColor = [UIColor cyanColor];
    [fullButton setImage:[UIImage imageNamed:@"fullIcon"] forState:UIControlStateNormal];
    [fullButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_liveView addSubview:fullButton];
    
    backmainButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 50, 50)];
    [backmainButton setImage:[UIImage imageNamed:@"return_white"] forState:UIControlStateNormal];
    backmainButton.imageEdgeInsets = UIEdgeInsetsMake(0, 9, 0, 9);
    [backmainButton addTarget:self action:@selector(backmain) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backmainButton];
    
    pointImageView = [[UIImageView alloc] initWithFrame:CGRectMake(18.5, 190*KHEIGHT_Scale,9, 9)];
    pointImageView.backgroundColor = RGB(67, 255, 0, 1);
    pointImageView.layer.cornerRadius = 4.5*KWidth_Scale;
    pointImageView.layer.masksToBounds = YES;
    [self.view addSubview:pointImageView];
    
    numberLab = [[UILabel alloc] initWithFrame:CGRectMake(32*KWidth_Scale, 187*KWidth_Scale, WIDTH - 150, 15)];
    numberLab.font = [UIFont pingfangFontWithSize:10*KWidth_Scale];
    numberLab.textAlignment = NSTextAlignmentLeft;
    numberLab.backgroundColor = [UIColor clearColor];
    numberLab.textColor = RGB(255, 255, 255, 255);
    numberLab.text = [NSString stringWithFormat:@"%@人正在看",self.model.watchingCount];
    [self.view addSubview:numberLab];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceOrientationChanged)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil
     ];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    BOOL tokenBool = [BTToolFormatJudge iSStringNull:token];
    if (tokenBool == YES) {
        UIButton *loginButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 225*KHEIGHT_Scale, WIDTH, HEIGHT - 225*KHEIGHT_Scale)];
        loginButton.backgroundColor = [UIColor clearColor];
        [loginButton addTarget:self action:@selector(loginButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:loginButton];
    }

}
- (void)loginButtonAction:(UIButton *)sender{
    [SVProgressHUD setMinimumDismissTimeInterval:1];
    [SVProgressHUD showErrorWithStatus:@"请登录后操作"];
}
- (void)deviceOrientationChanged {
    UIDeviceOrientation orientation             = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    switch (interfaceOrientation) {
        case UIInterfaceOrientationPortrait:{
            NSLog(@"竖屏");
            // 设置竖屏
            [self setOrientationPortrait];
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:{
            NSLog(@"横屏");
            // 设置横屏
            [self setOrientationLandscape];
        }
            break;
        case UIInterfaceOrientationLandscapeRight:{
            NSLog(@"横屏");
            // 设置横屏
            [self setOrientationLandscape];
        }
            break;
        default:
            break;
    }
}
- (void)setOrientationPortrait{
    pointImageView.frame = CGRectMake(18.5, 190*KHEIGHT_Scale,9, 9);
    numberLab.frame = CGRectMake(32*KWidth_Scale, 187*KWidth_Scale, WIDTH - 150, 15*KWidth_Scale);
    _liveView.frame = CGRectMake(0, 0, WIDTH, 225*KHEIGHT_Scale);
    self.player.view.frame = CGRectMake(0, 0, WIDTH, 225*KHEIGHT_Scale);
    backmainButton.hidden = NO;
    [backmainButton setEnabled:YES];
    fullButton.frame = CGRectMake(WIDTH - 50, 225*KHEIGHT_Scale - 50, 50, 50);
    [fullButton setImage:[UIImage imageNamed:@"icon_top_set"] forState:UIControlStateNormal];
}
- (void)setOrientationLandscape{
    pointImageView.frame = CGRectMake(18.5, HEIGHT - 25,9, 9);
    numberLab.frame = CGRectMake(32*KWidth_Scale, HEIGHT - 28, WIDTH - 150, 15);
    _liveView.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
    self.player.view.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
    backmainButton.hidden = YES;
    [backmainButton setEnabled:NO];
    fullButton.frame = CGRectMake(12.5, 30, 50, 50);
    [fullButton setImage:[UIImage imageNamed:@"return_white"] forState:UIControlStateNormal];
}
- (void)buttonAction:(UIButton *)sender{
    sender.selected = !sender.selected;
//    [self videoplayViewSwitchOrientation:sender.selected];
    if (sender.selected) {
        [self interfaceOrientation:UIInterfaceOrientationLandscapeRight];
    }else{
        [self interfaceOrientation:UIInterfaceOrientationPortrait];
    }
}

// 是否支持自动转屏
- (BOOL)shouldAutorotate
{
    return YES;
}
// 支持哪些屏幕方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

// 默认的屏幕方向（当前ViewController必须是通过模态出来的UIViewController（模态带导航的无效）方式展现出来的，才会调用这个方法）
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (void)interfaceOrientation:(UIInterfaceOrientation)orientation {
    // arc下
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector             = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val                  = orientation;
        // 从2开始是因为0 1 两个参数已经被selector和target占用
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {//选择退出
        
    }else{//选择重试
        [self backJoinChatRoom];
    }
}


- (NSArray *)setupChildVcAndTitle {
    NSArray *controllerStr = @[@"HYCJHomeLiveDetailMessageViewController"];
    NSArray *titles = @[@"聊天"];
    NSMutableArray *controllers = [NSMutableArray array];
    for (NSInteger index = 0; index < controllerStr.count; index ++) {
        Class class = NSClassFromString(controllerStr[index]);
//        XZFTeacherNoticeViewController *homeListVc = [[class alloc] init];
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
        BOOL tokenBool = [BTToolFormatJudge iSStringNull:token];
        if (tokenBool == YES) {
            HYCJHomeLiveDetailMessageViewController *chatController = [[class alloc] init];
            chatController.model = self.model;
            chatController.title = titles[index];
            //加入聊天室
            
            [controllers addObject:chatController];
        }else{
            HYCJHomeLiveDetailMessageViewController *chatController = [[class alloc] initWithConversationChatter:self.model.roomId conversationType:EMConversationTypeChatRoom];
            chatController.model = self.model;
            chatController.title = titles[index];
            //加入聊天室
            
            [self backJoinChatRoom];
            [controllers addObject:chatController];
        }
    }
    return controllers;
}
//后台加入聊天室
- (void)backJoinChatRoom
{
    EMError *error;
    NSLog(@"----------后台加入聊天室-----------%@",self.model.roomId);
    [[EMClient sharedClient].roomManager joinChatroom:self.model.roomId error:&error];
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"加入聊天室失败" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重试", nil];
        alert.tag = 101;
        
        [alert show];
    }
    
}
- (void)backmain{
    [self dismissViewControllerAnimated:YES completion:^{
        
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
