//
//  LVOptionImageCollectionView.h
//  onLineLive
//
//  Created by uwant on 16/11/21.
//  Copyright © 2016年 mobiletrain. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CELL_WIDTH ([UIScreen mainScreen].bounds.size.width - 20 - 30) / 4.0

@interface LVOptionImageCollectionView : UICollectionView

+ (instancetype) collectionViewWithFrame:(CGRect)frame delegate:(id<UICollectionViewDataSource,UICollectionViewDelegate>)delegate;

@end
