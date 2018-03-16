//
//  CKLPayManager.h
//  cheKeLi
//
//  Created by uwant on 16/9/29.
//  Copyright © 2016年 mobiletrain. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <AlipaySDK/AlipaySDK.h>
//#import "WXApi.h"

//#define WE_CAHT_PAY_URL @"/rest/borad/v1/watchBuy"    //微信支付接口
//#define ALI_PAY_URL @"/rest/borad/v1/watchBuy"        //支付宝支付接口
//#define BANLECE_PAY_URL @"/rest/borad/v1/watchBuy"    //余额支付接口

typedef NS_ENUM(NSInteger, PayType) {
    weiXinPay, //微信
    apiPay, //支付宝
    balancePay, //余额
    UPPay,//银联
};

typedef NS_ENUM(NSInteger, LVBalancePayType) {
    LVBalancePayTypePay = 0,//支付
    LVBalancePayTypeTopup,//充值
};


@protocol PayManagerDelegate <NSObject>

@optional
/*!
 @brief 支付成功回调
 @param payType 支付类型
 */
- (void) paySuccessWithType:(PayType)payType;

/*!
 @brief 支付失败回调
 @param payType 支付类型
 */
- (void) payFailueWithType:(PayType)payType;

@end

@interface PayManager : NSObject
/**支付返回代理*/
@property (nonatomic, weak) id<PayManagerDelegate>payManagerDelegate;
/**余额支付类型*/
@property (nonatomic, assign) LVBalancePayType balancePayType;

@property (nonatomic, copy) NSString *payMonay;

+ (instancetype) sharedInstence;

/*!
 @brief 调起微信&支付宝&余额
 @param aParam 调起参数 payType 支付类型 url 自己数据库支付url地址
 */
- (void)handleOrderPayWithParams:(NSDictionary *)aParam type:(PayType)payType url:(NSString *)url;

/*!
 @brief 调起微信
 */
- (void) wieXinPayParams:(NSDictionary *)aParam;

/*!
 @brief 调起支付宝，
*/
- (void) alipayParams:(NSDictionary *)aParam ;



@end
