//
//  CKLPayManager.m
//  cheKeLi
//
//  Created by uwant on 16/9/29.
//  Copyright © 2016年 mobiletrain. All rights reserved.
//

#import "PayManager.h"
//#import "CKLPayPasswordView.h"
//#import "JLBLogingViewController.h"
//#import "JLBNavgationController.h"

@implementation PayManager

+ (instancetype)sharedInstence {
    static PayManager *manager = nil;
    static dispatch_once_t tokon;
    dispatch_once(&tokon, ^{
        manager = [[PayManager alloc] init];
    });
    return manager;
}


- (void)handleOrderPayWithParams:(NSDictionary *)aParam type:(PayType)payType url :(NSString *)url{
        __weak typeof(self) weakSelf = self;
    switch (payType) {
        case weiXinPay:
        {
            [self requstParams:aParam url:url success:^(id respondseObject) {
                
                [weakSelf wieXinPayParams:respondseObject[@"data"]];
            } failure:^(NSError *error) {
//                JLBLog(@"111===%@",error.localizedDescription);
            }];
        }
            break;
        case apiPay:
        {
            [self requstParams:aParam url:url success:^(id respondseObject) {
                
                [weakSelf alipayParams:respondseObject];
            } failure:^(NSError *error) {
                
            }];
        }
            break;
        default:
            break;
    }
}

#pragma mark 请求后台接口创建订单
- (void) requstParams:(NSDictionary *)aParam url:(NSString *)url success:(void(^)(id respondseObject))success failure:(void(^)(NSError *error))failure{
    
    [XZFHttpManager POST:url parameters:aParam requestSerializer:NO requestToken:NO success:^(id respondseObject) {
        NSLog(@"------订单-------%@",respondseObject);
        if (success) {
            success(respondseObject);
        }

    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }

    }];
    
}

#pragma mark 微信
- (void) wieXinPayParams:(NSDictionary *)aParam {
    
    NSLog(@"==-=-=-=-=-=-=------%@",aParam);
    
    NSMutableString *stamp  = [aParam objectForKey:@"timestamp"];
    //调起微信支付
    PayReq* req             = [[PayReq alloc] init];
    req.openID              = [NSString stringWithFormat:@"%@",[aParam objectForKey:@"appid"]];
    req.partnerId          = [NSString stringWithFormat:@"%@",[aParam objectForKey:@"partnerid"]];
    req.prepayId            = [NSString stringWithFormat:@"%@",[aParam objectForKey:@"prepayid"]];
    req.nonceStr            = [NSString stringWithFormat:@"%@",[aParam objectForKey:@"noncestr"]];
    req.timeStamp          = (UInt32)stamp.intValue;
    req.package            = [NSString stringWithFormat:@"%@",[aParam objectForKey:@"package"]];
    req.sign                = [NSString stringWithFormat:@"%@",[aParam objectForKey:@"sign"]];
    
    NSLog(@"==-=-=-=-=-=-=------%@",aParam);
    BOOL flag = [WXApi sendReq:req];
    
    if (!flag) {
        NSLog(@"请求微信失败");
        //...提示用户
        [SVProgressHUD setMinimumDismissTimeInterval:1];
        [SVProgressHUD showErrorWithStatus:@"请求安装微信"];
    }
    else{
        NSLog(@"请求成功");
    }
}

-(void)onResp:(BaseResp*)resp{
    if ([resp isKindOfClass:[PayResp class]]){
        PayResp*response=(PayResp*)resp;
        switch(response.errCode){
            case WXSuccess:
                //服务器端查询支付通知或查询API返回的结果再提示成功
                if ([self.payManagerDelegate respondsToSelector:@selector(paySuccessWithType:)]) {
                    [self.payManagerDelegate paySuccessWithType:weiXinPay];
                }
                break;
            default:
                if  ([self.payManagerDelegate respondsToSelector:@selector(payFailueWithType:)]) {
                    [self.payManagerDelegate payFailueWithType:weiXinPay];
                }
                break;
        }
    }
}


#pragma mark 支付宝
- (void) alipayParams:(NSDictionary *)aParam {
    
    
    [[AlipaySDK defaultService] payOrder:aParam[@"data"][@"sign"] fromScheme:@"XueZhiFei" callback:^(NSDictionary *resultDic) {
        NSLog(@"reslut = 支付宝 %@",resultDic);
        int statusCode = [resultDic[@"resultStatus"]  intValue];
        
        if (statusCode == 9000)
        {
            if ([self.payManagerDelegate respondsToSelector:@selector(paySuccessWithType:)]) {
                [self.payManagerDelegate paySuccessWithType:apiPay];
            }
        } else
        {
           
            
            //交易失败
            if  ([self.payManagerDelegate respondsToSelector:@selector(payFailueWithType:)]) {
                [self.payManagerDelegate payFailueWithType:apiPay];
            }
        }
        
        //注册通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNectioPaySucceses:) name:@"appPay" object:nil];
        
    }];
}

#pragma mark -- 支付报支付成功，appdelegate通过通知传值支付结果
- (void)handleNectioPaySucceses:(NSNotification *)nit
{
    
    
    NSDictionary *dic = nit.userInfo;
    NSInteger status = [dic[@"status"] integerValue];
    NSString *title ;
    switch (status) {
        case 6001:
            title = @"取消支付";
            break;
        case 9000:
            

            break;
        case 6002:
            title = @"网络连接出错";
            break;
        case 4000:
            title = @"支付失败";
        case 8000:
            title = @"订单正在处理";
        default:
            break;
    }
    if (status != 9000) {
        //交易失败
        if  ([self.payManagerDelegate respondsToSelector:@selector(payFailueWithType:)]) {
            [self.payManagerDelegate payFailueWithType:apiPay];
        }
    }else{
        if ([self.payManagerDelegate respondsToSelector:@selector(paySuccessWithType:)]) {
            [self.payManagerDelegate paySuccessWithType:apiPay];
        }
    }
    
}
- (NSMutableDictionary *)VEComponentsStringToDic:(NSString*)AllString withSeparateString:(NSString *)FirstSeparateString AndSeparateString:(NSString *)SecondSeparateString{
    
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    
    NSArray *FirstArr=[AllString componentsSeparatedByString:FirstSeparateString];
    
    for (int i=0; i<FirstArr.count; i++) {
        NSString *Firststr=FirstArr[i];
        NSArray *SecondArr=[Firststr componentsSeparatedByString:SecondSeparateString];
        [dic setObject:SecondArr[1] forKey:SecondArr[0]];
        
    }
    
    return dic;
}



@end
