//
//  WYXBaseViewModel.h
//  wuyuexin
//
//  Created by 刘杰 on 17/5/8.
//  Copyright © 2017年 even. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYXBaseViewModel : NSObject

/*!
 @brief 创建视图模型 子类实现
 */
+ (instancetype)model;

/*!
 @brief 请求数据 子类实现
 @param success 请求成功回调
 */
- (void)loadDataWithSuccess:(void(^)(id dataSource))success;

/*!
 @brief 请求数据 子类实现
 @param success 请求成功回调 failure 失败回调
 */
- (void)loadDataWithSuccess:(void(^)(id dataSource))success failure:(void(^)(void))failure;


@end
