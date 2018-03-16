//
//  XZFHttpManager.m
//  XueZhiFei
//
//  Created by ZPF Mac Pro on 2017/11/3.
//  Copyright © 2017年 ZPF Mac Pro. All rights reserved.
//

#import "XZFHttpManager.h"
#import "AppDelegate.h"
//#import "XZFLoginAndRegisterViewController.h"

@implementation XZFHttpManager
+ (instancetype)sharedInstence {
    static XZFHttpManager *instence = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        instence = [[XZFHttpManager alloc] init];
    });
    return instence;
}

+ (void)POST:(NSString *)URL parameters:(NSDictionary *)parameters requestSerializer:(BOOL)isConfig requestToken:(BOOL)isToken success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    
    NSString *conplishURl = nil;
    
    conplishURl = [NSString stringWithFormat:@"%@%@",BASE_URL,URL];
    
    NSDictionary *body = parameters;
    
    NSLog(@"---------parameters-------%@",parameters);
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:body options:0 error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    
    //设置返回数据序列化对象
//    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
//    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",nil];
//    manager.responseSerializer = responseSerializer;

    
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:conplishURl parameters:nil error:nil];
    
    req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
    
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    
    if (isToken == YES) {
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
        
        [req setValue:[NSString stringWithFormat:@"%@",token] forHTTPHeaderField:@"token"];
    }
    [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
            
            NSLog(@"Reply JSON: %@", responseObject);
            
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                if ([responseObject[@"code"] integerValue] == 200) {
                    if (success) {
                        success(responseObject);
                    }
                }else {
                    NSLog(@"-----不等于200-------%@",responseObject);
                    if (![responseObject[@"msg"] isKindOfClass:[NSNull class]]) {
                        NSError *error = [[NSError alloc] initWithDomain:NSCocoaErrorDomain code:[responseObject[@"code"] integerValue] userInfo:nil];
                        
                        [SVProgressHUD setMinimumDismissTimeInterval:1];
                        [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
                        if ([responseObject[@"code"] integerValue] == 401) {
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
                            });
                            
                        }
                        if (failure) {
                            failure(error);
                        }
                    }else {
                        NSError *error = [[NSError alloc] initWithDomain:NSCocoaErrorDomain code:[responseObject[@"code"] integerValue] userInfo:nil];
                        if (failure) {
                            failure(error);
                        }
                    }
                }
                
            }
            
        } else {
            
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
            if ([error.localizedDescription isEqualToString:@"The Internet connection appears to be offline."]){
                [SVProgressHUD showErrorWithStatus:@"请检查网络设置"];
            }else {
                [SVProgressHUD setMinimumDismissTimeInterval:1];
                [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            }
            NSLog(@"%@",error.localizedDescription);
            NSLog(@"----error---%@",error);
            if (failure) {
                failure(error);
            }
            
        }
        
    }] resume];
    
    
}

+ (void)GET:(NSString *)URL parameters:(NSDictionary *)parameters requestSerializer:(BOOL)isConfig requestToken:(BOOL)isToken success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    
    NSString *conplishURl = nil;
    
    conplishURl = [NSString stringWithFormat:@"%@%@",BASE_URL,URL];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //参数
    if (isConfig) {
        //配置content-type
        manager.requestSerializer=[AFJSONRequestSerializer serializer];
    }
    //设置请求头
    //    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //    NSString * api_token = [[NSUserDefaults standardUserDefaults] objectForKey:@"api_token"];
