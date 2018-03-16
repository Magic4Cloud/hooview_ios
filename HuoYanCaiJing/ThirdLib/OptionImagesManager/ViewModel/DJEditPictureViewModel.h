//
//  DJEditPictureViewModel.h
//  DangJian
//
//  Created by uwant on 16/11/5.
//  Copyright © 2016年 luojing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DJEditPictureCell.h"

@protocol DJEditPictrueDelegate <NSObject>

@optional
- (void)contentPictrueForIndex:(NSInteger)index;

@end

@interface DJEditPictureViewModel : NSObject<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, weak) id<DJEditPictrueDelegate>editDelegte;

@property (nonatomic, strong) NSMutableArray *dataSource;

+ (instancetype)model;

@end
