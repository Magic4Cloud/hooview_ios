//
//  WYXFactory.h
//  wuyuexin
//
//  Created by 刘杰 on 17/5/8.
//  Copyright © 2017年 even. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYXFactory : NSObject

/**验证手机号*/
+ (BOOL)isMobileNumber:(NSString *)mobileNum;

/**验证邮箱*/
+ (BOOL) validateEmail:(NSString *)email;

/**验证密码（可以是纯数字,字母或者下划线 6-18）*/
+ (BOOL) validatePassword:(NSString *)passWord;
/**验证输入是否是数字字母下划线*/
+ (BOOL) valifyNumberWordAndUnderline:(NSString *)name;

/**验证用户名*/
+ (BOOL) validateUserName:(NSString *)name;
/**验证输入是否是中文数字字母下划线*/
+ (BOOL) valifyChinsesNumberWordAndUnderline:(NSString *)name;

/**验证输入的是否是数字*/
+ (BOOL) valifyNumber:(NSString *)number;

/**验证输入含有表情*/
+(BOOL)stringContainsEmoji:(NSString *)string;

/**验证中文*/
+ (BOOL) validateChinese:(NSString *)chinese;
/**验证中文名字*/
+ (BOOL) validateChineseName:(NSString *)chineseName;

/**限制输入字符串长度*/
+ (void) limitTextFieldTextLenght:(UITextField *)textField leght:(NSInteger)lenght;

/**MD5加密*/
+ (NSString *)MD5StringFromString:(NSString *)str;
/**AES加密*/
+ (NSString *)AES128Encrypt:(NSString *)string key:(NSString *)key salt:(NSString *)salt;
/**AES解密*/
+ (NSString *)AES128Decrypt:(NSString *)string key:(NSString *)key salt:(NSString *)salt;

/**时间戳转化为字符串*/
+ (NSString *)getDateStringWithStr:(NSString *)str;
/**根据对应的时间格式将时间戳转化为字符串*/
+ (NSString *)getDateStringWithStr:(NSString *)str format:(NSString *)format;

+ (NSString *)getDateStringWithDate:(NSDate *)date

                         DateFormat:(NSString *)formatString;
/**验证空格字符串 nil 空字符串*/
+ (BOOL)validateBlankString:(NSString *)string;
/**是否开启摄像头权限*/
+ (BOOL)canMedia;

+ (BOOL)isCanUsePhotos;

/**
 *  判断对象是否为空
 *  PS：nil、NSNil、@""、@0 以上4种返回YES
 *
 *  @return YES 为空  NO 为实例对象
 */
+ (BOOL)dx_isNullOrNilWithObject:(id)object;

@end
