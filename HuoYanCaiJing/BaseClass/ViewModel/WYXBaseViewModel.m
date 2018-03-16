//
//  WYXBaseViewModel.m
//  wuyuexin
//
//  Created by 刘杰 on 17/5/8.
//  Copyright © 2017年 even. All rights reserved.
//

#import "WYXBaseViewModel.h"

@implementation WYXBaseViewModel

+ (instancetype)model {
    @throw [NSException
            exceptionWithName:@"object is nil"
            reason:@"子类实现"
            userInfo:nil];
}

- (void)loadDataWithSuccess:(void (^)(id))success{
    @throw [NSException
            exceptionWithName:@"object is nil"
            reason:@"子类实现"
            userInfo:nil];
}

- (void)loadDataWithSuccess:(void (^)(id))success failure:(void (^)(void))failure {
    @throw [NSException
            exceptionWithName:@"object is nil"
            reason:@"子类实现"
            userInfo:nil];
}

@end
