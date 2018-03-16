//
//  BTToolFormatJudge+ZH.m
//  BBHTeacher
//
//  Created by huang on 16/4/7.
//  Copyright © 2016年 CD. All rights reserved.
//

#import "BTToolFormatJudge+ZH.h"

@implementation BTToolFormatJudge (ZH)


//适配密码
+ (BOOL)adapterPassword:(NSString*)password
{
    BOOL   isTure = [BTToolFormatJudge ZHPredicateJudgeWithString:password withPredicateStr:@"^.{6,16}$"];
    if (!isTure)
    {
//        ZHLog(@"请输入6-16位密码");
//        [MBProgressHUD showWithView:ZHKeyWindow WithText:@"请输入6-16位密码" afterDelay:2];
        [SVProgressHUD setMinimumDismissTimeInterval:1];
        [SVProgressHUD showErrorWithStatus:@"请输入6-16位密码"];

        return NO;
    }
    //不包含空格 或者换行符
        isTure = [BTToolFormatJudge ZHPredicateJudgeWithString:password withPredicateStr:@"^[^\\s]*$"];
    if (!isTure)
    {
//            [MBProgressHUD showWithView:ZHKeyWindow WithText:@"密码不能包含空格和换行" afterDelay:2];
        [SVProgressHUD setMinimumDismissTimeInterval:1];
        [SVProgressHUD showErrorWithStatus:@"密码不能包含空格和换行"];
            return NO;
    }
    
    //不包括汉字
    isTure = [BTToolFormatJudge ZHPredicateJudgeWithString:password withPredicateStr:@"^[^\u4e00-\u9fa5]*$"];
    
    if (!isTure)
    {
//        ZHLog(@"包含中文字符");
//        [MBProgressHUD showWithView:ZHKeyWindow WithText:@"密码不能包含中文字符" afterDelay:2];
        [SVProgressHUD setMinimumDismissTimeInterval:1];
        [SVProgressHUD showErrorWithStatus:@"密码不能包含中文字符"];
        return NO;
    }
    return YES;
}
//适配登录帐号
+ (BOOL)adapterUserNumber:(NSString*)UserNumber{
    BOOL   isTure = [BTToolFormatJudge ZHPredicateJudgeWithString:UserNumber withPredicateStr:@"^.{0,50}$"];
    //不包含空格 或者换行符
    isTure = [BTToolFormatJudge ZHPredicateJudgeWithString:UserNumber withPredicateStr:@"^[^\\s]*$"];
    if (!isTure)
    {
//        [MBProgressHUD showWithView:ZHKeyWindow WithText:@"用户名不能包含空格和换行" afterDelay:2];
        [SVProgressHUD setMinimumDismissTimeInterval:1];
        [SVProgressHUD showErrorWithStatus:@"用户名不能包含空格和换行"];
        return NO;
    }
    return YES;
}


