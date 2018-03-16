//
//  LVOptionImageModel.m
//  onLineLive
//
//  Created by uwant on 16/11/21.
//  Copyright © 2016年 mobiletrain. All rights reserved.
//

#import "LVOptionImageModel.h"

@implementation LVOptionImageModel

+ (instancetype) modelWithImage:(id)image index:(NSInteger)index{
    LVOptionImageModel *model = [[LVOptionImageModel alloc] init];
    model.image = image;
    model.currentIndex = index;
    return model;
}

@end
