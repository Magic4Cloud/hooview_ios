//
//  NodataTableViewCell.h
//  XueZhiFei
//
//  Created by apple on 2017/11/9.
//  Copyright © 2017年 ZPF Mac Pro. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NodataTableViewCellDelegate <NSObject>

@optional

- (void)addButtonPressedWithNodataCell;

@end

@interface NodataTableViewCell : UITableViewCell


- (void)uploadCellWith:(NSString *)image tip:(NSString *)tips showButton:(BOOL)state type:(NSInteger)type;

@property (assign,nonatomic) id<NodataTableViewCellDelegate>delegate;

@end
