//
//  BTToolFormatJudge.h
//  BBHTeacher
//

// ******************** create By ZH ********************
// ******************** QQ:137940556 ******************** 

//  Created by huang on 16/4/7.
//  Copyright © 2016年 CD. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum BTToolFormatJudgeType
{
    //** 包含汉字*/
    BTToolFormatJudgeTypeIncludeChinese = 0,
    //** 不包含汉字*/
    BTToolFormatJudgeTypeNotIncludeChinese = 1,
    //** 包含数字*/
    BTToolFormatJudgeTypeIncludNumber = 2,
    //** 不包含数字*/
    BTToolFormatJudgeTypeNotIncludeNumber = 3,
    //** 包含换行符或者空格*/
    BTToolFormatJudgeTypeIncludeKonggeOrHuanhang = 4,
    //** 不包含换行符或者空格*/
    BTToolFormatJudgeTypeNotIncludeKonggeOrHuanhang = 5,
    BTToolFormatJudgeTypeIncludeNone,
}BTToolFormatJudgeType;
@interface BTToolFormatJudge : NSObject
// 匹配手机好
//+ (BOOL)checkTelNumber:(NSString *) telNumber;
// 正则匹配用户密码 6 - 18 位数字和字母组合
//+ (BOOL)checkPassword:(NSString *) password;

// 替换掉所有的空格和字符串
+ (NSString*)replaceKonggeAndHuanhangfuWithString:(NSString*)contentStr;
//+ (BTToolFormatJudgeType)includeChineseStr:(NSString*)str;


// 字母-数字-汉字的组合
+ (BOOL)chenckName:(NSString*)name;

/**
 *  正则表达式使用
 *
 *  @param content      <#content description#>
 *  @param predicateStr <#predicateStr description#>
 *
 *  @return <#return value description#>
 */
+ (BOOL)ZHPredicateJudgeWithString:(NSString*)content withPredicateStr:(NSString*)predicateStr;






@end
