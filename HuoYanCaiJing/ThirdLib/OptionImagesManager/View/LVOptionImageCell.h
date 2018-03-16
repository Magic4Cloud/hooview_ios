//
//  LVOptionImageCell.h
//  onLineLive
//
//  Created by uwant on 16/11/21.
//  Copyright © 2016年 mobiletrain. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LVOptionImageModel;

@interface LVOptionImageCell : UICollectionViewCell

@property (nonatomic, strong) id image;

@property (nonatomic, assign,getter=isSelectCell) BOOL selectCell;

@end
