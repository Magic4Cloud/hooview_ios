//
//  BTToolFormatJudge+ZH.h
//  BBHTeacher
//
//  Created by huang on 16/4/7.
//  Copyright © 2016年 CD. All rights reserved.
//
/**
 *
 *
 *                   输入框的限制         
 *
 *
 */

#import "BTToolFormatJudge.h"

@interface BTToolFormatJudge (ZH)
/**
 *  匹配密码
 *
 *  @param password 输入密码
 *
 *  @return 判断是否满足密码要求
 */
+ (BOOL)adapterPassword:(NSString*)password;
/**
 *  匹配手机号
 *
 *  @param telephoe 手机号码
 *
 *  @return 判断是否满足手机号的条件
 */
+ (BOOL)adapterTelephone:(NSString*)telephoe;

/**
 *  匹配用户名
 *
 *  @param UserNumber 用户名
 *
 *  @return 判断是否满足用户名的条件
 */
+ (BOOL)adapterUserNumber:(NSString*)UserNumber;

/**
 *  匹配用户名  最长16 位的
 *
 *  @param userName 用户名
 *
 *  @return 判断是否满足用户名的条件
 */
+ (BOOL)adapterUserName_lengthOf_16:(NSString *)userName;
/**
 *  匹配姓名  最长16 位的
 *
 *  @param userName 用户名
 *
 *  @return 判断是否满足用户名的条件
 */
+ (BOOL)adapterRealName_lengthOf_16:(NSString *)userName;
/**
 *  匹配昵称
 *
 */

+ (BOOL)adapterNickName_lengthOf_16:(NSString *)nickName;

/**
 *  匹配用户名  最长32 位的
 *
 *  @param userName 用户名
 *
 *  @return 判断是否满足用户名的条件
 */
+ (BOOL)adapterUserName_lengthOf_32:(NSString *)userName;


/**
 *  匹配身份证号
 *
 *  @param BOOL
 *
 *  @return
 */
+ (BOOL)adapterCardId:(NSString*)cardId;
/**
 *  匹配验证码
 *
 *  @param authCode 验证码
 *
 *  @return 判断是否满足条件
 */
+ (BOOL)adapterAuthCode:(NSString*)authCode;

/**
 *  匹配邀请码
 *
 *  @param authCode 邀请码
 *
 *  @return 判断是否满足条件
 */
+ (BOOL)adapterSecurityCode:(NSString*)SecurityCode;

/**
 *  适配身高
 *
 *  @param height 身高
 *
 *  @return <#return value description#>
 */
+ (BOOL)adapterGrowWithHeight:(NSString*)height;

/**
 *  适配体重
 *
 *  @param Weight 体重
 *
 *  @return
 */
+ (BOOL)adapterGrowWithWeight:(NSString*)Weight;


/**
 *  ************************************匹配内容相关**********************************
 */
/**
 *  匹配内容输入，
 *
 *  @param content      需要验证的文本
 *  @param predicateStr 正则表达式
 *  @param remindStr    提示语句
 *
 *  @return <#return value description#>
 */
+ (BOOL)adapterContent:(NSString*)content andPredicateStr:(NSString*)predicateStr andMoreThanLengthRemindStr:(NSString*)remindStr;

//数据不能为空
+ (BOOL) iSStringNull:(NSString *)string;
@end
