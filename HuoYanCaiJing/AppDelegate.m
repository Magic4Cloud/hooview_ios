//
//  AppDelegate.m
//  HuoYanCaiJing
//
//  Created by ZPF Mac Pro on 2018/1/7.
//  Copyright © 2018年 shilei. All rights reserved.
//

#import "AppDelegate.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
@interface AppDelegate ()<WXApiDelegate,QQApiInterfaceDelegate,TencentSessionDelegate>

@end

@implementation AppDelegate

//- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
//{
//    if (_allowRotation == 1) {
//        return UIInterfaceOrientationMaskLandscapeRight;
//    }
//    else
//    {
//        return (UIInterfaceOrientationMaskPortrait);
//    }
//}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    // 设置根窗口
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    self.window.backgroundColor = [UIColor whiteColor];
    
//    self.window.rootViewController = [[MainTabBarController alloc] init];

    MainTabBarController *vc = [[MainTabBarController alloc] init];
    self.window.rootViewController = vc;
    
    
    //AppKey:注册的AppKey，详细见下面注释。
    //apnsCertName:推送证书名（不需要加后缀），详细见下面注释。
    EMOptions *options = [EMOptions optionsWithAppkey:@"1150160929178497#hooview"];
//    options.apnsCertName = @"istore_dev";
    [[EMClient sharedClient] initializeSDKWithOptions:options];
    
    // 从微信开放平台获取
    NSString *APPID = @"wx89d62b0eec9c1d9c";
    // 向微信注册
    [WXApi registerApp:APPID];
        
    return YES;
}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [WXApi handleOpenURL:url delegate:self];
}

-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
    if ([url.scheme isEqualToString:@"wx89d62b0eec9c1d9c"]) {
        return [WXApi handleOpenURL:url delegate:self];
    }else if ([url.scheme isEqualToString:[NSString stringWithFormat:@"tencent%@",@"1105885323"]]) {
        return [QQApiInterface handleOpenURL:url delegate:self];
    }else {
        return YES;
    }
    
//    return [WXApi handleOpenURL:url delegate:self];
}

#pragma mark WXApiDelegate 微信分享的相关回调

// onReq是微信终端向第三方程序发起请求，要求第三方程序响应。第三方程序响应完后必须调用sendRsp返回。在调用sendRsp返回时，会切回到微信终端程序界面
- (void)onReq:(BaseReq *)req
{
    NSLog(@"onReq是微信终端向第三方程序发起请求，要求第三方程序响应。第三方程序响应完后必须调用sendRsp返回。在调用sendRsp返回时，会切回到微信终端程序界面");
}

// 如果第三方程序向微信发送了sendReq的请求，那么onResp会被回调。sendReq请求调用后，会切到微信终端程序界面
- (void)onResp:(BaseResp *)resp
{
    NSLog(@"回调处理");
    
    // 处理 分享请求 回调
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        switch (resp.errCode) {
            case WXSuccess:
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"分享成功!"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
                [alert show];
            }
                break;
                
            default:
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"分享失败!"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
                [alert show];
            }
                break;
        }
    }
}
#pragma mark -- QQApiInterfaceDelegate
//// 处理来自QQ的请求，调用sendResp
//- (void)onReq:(QQBaseReq *)req {
//    
//}

// 处理来自QQ的响应，调用sendReq
//- (void)onResp:(QQBaseReq *)resp {
//    switch (resp.type)
//    {
//        case ESENDMESSAGETOQQRESPTYPE:
//        {
//            SendMessageToQQResp* sendResp = (SendMessageToQQResp*)resp;
//            if ([sendResp.result isEqualToString:@"0"]) {
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"成功" message:@"QQ分享成功" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                [alert show];
//            }
//            else {
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"失败" message:@"QQ分享失败" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                [alert show];
//            }
//            break;
//        }
//        default:
//        {
//            break;
//        }
//    }
//}
// 处理QQ在线状态的回调
- (void)isOnlineResponse:(NSDictionary *)response {
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    [[EMClient sharedClient] applicationDidEnterBackground:application];

    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    [[EMClient sharedClient] applicationWillEnterForeground:application];

    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
