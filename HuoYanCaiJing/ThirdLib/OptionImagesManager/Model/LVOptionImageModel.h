//
//  LVOptionImageModel.h
//  onLineLive
//
//  Created by uwant on 16/11/21.
//  Copyright © 2016年 mobiletrain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LVOptionImageModel : NSObject
//当前图片
@property (nonatomic, strong) id image;
//当前的图片的下标
@property (nonatomic, assign) NSInteger currentIndex;

/*!
 @brief 初始化model
 @param image 图片内容 index 图片下标
 @return model对象
 */
+ (instancetype) modelWithImage:(id)image index:(NSInteger)index;

@end
