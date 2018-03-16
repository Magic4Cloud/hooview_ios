//
//  NSString+Extension.h
//  wuyuexin
//
//  Created by 刘杰 on 17/5/8.
//  Copyright © 2017年 even. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

/**计算字符串高度*/
+ (CGSize) stringLengthWithStr:(NSString *)str width:(CGFloat)width height:(CGFloat)height font:(CGFloat)font;

/**计算富文本高度*/
+ (CGSize) stringLengthWithAttrStr:(NSString *)attrStr width:(CGFloat)width font:(CGFloat)font lineSpace:(CGFloat)lineSpace;

/**处理多种颜色字符串*/
+ (NSAttributedString *)stringWithFullStr:(NSString *)fullStr subStr:(NSString *)subStr normolColor:(NSString *)color normalFontSize:(CGFloat)fontSize weightColor:(NSString *)weightColor weightFontSize:(CGFloat)wieghtFontSize;


@end
