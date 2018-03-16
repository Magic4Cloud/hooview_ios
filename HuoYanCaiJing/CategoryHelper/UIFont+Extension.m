//
//  UIFont+Extension.m
//  wuyuexin
//
//  Created by 刘杰 on 17/5/8.
//  Copyright © 2017年 even. All rights reserved.
//

#import "UIFont+Extension.h"

@implementation UIFont (Extension)

+(UIFont *)pingfangFontWithSize:(CGFloat)size {
//    return [UIFont fontWithName:@".PingFang-SC-Medium" size:size];
    return [UIFont systemFontOfSize:size];
}

+(UIFont *)pingfangBoldFontWithSize:(CGFloat)size {
//    return [UIFont fontWithName:@".PingFang-SC-Semibold" size:size];
    return [UIFont systemFontOfSize:size];
}

+ (UIFont *)pingfangRegularFontWithSize:(CGFloat)size {
//     return [UIFont fontWithName:@".PingFang-SC-Regular" size:size];
    return [UIFont systemFontOfSize:size];
}
@end
