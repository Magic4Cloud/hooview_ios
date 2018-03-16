//
//  DJEditPhotoViewController.h
//  DangJian
//
//  Created by uwant on 16/11/5.
//  Copyright © 2016年 luojing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LVDeleteImageUpdataCellDelegate <NSObject>

@optional
- (void)deleteImageupdataCellWithIndex:(NSInteger)index;

@end
@interface DJEditPhotoViewController : XZFBaseViewController
/**图片数组*/
@property (nonatomic, strong) NSMutableArray *images;
/**当前选中的图片下标*/
@property (nonatomic, assign) NSInteger currentIndex;
/**是否隐藏删除按钮*/
@property (nonatomic, assign) BOOL hiddenDelete;

@property (nonatomic, weak) id<LVDeleteImageUpdataCellDelegate>deleteDelegate;

@end
