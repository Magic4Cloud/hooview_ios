//
//  CHYPublic.m
//  XueZhiFei
//
//  Created by apple on 2017/11/8.
//  Copyright © 2017年 ZPF Mac Pro. All rights reserved.
//

#import "CHYPublic.h"

@implementation CHYPublic


+ (UIButton *)rwButtonWithCareWith:(NSString *)title tag:(NSInteger)tag image:(NSString *)image  font:(UIFont *)font{
    
    UIButton *button = [[UIButton alloc] init];
    //    [button setTitle:title forState:UIControlStateNormal];
    if ([title isEqualToString:@"选择科目 "] || [title isEqualToString:@"选择学龄段 "]) {
        [button setTitleColor:UIColorFromHex(0x535E6C) forState:UIControlStateNormal];
    }else{
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    button.tag = tag;
//    [button addTarget:self action:@selector(carButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *tempGroup = [NSString stringWithFormat:@"%@ ",title];
    NSMutableAttributedString *ms = [[NSMutableAttributedString alloc] initWithString:tempGroup];
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    attch.image = [UIImage imageNamed:image];
    if (attch.image) {
        if (tag == 100) {
            attch.bounds = CGRectMake(0,(font.lineHeight - 4.5)/2/2,8.5,4.5);
        }
        else{
            attch.bounds = CGRectMake(0,(font.lineHeight - 12)/2/2 - 2,14,12);
        }
    }
    else{
        attch.bounds = CGRectMake(0,0,0,0);
    }
    NSAttributedString *imageString = [NSAttributedString attributedStringWithAttachment:attch];
    [ms replaceCharactersInRange:NSMakeRange(title.length, 1) withAttributedString:imageString];
    
    NSMutableParagraphStyle   *paragraphStyle   = [[NSMutableParagraphStyle alloc] init];
    [ms addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, [tempGroup length])];
    if ([title isEqualToString:@"选择科目 "] || [title isEqualToString:@"选择学龄段 "]) {
        [ms addAttribute:NSForegroundColorAttributeName value:UIColorFromHex(0x535E6C) range:NSMakeRange(0, [tempGroup length])];
    }else{
        [ms addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [tempGroup length])];
    }
    [ms addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [tempGroup length])];
    [button setAttributedTitle:ms forState:UIControlStateNormal];
    return button;
}

+ (NSMutableAttributedString *)returnAttributedStringWith:(UIFont *)font textColor:(UIColor *)color imageName:(NSString *)imageName insertIndex:(NSInteger)index content:(NSString *)title tag:(NSInteger)tag{
    NSString *tempGroup = [NSString stringWithFormat:@"%@ ",title];
    NSMutableAttributedString *ms = [[NSMutableAttributedString alloc] initWithString:tempGroup];
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    attch.image = [UIImage imageNamed:imageName];
    if (attch.image) {
        if (tag == 100) {
            attch.bounds = CGRectMake(0,(font.lineHeight - 4.5)/2/2,8.5,4.5);
        }
        else{
            attch.bounds = CGRectMake(0,(font.lineHeight - 12)/2/2 - 2,14,12);
        }
    }
    else{
        attch.bounds = CGRectMake(0,0,0,0);
    }
    NSAttributedString *imageString = [NSAttributedString attributedStringWithAttachment:attch];
    [ms replaceCharactersInRange:NSMakeRange(title.length, 1) withAttributedString:imageString];
    
    NSMutableParagraphStyle   *paragraphStyle   = [[NSMutableParagraphStyle alloc] init];
    [ms addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, [tempGroup length])];
    [ms addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, [tempGroup length])];
    [ms addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [tempGroup length])];
    return ms;
}

+ (UIView *)rwNodataWith:(NSString *)imageName andTip:(NSString *)tips bottomMagin:(CGFloat)height{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = [UIImage imageNamed:imageName];
    imageView.tag = 9999;
    
    UILabel *label = [[UILabel alloc] init];
    label.text = tips;
    label.font = [UIFont pingfangFontWithSize:18];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = RGB(74, 74, 74, 1.0);
    label.tag = 8888;
    UIView *endView = [[UIView alloc] init];
    endView.backgroundColor = [UIColor whiteColor];
    
    [endView addSubview:imageView];
    [endView addSubview:label];
    
    [imageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(endView).offset(20);
        make.left.right.equalTo(endView).offset(0);
    }];
    [label mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).offset(20);
        make.bottom.equalTo(endView).offset(-(height));
        make.height.offset(20);
        make.left.right.equalTo(endView).offset(0);
    }];
    
    
    return endView;
}

+ (NSMutableAttributedString *)returnAttributedStringWith:(UIFont *)font textColor:(UIColor *)color imageName:(NSString *)imageName insertIndex:(NSInteger)index content:(NSString *)title frame:(CGRect)frame{
    NSString *tempGroup = title;
    if (index == 0) {
        tempGroup = [NSString stringWithFormat:@"  %@",title];
    }
    else if (index >= title.length){
        tempGroup = [NSString stringWithFormat:@"%@  ",title];
        index = title.length;
        index += 1;
    }
    else{
        tempGroup = [NSString stringWithFormat:@"%@   %@",[title substringToIndex:index],[title substringFromIndex:index]];
        index += 1;
    }
    
    NSMutableAttributedString *ms = [[NSMutableAttributedString alloc] initWithString:tempGroup];
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    attch.image = [UIImage imageNamed:imageName];
    if (attch.image) {
        attch.bounds = frame;
    }
    else{
        attch.bounds = CGRectMake(0,0,0,0);
    }
    NSAttributedString *imageString = [NSAttributedString attributedStringWithAttachment:attch];
    [ms replaceCharactersInRange:NSMakeRange(index, 1) withAttributedString:imageString];
    
    NSMutableParagraphStyle   *paragraphStyle   = [[NSMutableParagraphStyle alloc] init];
    [ms addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, [tempGroup length])];
    [ms addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, [tempGroup length])];
    [ms addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [tempGroup length])];
    return ms;
}

+ (UILabel *)rwLabelWith:(NSString *)title font:(UIFont *)font textColor:(UIColor *)color lineNumber:(NSInteger)index{
    UILabel *label = [[UILabel alloc] init];
    label.text = title;
    label.textColor = color;
    label.font = font;
    label.numberOfLines = index;
    return label;
}

+ (NSMutableAttributedString *)returnAttributedStringWith:(NSString *)firstName seconedName:(NSString *)seconedName andAllText:(NSString *)allText font:(UIFont *)font heightColor:(UIColor *)height normalColor:(UIColor *)color{
    
    NSMutableAttributedString *ms = [[NSMutableAttributedString alloc] initWithString:allText];
    
    [ms addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, allText.length)];
    [ms addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, allText.length)];
    
    
    NSRange first = [allText rangeOfString:firstName];
    NSRange secoend = [allText rangeOfString:seconedName];
    
    if (first.location != NSNotFound) {
        [ms addAttribute:NSForegroundColorAttributeName value:height range:first];
    }
    
    if (secoend.location != NSNotFound) {
        [ms addAttribute:NSForegroundColorAttributeName value:height range:secoend];
    }
    
    return ms;
}

@end
