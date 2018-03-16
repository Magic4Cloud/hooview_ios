//
//  NodataTableViewCell.m
//  XueZhiFei
//
//  Created by apple on 2017/11/9.
//  Copyright © 2017年 ZPF Mac Pro. All rights reserved.
//

#import "NodataTableViewCell.h"

@interface NodataTableViewCell ()

@property (strong,nonatomic) UIView *nodata;
@property (strong,nonatomic) UIButton *addClass;

@end

@implementation NodataTableViewCell

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
        
        _nodata = [CHYPublic rwNodataWith:@"icon_status_failure" andTip:@"内容还在准备中" bottomMagin:0];
        
        [self.contentView addSubview:_nodata];
        [_nodata mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView).offset(0);
            make.top.equalTo(self.contentView.mas_top).offset(80);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-35);
            make.height.offset(scaleHeight(349));
        }];
        
        UILabel *titlelab = [[UILabel alloc] init];
        titlelab.text = @"工作人员还在努力的准备内容";
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

- (void)addButtonPressedWithNodata:(UIButton *)sender{
    [self addButtonPressedWithNodataCell];
}

- (void)addButtonPressedWithNodataCell{
    [_delegate addButtonPressedWithNodataCell];
}

- (void)uploadCellWith:(NSString *)image tip:(NSString *)tips showButton:(BOOL)state type:(NSInteger)type{
    if (image && image.length > 0) {
        UIImageView *temp = [_nodata viewWithTag:9999];
        temp.image = [UIImage imageNamed:image];
    }
    
    if (tips && tips.length > 0) {
        UILabel *temp1 = [_nodata viewWithTag:8888];
        temp1.text = tips;
    }
    
    _addClass.hidden = !state;
    
    if (state) {
        [_nodata mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView).offset(-60);
        }];
    }
    else{
        [_nodata mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView).offset(0);
        }];
    }
}
@end
