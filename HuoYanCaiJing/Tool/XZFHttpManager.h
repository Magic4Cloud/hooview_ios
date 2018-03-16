//
//  XZFHttpManager.h
//  XueZhiFei
//
//  Created by ZPF Mac Pro on 2017/11/3.
//  Copyright © 2017年 ZPF Mac Pro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XZFHttpManager : NSObject
+ (instancetype)sharedInstence;

/*!
 @brief post请求
 */
+ (void)POST:(NSString *)URL parameters:(NSDictionary *)parameters requestSerializer:(BOOL)isConfig requestToken:(BOOL)isToken success:(void(^)(id respondseObject))success failure:(void(^)(NSError *error))failure;

/*!
 @brief GET请求
 */
+ (void)GET:(NSString *)URL parameters:(NSDictionary *)parameters requestSerializer:(BOOL)isConfig requestToken:(BOOL)isToken success:(void(^)(id respondseObject))success failure:(void(^)(NSError *error))failure;

/*!
 @brief PUT请求
 */
+ (void)PUT:(NSString *)URL parameters:(NSDictionary *)parameters requestSerializer:(BOOL)isConfig success:(void(^)(id respondseObject))success failure:(void(^)(NSError *error))failure;


/*!
 @brief 上传头像
 */
+ (void)updateHeadImg:(NSString *)url parameters:(NSDictionary *)parameters postName:(NSString *)postName image:(UIImage *)image success:(void(^)(id respondseObject))success failure:(void(^)(NSError *error))failure;
//上传视频
+ (void)updateVideo:(NSString *)url parameters:(NSDictionary *)parameters postName:(NSString *)postName video:(NSURL *)video success:(void (^)(id))success failure:(void (^)(NSError *))failure;
//多张图片
+ (void)updateMoreImg:(NSString *)url parameters:(NSDictionary *)parameters postName:(NSString *)postName imageArr:(NSArray *)imageArr success:(void (^)(id))success failure:(void (^)(NSError *))failure;

//多张图片+单张图片+数据
+ (void)updateMoreData:(NSString *)url parameters:(NSDictionary *)parameters postimageName:(NSString *)postimageName postimageArrName:(NSString *)postimageArrName image:(UIImage *)image imageArr:(NSArray *)imageArr success:(void (^)(id))success failure:(void (^)(NSError *))failure;


/**
 *上传图片
 */
+ (void)POSTUPLOAD:(NSString *)url
        parameters:(NSDictionary *)parmeters
          andImage:(UIImage *)image
           success:(void(^)(id responseObject))success
           failure:(void(^)(NSError *error))failue;


@end