//适配电话号码
+ (BOOL)adapterTelephone:(NSString*)telephoe
{
    BOOL   isTure = [BTToolFormatJudge ZHPredicateJudgeWithString:telephoe withPredicateStr:@"^.{11}$"];
    if (!isTure)
    {
//        ZHLog(@"请输入11位手机号");
//        [MBProgressHUD showWithView:ZHKeyWindow WithText:@"请输入11位手机号" afterDelay:2];
        [SVProgressHUD setMinimumDismissTimeInterval:1];
        [SVProgressHUD showErrorWithStatus:@"请输入11位手机号"];
        return NO;
    }
    
    if (![BTToolFormatJudge ZHPredicateJudgeWithString:telephoe withPredicateStr:@"^1[34578]\\d{9}$"])
    {
//        [MBProgressHUD showWithView:ZHKeyWindow WithText:@"手机号格式不对" afterDelay:2];
        [SVProgressHUD setMinimumDismissTimeInterval:1];
        [SVProgressHUD showErrorWithStatus:@"手机号格式不对"];
        return NO;
    }
    return YES;
}
+ (BOOL)adapterCardId:(NSString*)cardId
{
    BOOL  ture1 = [BTToolFormatJudge ZHPredicateJudgeWithString:cardId withPredicateStr:@"[0-9]{17}x"];
    BOOL  ture2 = [BTToolFormatJudge ZHPredicateJudgeWithString:cardId withPredicateStr:@"[0-9]{15}"];
    BOOL  ture3 = [BTToolFormatJudge ZHPredicateJudgeWithString:cardId withPredicateStr:@"[0-9]{18}"];
    BOOL  ture4 = [BTToolFormatJudge ZHPredicateJudgeWithString:cardId withPredicateStr:@"[0-9]{17}X"];
    
    if (ture1 || ture2 || ture3 || ture4)
    {
        return YES;
    }
    else
    {
//        [MBProgressHUD showWithView:ZHKeyWindow WithText:@"身份证号格式不正确" afterDelay:2];
        [SVProgressHUD setMinimumDismissTimeInterval:1];
        [SVProgressHUD showErrorWithStatus:@"身份证号格式不正确"];
        return NO;
    }
}//适配姓名  16
+ (BOOL)adapterRealName_lengthOf_16:(NSString *)userName
{
    
    if (userName.length == 0)
    {
//        [MBProgressHUD showWithView:ZHKeyWindow WithText:@"姓名不能为空" afterDelay:2];
        [SVProgressHUD setMinimumDismissTimeInterval:1];
        [SVProgressHUD showErrorWithStatus:@"姓名不能为空"];
        return NO;
    }
    if (userName.length > 16)
    {
//        [MBProgressHUD showWithView:ZHKeyWindow WithText:@"姓名最大长度16个字符" afterDelay:2];
        [SVProgressHUD setMinimumDismissTimeInterval:1];
        [SVProgressHUD showErrorWithStatus:@"姓名最大长度16个字符"];
        return NO;
    }
    
    if (![BTToolFormatJudge ZHPredicateJudgeWithString:userName withPredicateStr:@"[\u4e00-\u9fa5-a-zA-Z0-9]{1,16}"])
    {
//        [MBProgressHUD showWithView:ZHKeyWindow WithText:@"姓名只能输入汉字，字母，数字" afterDelay:2];
        [SVProgressHUD setMinimumDismissTimeInterval:1];
        [SVProgressHUD showErrorWithStatus:@"姓名只能输入汉字，字母，数字"];
        return NO;
    }
    return YES;
}
//适配用户名  16
+ (BOOL)adapterUserName_lengthOf_16:(NSString *)userName
{
    
    if (userName.length == 0)
    {
//        [MBProgressHUD showWithView:ZHKeyWindow WithText:@"用户名不能为空" afterDelay:2];
        [SVProgressHUD setMinimumDismissTimeInterval:1];
        [SVProgressHUD showErrorWithStatus:@"用户名不能为空"];
        return NO;
    }
    if (userName.length > 16)
    {
//        [MBProgressHUD showWithView:ZHKeyWindow WithText:@"用户名最大长度16个字符" afterDelay:2];
        [SVProgressHUD setMinimumDismissTimeInterval:1];
        [SVProgressHUD showErrorWithStatus:@"用户名最大长度16个字符"];
        return NO;
    }
    
    if (![BTToolFormatJudge ZHPredicateJudgeWithString:userName withPredicateStr:@"[\u4e00-\u9fa5-a-zA-Z0-9]{1,16}"])
    {
//        [MBProgressHUD showWithView:ZHKeyWindow WithText:@"用户名只能输入汉字，字母，数字" afterDelay:2];
        [SVProgressHUD setMinimumDismissTimeInterval:1];
        [SVProgressHUD showErrorWithStatus:@"用户名只能输入汉字，字母，数字"];
        return NO;
    }
    return YES;
}
//匹配昵称
+ (BOOL)adapterNickName_lengthOf_16:(NSString *)nickName
{
    
    if (nickName.length == 0)
    {
//        [MBProgressHUD showWithView:ZHKeyWindow WithText:@"昵称不能为空" afterDelay:2];
        [SVProgressHUD setMinimumDismissTimeInterval:1];
        [SVProgressHUD showErrorWithStatus:@"称不能为空"];
        return NO;
    }
    if (nickName.length > 16)
    {
//        [MBProgressHUD showWithView:ZHKeyWindow WithText:@"昵称最大长度16个字符" afterDelay:2];
        [SVProgressHUD setMinimumDismissTimeInterval:1];
        [SVProgressHUD showErrorWithStatus:@"称最大长度16个字符"];
        return NO;
    }
    
//    if (![BTToolFormatJudge ZHPredicateJudgeWithString:nickName withPredicateStr:@"^.{1,16}$"])
//    {
//        [MBProgressHUD showWithView:ZHKeyWindow WithText:@"请输入1-16位昵称" afterDelay:2];
//        return NO;
//    }
    if (![BTToolFormatJudge ZHPredicateJudgeWithString:nickName withPredicateStr:@"[\u4e00-\u9fa5-a-zA-Z0-9]{1,16}"])
    {
//        [MBProgressHUD showWithView:ZHKeyWindow WithText:@"昵称只能输入汉字，字母，数字" afterDelay:2];
        [SVProgressHUD setMinimumDismissTimeInterval:1];
        [SVProgressHUD showErrorWithStatus:@"昵称只能输入汉字，字母，数字"];
        return NO;
    }
    return YES;
}

