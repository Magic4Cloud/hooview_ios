//
//  NSString+Extension.m
//  wuyuexin
//
//  Created by 刘杰 on 17/5/8.
//  Copyright © 2017年 even. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)
+ (CGSize) stringLengthWithStr:(NSString *)str width:(CGFloat)width height:(CGFloat)height font:(CGFloat)font{
    CGSize size = [str boundingRectWithSize:CGSizeMake(width, height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil].size;
    return size;
}

+ (CGSize)stringLengthWithAttrStr:(NSString *)attrStr width:(CGFloat)width font:(CGFloat)font lineSpace:(CGFloat)lineSpace {
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:lineSpace];
    
    CGSize size = [attrStr boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font],NSParagraphStyleAttributeName : style,NSKernAttributeName:@1.0f} context:nil].size;
    return size;
}

+ (NSAttributedString *)stringWithFullStr:(NSString *)fullStr subStr:(NSString *)subStr normolColor:(NSString *)color normalFontSize:(CGFloat)fontSize weightColor:(NSString *)weightColor weightFontSize:(CGFloat)wieghtFontSize {
    NSMutableAttributedString *tempStr = [[NSMutableAttributedString alloc] initWithString:fullStr attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:color],NSFontAttributeName : [UIFont boldSystemFontOfSize:fontSize]}];
    NSRange range = [fullStr rangeOfString:subStr];
    if (range.location != NSNotFound) {
        [tempStr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:weightColor],NSFontAttributeName : [UIFont boldSystemFontOfSize:wieghtFontSize]} range:range];
    }
    return [tempStr copy];
}




@end
