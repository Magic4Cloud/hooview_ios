//
//  BTToolFormatJudge.m
//  BBHTeacher
//

//  Created by huang on 16/4/7..
//  Copyright © 2016年 CD. All rights reserved.
//

#import "BTToolFormatJudge.h"
@implementation BTToolFormatJudge




+ (BOOL)chenckName:(NSString*)name
{
    NSString *passWordRegex = @"[\u4e00-\u9fa5-a-zA-Z0-9]{4,16}";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:name];
}




+ (BOOL)ZHPredicateJudgeWithString:(NSString*)content withPredicateStr:(NSString*)predicateStr
{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",predicateStr];
    return [predicate evaluateWithObject:content];
}


//替换掉所有的空格和换行符号
+ (NSString*)replaceKonggeAndHuanhangfuWithString:(NSString*)contentStr
{
    contentStr = [contentStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    //去掉所有的空格和换行符
    contentStr = [contentStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    contentStr = [contentStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return contentStr;
}
//不包含空格
//"^[^\\s]*$"
//不包含中文
//"^[^\u4e00-\u9fa5]*$"
//6-16位长度
//"^.{6,16}$"

// 包含中文字符  空格
//+ (BTToolFormatJudgeType)includeChineseStr:(NSString*)str
//{
//    //不包含空格 或者换行符
//    NSString *passWordRegex = @"^[^\\s]*$";
//    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
//    BOOL isTure = [passWordPredicate evaluateWithObject:str];
//    if (!isTure)
//    {
//        ZHLog(@"包含换行符");
//        return BTToolFormatJudgeTypeIncludeKonggeOrHuanhang;
//    }
//    
//    
//    NSString *passWordRegex1 = @"^[^\u4e00-\u9fa5]*$";
//    NSPredicate *passWordPredicate1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex1];
//    isTure = [passWordPredicate1 evaluateWithObject:str];
//    
//    if (!isTure)
//    {
//        ZHLog(@"包含中文字符");
//        return BTToolFormatJudgeTypeIncludeChinese;
//    }
//    return BTToolFormatJudgeTypeIncludeNone;
//}



/*
#pragma 正则匹员工号, 12 位的数字
+ (BOOL)checkEmployeeNumber : (NSString *) number
{
    NSString *pattern = @"^[ 0 - 9 ]{ 12 }";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat: @"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:number];
    return isMatch;
    
}

 #pragma 正则匹配用户姓名, 20 位的中文或英文
 + (BOOL)checkUserName : (NSString *) userName
 {
 NSString *pattern = @"^[a-zA-Z一-龥]{ 1 , 20 }";
 NSPredicate *pred = [NSPredicate predicateWithFormat: @"SELF MATCHES %@", pattern];
 BOOL isMatch = [pred evaluateWithObject:userName];
 return isMatch;
 
 }
 
 //身份证号
 + (BOOL) validateIdentityCard: (NSString *)identityCard
 {
 BOOL flag;
 
 if (identityCard.length <= 0) {
 
 flag = NO;
 
 return flag;
 
 }
 
 NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
 
 NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
 return [identityCardPredicate evaluateWithObject:identityCard];
 
 }
 
#pragma 正则匹配URL
+ (BOOL)checkURL : (NSString *) url
{
    NSString *pattern = @"^[ 0 -9A-Za-z]{ 1 , 50 }";
    NSPredicate *pred = [NSPredicate predicateWithFormat: @"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:url];
    return isMatch;
}
 

 
 #pragma 正则匹配用户密码 6 - 16 位数字和字母组合
 + (BOOL)checkPassword:(NSString *) password
 {
 NSString *passWordRegex = @"^[a-zA-Z0-9]{6,16}+$";
 NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
 return [passWordPredicate evaluateWithObject:password];
 }
 
 #pragma 正则匹配手机号
 + (BOOL)checkTelNumber:(NSString *) telNumber
 {
 NSString *MOBILE = @"^1[34578]\\d{9}$";
 NSPredicate *regexTestMobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",MOBILE];
 return [regexTestMobile evaluateWithObject:telNumber];
 }
 */
@end