//适配姓名  32位
+ (BOOL)adapterUserName_lengthOf_32:(NSString *)userName
{
    if (userName.length == 0)
    {
//        [MBProgressHUD showWithView:ZHKeyWindow WithText:@"姓名不能为空" afterDelay:2];
        [SVProgressHUD setMinimumDismissTimeInterval:1];
        [SVProgressHUD showErrorWithStatus:@"姓名不能为空"];
        return NO;
    }
    if (userName.length > 32)
    {
//        [MBProgressHUD showWithView:ZHKeyWindow WithText:@"姓名最大长度32个字符" afterDelay:2];
        [SVProgressHUD setMinimumDismissTimeInterval:1];
        [SVProgressHUD showErrorWithStatus:@"姓名最大长度32个字符"];
        return NO;
    }
    
//    if (![BTToolFormatJudge ZHPredicateJudgeWithString:userName withPredicateStr:@"^.{1,32}$"])
//
//{
//    [MBProgressHUD showWithView:ZHKeyWindow WithText:@"请输入1-32位用户名" afterDelay:2];
//    return NO;
//}
    if (![BTToolFormatJudge ZHPredicateJudgeWithString:userName withPredicateStr:@"[\u4e00-\u9fa5-a-zA-Z0-9]{1,32}"])
    {
//        [MBProgressHUD showWithView:ZHKeyWindow WithText:@"姓名只能输入汉字，字母，数字" afterDelay:2];
        [SVProgressHUD setMinimumDismissTimeInterval:1];
        [SVProgressHUD showErrorWithStatus:@"姓名只能输入汉字，字母，数字"];
        return NO;
    }
    return YES;
}
//发送验证码
+ (BOOL)adapterAuthCode:(NSString*)authCode
{
    
    if (![BTToolFormatJudge ZHPredicateJudgeWithString:authCode withPredicateStr:@"^[0-9]{6}$"])
    {
//        [MBProgressHUD showWithView:ZHKeyWindow WithText:@"请输入6位验证码" afterDelay:2];
        [SVProgressHUD setMinimumDismissTimeInterval:1];
        [SVProgressHUD showErrorWithStatus:@"请输入6位验证码"];
        return NO;
    }
    return YES;
    
}
//匹配邀请码
+ (BOOL)adapterSecurityCode:(NSString *)SecurityCode{
    if (SecurityCode.length == 0)
    {
//        [MBProgressHUD showWithView:ZHKeyWindow WithText:@"邀请码不能为空" afterDelay:2];
        [SVProgressHUD setMinimumDismissTimeInterval:1];
        [SVProgressHUD showErrorWithStatus:@"邀请码不能为空"];
        return NO;
    }
    if (![BTToolFormatJudge ZHPredicateJudgeWithString:SecurityCode withPredicateStr:@"^[0-9]*$"])
    {
//        [MBProgressHUD showWithView:ZHKeyWindow WithText:@"请输入正确的邀请码" afterDelay:1];
        [SVProgressHUD setMinimumDismissTimeInterval:1];
        [SVProgressHUD showErrorWithStatus:@"请输入正确的邀请码"];
        return NO;
    }
    return YES;
}