//        [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",api_token] forHTTPHeaderField:@"Authorization"];
    //        NSLog(@"%@",[NSString stringWithFormat:@"Bearer %@",api_token]);
    if (isToken == YES) {
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
        
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@",token] forHTTPHeaderField:@"token"];
//        [manager.requestSerializer setValue:TOKEN forHTTPHeaderField:@"token-id"];
        

//        [req setValue:[NSString stringWithFormat:@"%@",token] forHTTPHeaderField:@"Authorization"];
    }
    //配置网络请求超市时间
    manager.requestSerializer.timeoutInterval = 10;
    //设置MIME类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/plain",@"text/xml",nil];
    
    NSLog(@"------parameters-------%@",parameters);
    
    [manager GET:conplishURl parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"请求中－－－%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] integerValue] == 200) {
            if (success) {
                success(responseObject);
            }
        }else {
            if ([responseObject[@"code"] integerValue] == 401) {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userId"];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"loginChangeTableViewUI" object:nil userInfo:nil];
            }
            NSLog(@"-----不等于200-------%@",responseObject);
            if (![responseObject[@"msg"] isKindOfClass:[NSNull class]]) {
                NSError *error = [[NSError alloc] initWithDomain:NSCocoaErrorDomain code:[responseObject[@"code"] integerValue] userInfo:nil];
                
                [SVProgressHUD setMinimumDismissTimeInterval:1];
                [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
                if ([responseObject[@"code"] integerValue] == 401) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
                    });
                    
                }
                if (failure) {
                    failure(error);
                }
            }else {
                NSError *error = [[NSError alloc] initWithDomain:NSCocoaErrorDomain code:[responseObject[@"code"] integerValue] userInfo:nil];
                if (failure) {
                    failure(error);
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([error.localizedDescription isEqualToString:@"The Internet connection appears to be offline."]){
            [SVProgressHUD showErrorWithStatus:@"请检查网络设置"];
        }else {
            [SVProgressHUD setMinimumDismissTimeInterval:1];
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
        NSLog(@"=====error====%@",error.localizedDescription);
        if (failure) {
            failure(error);
        }
    }];
}
+(void)PUT:(NSString *)URL parameters:(NSDictionary *)parameters requestSerializer:(BOOL)isConfig success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    NSString *conplishURl = nil;
    
    conplishURl = [NSString stringWithFormat:@"%@%@",BASE_URL,URL];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //参数
    if (isConfig) {
        //配置content-type
        manager.requestSerializer=[AFJSONRequestSerializer serializer];
    }
    //设置请求头
    //    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //    NSString * api_token = [[NSUserDefaults standardUserDefaults] objectForKey:@"api_token"];
    //    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",api_token] forHTTPHeaderField:@"Authorization"];
    //        NSLog(@"%@",[NSString stringWithFormat:@"Bearer %@",api_token]);
    
    //配置网络请求超市时间
    manager.requestSerializer.timeoutInterval = 10;
    //设置MIME类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/plain",@"text/xml",nil];
    
    [manager PUT:conplishURl parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"status"] integerValue] == 1) {
            if (success) {
                success(responseObject);
            }
        }else {
            NSLog(@"-----不等于1-------%@",responseObject);
            if (![responseObject[@"message"] isKindOfClass:[NSNull class]]) {
                NSError *error = [[NSError alloc] initWithDomain:NSCocoaErrorDomain code:[responseObject[@"status"] integerValue] userInfo:nil];
                
                if ([responseObject[@"status"] integerValue] == 422) {
                    [SVProgressHUD showErrorWithStatus:responseObject[@"body"]];
                }
                if (failure) {
                    failure(error);
                }
            }else {
                NSError *error = [[NSError alloc] initWithDomain:NSCocoaErrorDomain code:[responseObject[@"status"] integerValue] userInfo:nil];
                if (failure) {
                    failure(error);
                }
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([error.localizedDescription isEqualToString:@"The Internet connection appears to be offline."]){
            [SVProgressHUD showErrorWithStatus:@"请检查网络设置"];
        }else {
            [SVProgressHUD setMinimumDismissTimeInterval:1];
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
        NSLog(@"=====error====%@",error.localizedDescription);
        if (failure) {
            failure(error);
        }
    }];
    
}



