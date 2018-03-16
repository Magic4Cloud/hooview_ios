//
//  UIImage+FEBoxBlur.h
//  Education
//
//  Created by shilei on 17/4/6.
//  Copyright © 2017年 CD. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <Accelerate/Accelerate.h>

@interface UIImage (FEBoxBlur)
/**
 *  CoreImage图片高斯模糊
 *
 *  @param image 图片
 *  @param blur  模糊数值(默认是10)
 *
 *  @return 重新绘制的新图片
 */

+(UIImage *)coreBlurImage:(UIImage *)image withBlurNumber:(CGFloat)blur;
/**
 *  vImage模糊图片
 *
 *  @param image 原始图片
 *  @param blur  模糊数值(0-1)
 *
 *  @return 重新绘制的新图片
 */
+(UIImage *)boxblurImage:(UIImage *)image withBlurNumber:(CGFloat)blur;

@end