///**
// *  ************************************成长记录**********************************
// */
//+ (BOOL)adapterGrowWithWeight:(NSString *)Weight
//{
//    if (![BTToolFormatJudge ZHPredicateJudgeWithString:Weight withPredicateStr:@"^[0-9]*$"])
//    {
//        [MBProgressHUD showWithView:ZHKeyWindow WithText:@"体重格式不正确" afterDelay:2];
//        return NO;
//    }
//    if (Weight.floatValue > 150.f)
//    {
//        [MBProgressHUD showWithView:ZHKeyWindow WithText:@"体重不能超过150KG" afterDelay:2];
//        return NO;
//    }
//    else if (Weight.floatValue < 1.f)
//    {
//        [MBProgressHUD showWithView:ZHKeyWindow WithText:@"体重不能低于1KG" afterDelay:2];
//        return NO;
//    }
//    return YES;
//}
//+(BOOL)adapterGrowWithHeight:(NSString *)height
//{
//    if (![BTToolFormatJudge ZHPredicateJudgeWithString:height withPredicateStr:@"^[0-9]*$"])
//    {
//        [MBProgressHUD showWithView:ZHKeyWindow WithText:@"身高格式不正确" afterDelay:2];
//        return NO;
//    }
//    if (height.floatValue > 250.f)
//    {
//        [MBProgressHUD showWithView:ZHKeyWindow WithText:@"身高不能超过250cm" afterDelay:2];
//        return NO;
//    }
//    if (height.floatValue < 20.f)
//    {
//        [MBProgressHUD showWithView:ZHKeyWindow WithText:@"身高不能低于20cm" afterDelay:2];
//        return NO;
//    }
//    
//    return YES;
//}


/**
 *  ************************************匹配内容相关**********************************
 */
+ (BOOL)adapterContent:(NSString*)content andPredicateStr:(NSString*)predicateStr andMoreThanLengthRemindStr:(NSString*)remindStr
{
    NSString* replaceStr = [content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (![BTToolFormatJudge ZHPredicateJudgeWithString:content withPredicateStr:predicateStr])
    {
//        [MBProgressHUD showWithView:ZHKeyWindow WithText:remindStr afterDelay:1];
        [SVProgressHUD setMinimumDismissTimeInterval:1];
        [SVProgressHUD showErrorWithStatus:remindStr];
        return NO;
    }
    else if (replaceStr.length == 0)
    {
//        [MBProgressHUD showWithView:ZHKeyWindow  WithText:@"输入不能全为空格和换行符" afterDelay:1];
        [SVProgressHUD setMinimumDismissTimeInterval:1];
        [SVProgressHUD showErrorWithStatus:@"输入不能全为空格和换行符"];
        return NO;
    }
    return YES;
}
//数据不能为空
+ (BOOL) iSStringNull:(NSString *)string
{
    if (string == nil) {
        return YES;
    }
    if (string == Nil) {
        return YES;
    }
    if (string == NULL) {
        return NO;
    }
    if ([string isEqualToString:@"null"]) {
        return NO;
    }
    if ([string isEqualToString:@"(null)"]) {
        return YES;
    }
    
    if ([string isEqualToString:@"<null>"]) {
        return YES;
    }
    if ([string isEqual:[NSNull null]]) {
        return YES;
    }
    if ([string length] == 0) {
        return YES;
    }
    return NO;
}
@end
