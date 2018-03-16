//
//  LVOptionImageViewModel.h
//  onLineLive
//
//  Created by uwant on 16/11/21.
//  Copyright © 2016年 mobiletrain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LVOptionImageCollectionView.h"

@protocol LVOptionImageDelegate <NSObject>

@optional
- (void) updataCellFrameWithRowHeigth:(CGFloat)rowHeigth images:(NSArray *)images;

@end

@interface LVOptionImageViewModel : NSObject

/**当前所在的控制器*/
@property (nonatomic, weak) UIViewController *viewController;

/**选取图片成功后代理*/
@property (nonatomic, weak) id<LVOptionImageDelegate>pictureDelegate;

@property (nonatomic, assign) CGFloat rowHeight;

+ (instancetype) modelOnView:(UIView *)onView frame:(CGRect)frame;

- (void) updataCollectionViewHeightWithFrame:(CGRect)frame;

@property (nonatomic, strong) NSArray *images;



@end
