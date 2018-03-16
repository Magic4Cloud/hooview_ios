//
//  HYCJNoDataTableViewCell.m
//  HuoYanCaiJing
//
//  Created by ZPF Mac Pro on 2018/2/1.
//  Copyright © 2018年 shilei. All rights reserved.
//

#import "HYCJNoDataTableViewCell.h"
@interface HYCJNoDataTableViewCell ()

@property (strong,nonatomic) UIView *nodata;

@end
@implementation HYCJNoDataTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _nodata = [CHYPublic rwNodataWith:@"icon_status_failure" andTip:@"暂无数据" bottomMagin:0];
        
        [self.contentView addSubview:_nodata];
        [_nodata mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView).offset(0);
            make.top.equalTo(self.contentView.mas_top).offset(80);
            make.height.offset(scaleHeight(349));
        }];
        
        UILabel *titlelab = [[UILabel alloc] init];
//        titlelab.text = @"工作人员还在努力的准备内容";
        titlelab.font = [UIFont systemFontOfSize:14];
        titlelab.textColor = RGB(155, 155, 155, 1);
        titlelab.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:titlelab];
        [titlelab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView).offset(0);
            make.top.equalTo(self.nodata.mas_bottom).offset(5);
            make.height.offset(30);
        }];
        
        
        
        
        
    }
    return self;
}

@end
