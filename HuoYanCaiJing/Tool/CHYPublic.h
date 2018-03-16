//
//  CHYPublic.h
//  XueZhiFei
//
//  Created by apple on 2017/11/8.
//  Copyright © 2017年 ZPF Mac Pro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHYPublic : NSObject


/**
 快速创建含有图标的按钮

 @param title 按钮文字
 @param tag tag
 @param image 图片名
 @param font 图片名
 @return button
 */
+ (UIButton *)rwButtonWithCareWith:(NSString *)title tag:(NSInteger)tag image:(NSString *)image font:(UIFont *)font;


/**
 转换成富文本

 @param font font
 @param color color
 @param imageName image Name
 @param index image index
 @param title title
 @param tag title
 @return id
 */
+ (NSMutableAttributedString *)returnAttributedStringWith:(UIFont *)font textColor:(UIColor *)color imageName:(NSString *)imageName insertIndex:(NSInteger)index content:(NSString *)title tag:(NSInteger)tag;

+ (UIView *)rwNodataWith:(NSString *)imageName andTip:(NSString *)tips bottomMagin:(CGFloat)height;

+ (UILabel *)rwLabelWith:(NSString *)title font:(UIFont *)font textColor:(UIColor *)color lineNumber:(NSInteger)index;

+ (NSMutableAttributedString *)returnAttributedStringWith:(UIFont *)font textColor:(UIColor *)color imageName:(NSString *)imageName insertIndex:(NSInteger)index content:(NSString *)title frame:(CGRect)frame;

+ (NSMutableAttributedString *)returnAttributedStringWith:(NSString *)firstName seconedName:(NSString *)seconedName andAllText:(NSString *)allText font:(UIFont *)font heightColor:(UIColor *)height normalColor:(UIColor *)color;
@end