+ (void)updateHeadImg:(NSString *)url parameters:(NSDictionary *)parameters postName:(NSString *)postName image:(UIImage *)image success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    NSString *conplishURl = nil;
    
    conplishURl = [NSString stringWithFormat:@"%@%@",BASE_URL,url];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //配置网络请求超市时间
    manager.requestSerializer.timeoutInterval = 10;
    //设置MIME类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/plain",@"text/xml",nil];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@",token] forHTTPHeaderField:@"token"];
    
    [manager POST:conplishURl parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
        NSDateFormatter *dataDormatter = [[NSDateFormatter alloc] init];
        dataDormatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [dataDormatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg",str];
        
        [formData appendPartWithFileData:imageData name:postName fileName:fileName mimeType:@"image/jpg"];
        
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([responseObject[@"code"] integerValue] == 200) {
                if (success) {
                    success(responseObject);
                }
            }else {
                NSLog(@"-----不等于200-------%@",responseObject);
                if (![responseObject[@"msg"] isKindOfClass:[NSNull class]]) {
                    NSError *error = [[NSError alloc] initWithDomain:NSCocoaErrorDomain code:[responseObject[@"code"] integerValue] userInfo:nil];
                    
                    [SVProgressHUD setMinimumDismissTimeInterval:1];
                    [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
                    if ([responseObject[@"code"] integerValue] == 401) {
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
                        });
                        
                    }
                    if (failure) {
                        failure(error);
                    }
                }else {
                    NSError *error = [[NSError alloc] initWithDomain:NSCocoaErrorDomain code:[responseObject[@"code"] integerValue] userInfo:nil];
                    if (failure) {
                        failure(error);
                    }
                }
            }
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([error.localizedDescription isEqualToString:@"The Internet connection appears to be offline."]) {
            [SVProgressHUD showErrorWithStatus:@"请检查网络设置"];
        }else {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
        NSLog(@"%@",error.localizedDescription);
        if (failure) {
            failure(error);
        }
    }];
}
//上传视频
+ (void)updateVideo:(NSString *)url parameters:(NSDictionary *)parameters postName:(NSString *)postName video:(NSURL *)video success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    NSString *conplishURl = nil;
    
    conplishURl = [NSString stringWithFormat:@"%@%@",BASE_URL,url];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //配置网络请求超市时间
    manager.requestSerializer.timeoutInterval = 10;
    //设置MIME类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/plain",@"text/xml",nil];
    
    [manager POST:conplishURl parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
        NSDateFormatter *dataDormatter = [[NSDateFormatter alloc] init];
        dataDormatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [dataDormatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.mp4",str];
        
        NSData *data = [NSData dataWithContentsOfURL:video];
        
        [formData appendPartWithFileData:data name:postName fileName:fileName mimeType:@"video/mp4"];
        
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] integerValue] == 200) {
            if (success) {
                success(responseObject);
            }
        }else {
            if (![responseObject[@"message"] isKindOfClass:[NSNull class]]) {
                NSError *error = [[NSError alloc] initWithDomain:NSCocoaErrorDomain code:[responseObject[@"code"] integerValue] userInfo:nil];
                [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
                if (failure) {
                    failure(error);
                }
            }else {
                NSError *error = [[NSError alloc] initWithDomain:NSCocoaErrorDomain code:[responseObject[@"code"] integerValue] userInfo:nil];
                if (failure) {
                    failure(error);
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([error.localizedDescription isEqualToString:@"The Internet connection appears to be offline."]) {
            [SVProgressHUD showErrorWithStatus:@"请检查网络设置"];
        }else {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
        NSLog(@"%@",error.localizedDescription);
        if (failure) {
            failure(error);
        }
    }];
}
//多张图片
+ (void)updateMoreImg:(NSString *)url parameters:(NSDictionary *)parameters postName:(NSString *)postName imageArr:(NSArray *)imageArr success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    NSString *conplishURl = nil;
    
    conplishURl = [NSString stringWithFormat:@"%@%@",BASE_URL,url];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //配置网络请求超市时间
    manager.requestSerializer.timeoutInterval = 10;
    //设置MIME类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/plain",@"text/xml",nil];
    
    [manager POST:conplishURl parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (int i = 0; i < imageArr.count; i ++) {
            UIImage *image = imageArr[i];
            NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
            NSDateFormatter *dataDormatter = [[NSDateFormatter alloc] init];
            dataDormatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [dataDormatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.jpg",str];
            
            [formData appendPartWithFileData:imageData name:postName fileName:fileName mimeType:@"image/jpg"];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"code"] integerValue] == 200) {
            if (success) {
                success(responseObject);
            }
        }else {
            if (![responseObject[@"message"] isKindOfClass:[NSNull class]]) {
                NSError *error = [[NSError alloc] initWithDomain:NSCocoaErrorDomain code:[responseObject[@"code"] integerValue] userInfo:nil];
                [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
                if (failure) {
                    failure(error);
                }
            }else {
                NSError *error = [[NSError alloc] initWithDomain:NSCocoaErrorDomain code:[responseObject[@"code"] integerValue] userInfo:nil];
                if (failure) {
                    failure(error);
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([error.localizedDescription isEqualToString:@"The Internet connection appears to be offline."]) {
            [SVProgressHUD showErrorWithStatus:@"请检查网络设置"];
        }else {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
        NSLog(@"%@",error.localizedDescription);
        if (failure) {
            failure(error);
        }
    }];
}

//多张图片、单张图片、数据
+ (void)updateMoreData:(NSString *)url parameters:(NSDictionary *)parameters postimageName:(NSString *)postimageName postimageArrName:(NSString *)postimageArrName image:(UIImage *)image imageArr:(NSArray *)imageArr success:(void (^)(id))success failure:(void (^)(NSError *))failure {

    NSString *conplishURl = nil;
    
    conplishURl = [NSString stringWithFormat:@"%@%@",BASE_URL,url];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //配置网络请求超市时间
    manager.requestSerializer.timeoutInterval = 10;
    //设置MIME类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/plain",@"text/xml",nil];
    
    
    [manager POST:conplishURl parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (int i = 0; i < imageArr.count + 1; i ++) {
            if (i == imageArr.count) {
                NSData *imageData = UIImageJPEGRepresentation(image, 0.2);
                NSDateFormatter *dataDormatter = [[NSDateFormatter alloc] init];
                dataDormatter.dateFormat = @"yyyyMMddHHmmss";
                NSString *str = [dataDormatter stringFromDate:[NSDate date]];
                NSString *fileName = [NSString stringWithFormat:@"%@.jpg",str];
                
                [formData appendPartWithFileData:imageData name:postimageName fileName:fileName mimeType:@"image/jpg"];
            }else{
                UIImage *imageOne = imageArr[i];
                NSData *imageData = UIImageJPEGRepresentation(imageOne, 0.5);
                NSDateFormatter *dataDormatter = [[NSDateFormatter alloc] init];
                dataDormatter.dateFormat = @"yyyyMMddHHmmss";
                NSString *str = [dataDormatter stringFromDate:[NSDate date]];
                NSString *fileName = [NSString stringWithFormat:@"%@.jpg",str];
                
                [formData appendPartWithFileData:imageData name:postimageArrName fileName:fileName mimeType:@"image/jpg"];
            }
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"-=-=-=-responseObject=-=-=-%@",responseObject);
        if ([responseObject[@"code"] integerValue] == 200) {
            if (success) {
                success(responseObject);
            }
        }else {
            if (![responseObject[@"message"] isKindOfClass:[NSNull class]]) {
                NSError *error = [[NSError alloc] initWithDomain:NSCocoaErrorDomain code:[responseObject[@"code"] integerValue] userInfo:nil];
                [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
                if (failure) {
                    failure(error);
                }
            }else {
                NSError *error = [[NSError alloc] initWithDomain:NSCocoaErrorDomain code:[responseObject[@"code"] integerValue] userInfo:nil];
                if (failure) {
                    failure(error);
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ([error.localizedDescription isEqualToString:@"The Internet connection appears to be offline."]) {
            [SVProgressHUD showErrorWithStatus:@"请检查网络设置"];
        }else {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
        NSLog(@"%@",error.localizedDescription);
        if (failure) {
            failure(error);
        }
    }];
}

//上传图片
+ (void)POSTUPLOAD:(NSString *)url parameters:(NSDictionary *)parmeters andImage:(UIImage *)image success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failue
{
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",BASE_URL,url];
    AFHTTPSessionManager *manage = [AFHTTPSessionManager manager];
    //请求格式
    manage.requestSerializer =[AFJSONRequestSerializer serializer];
    //加上https ssl验证
    //    [manage setSecurityPolicy:[NetRequest customSecurityPolicy]];
    //返回数据格式
    manage.responseSerializer = [AFJSONResponseSerializer serializer];
    [manage.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json",@"text/json",@"text/javatext",@"text/html", nil]];
    //  [manage.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [manage POST:urlString parameters:parmeters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //构造数据
        NSData *dataObj = UIImageJPEGRepresentation(image, 1.0);
        [formData appendPartWithFileData:dataObj name: @"file" fileName:[NSString stringWithFormat:@"%d.png",0] mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"进度:%f",uploadProgress.fractionCompleted);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failue) {
            failue(error);
        }
    }];
    
}
@end
