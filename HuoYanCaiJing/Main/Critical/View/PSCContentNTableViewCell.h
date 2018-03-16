//
//  PSCContentNTableViewCell.h
//  XueZhiFei
//
//  Created by apple on 2017/11/8.
//  Copyright © 2017年 ZPF Mac Pro. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PSchoolModel.h"

@protocol PSCContentNTableViewCellDelegate <NSObject>

@optional

- (void)giveLikeButtonPressedWithCell:(UIButton *)sender;

@end

@interface PSCContentNTableViewCell : UITableViewCell

@property (assign,nonatomic) id<PSCContentNTableViewCellDelegate>delegate;

@property (strong,nonatomic) PSchoolModel *model;//校园班级shujuModel
@property (assign,nonatomic) NSInteger row;


@end
