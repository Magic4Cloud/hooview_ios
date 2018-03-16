//
//  PSCContentNTableViewCell.m
//  XueZhiFei
//
//  Created by apple on 2017/11/8.
//  Copyright © 2017年 ZPF Mac Pro. All rights reserved.
//

#import "PSCContentNTableViewCell.h"
#import "CHYPublic.h"



@interface PSCContentNTableViewCell ()

@property (strong,nonatomic) UIImageView *headerViewCell;
@property (strong,nonatomic) UILabel *nickName;
@property (strong,nonatomic) UIButton *readedNumber;
@property (strong,nonatomic) UILabel *praiseNumLab;

@property (strong,nonatomic) UILabel *creatTime;
@property (strong,nonatomic) UILabel *content;
@property (strong,nonatomic) UIView *line;

@end

@implementation PSCContentNTableViewCell

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
        
        self.userInteractionEnabled = YES;
        
        
        self.headerViewCell = [self headerViewCell];
        self.nickName = [self rwLabelWith:@"nickNmae" font:[UIFont pingfangRegularFontWithSize:16] textColor:[UIColor grayColor] lineNumber:1];
        
        self.praiseNumLab = [self rwLabelWith:@"praiseNumLab" font:[UIFont pingfangRegularFontWithSize:16] textColor:RGB(155, 155, 155, 1.0) lineNumber:1];
        self.readedNumber = [self readedNumber];
        
        self.creatTime = [self rwLabelWith:@"2017-09-09 12:20" font:[UIFont pingfangRegularFontWithSize:11] textColor:RGB(147, 147, 147, 1.0) lineNumber:1];
        self.content =  [self rwLabelWith:@"内容展示，阿斯顿开发就；阿莱克斯的肌肤就阿里斯顿会计法阿里；速度快放假啊啥的风景和看手机打发贺卡精神焕发" font:[UIFont pingfangRegularFontWithSize:16] textColor:RGB(74,74,74,1.0) lineNumber:0];
        
        
        [self.contentView addSubview:_headerViewCell];
        [self.contentView addSubview:_nickName];
        [self.contentView addSubview:_readedNumber];
        [self.contentView addSubview:_praiseNumLab];
        [self.contentView addSubview:_creatTime];
        [self.contentView addSubview:_content];
        
        
        [_headerViewCell mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(10);
            make.left.offset(10);
            make.width.offset(38);
            make.height.offset(38);
        }];
        
        
        [_nickName mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(10);
            make.left.equalTo(_headerViewCell.mas_right).offset(10);
            make.height.offset(scaleHeight(70)/2);
        }];
        
        
        [_readedNumber mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(10);
            make.right.equalTo(self.contentView).offset(-10);
            make.height.offset(40);
        }];
        [_praiseNumLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_readedNumber.mas_centerY).offset(2);
            make.right.equalTo(_readedNumber.mas_left).offset(0);
            make.height.offset(20);
        }];
        [_creatTime mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_nickName.mas_bottom).offset(5);
            make.left.equalTo(_headerViewCell.mas_right).offset(10);
            make.height.offset(scaleHeight(70)/2);
        }];
        
        
        [_content mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_creatTime.mas_bottom).offset(5);
            make.left.equalTo(_headerViewCell.mas_right).offset(10);
            make.right.equalTo(self.contentView).offset(-10);
        }];
        
        
        _line = [[UIView alloc] init];
        _line.backgroundColor = RGB(230, 230, 230, 1.0);
        
        [self.contentView addSubview:_line];
        
        [_line mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_content.mas_bottom).offset(scaleHeight(28));
            make.left.equalTo(_headerViewCell.mas_right).offset(10);
            make.right.equalTo(self.contentView).offset(0);
            make.height.offset(0.5);
            make.bottom.equalTo(self.contentView).offset(0);
        }];
        
        
    }
    return self;
}


- (UILabel *)rwLabelWith:(NSString *)title font:(UIFont *)font textColor:(UIColor *)color lineNumber:(NSInteger)index{
    UILabel *label = [[UILabel alloc] init];
    label.text = title;
    label.textColor = color;
    label.font = font;
    label.numberOfLines = index;
    return label;
}

- (UIImageView *)headerViewCell{
    if (_headerViewCell) {
//        [_headerViewCell removeFromSuperview];
        return _headerViewCell;
    }
    
    UIImageView *image = [[UIImageView alloc] init];
    image.clipsToBounds = YES;
    image.contentMode = UIViewContentModeScaleAspectFill;
    image.backgroundColor = [UIColor grayColor];
    image.layer.cornerRadius = 19;
    return image;
}

+ (NSMutableAttributedString *)returnAttributedStringWith:(UIFont *)font textColor:(UIColor *)color imageName:(NSString *)imageName insertIndex:(NSInteger)index content:(NSString *)title tag:(NSInteger)tag{
    NSString *tempGroup = [NSString stringWithFormat:@"%@",title];
    NSMutableAttributedString *ms = [[NSMutableAttributedString alloc] initWithString:tempGroup];
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    attch.image = [UIImage imageNamed:imageName];
    if (attch.image) {
        if (tag == 100) {
            attch.bounds = CGRectMake(0,(font.lineHeight - 4.5)/2/2,8.5,4.5);
        }
        else{
            attch.bounds = CGRectMake(0,(font.lineHeight - 12)/2/2-2.5,21,21);
        }
    }
    else{
        attch.bounds = CGRectMake(0,0,0,0);
    }
    NSAttributedString *imageString = [NSAttributedString attributedStringWithAttachment:attch];
    [ms replaceCharactersInRange:NSMakeRange(0, 1) withAttributedString:imageString];
    
    NSMutableParagraphStyle   *paragraphStyle   = [[NSMutableParagraphStyle alloc] init];
    [ms addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, [tempGroup length])];
    [ms addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, [tempGroup length])];
    [ms addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [tempGroup length])];
    return ms;
}


- (void)layoutSubviews{
    
}

- (void)setRow:(NSInteger)row{
    _row = row;
    _readedNumber.tag = _row;
}

- (void)setModel:(PSchoolModel *)model{
    _model = model;
    if (_model) {
        NSInteger praise = _model.praise;
        if (praise == 0) {
          [_readedNumber setAttributedTitle:[PSCContentNTableViewCell returnAttributedStringWith:[UIFont pingfangRegularFontWithSize:13] textColor:[UIColor grayColor] imageName:@"icon_news_praise_s" insertIndex:0 content:@"0" tag:101] forState:UIControlStateNormal];
            self.praiseNumLab.textColor = RGB(155, 155, 155, 1);
        }else{
            [_readedNumber setAttributedTitle:[PSCContentNTableViewCell returnAttributedStringWith:[UIFont pingfangRegularFontWithSize:13] textColor:[UIColor grayColor] imageName:@"icon_news_praise_s_sure" insertIndex:0 content:@"0" tag:101] forState:UIControlStateNormal];
            self.praiseNumLab.textColor = RGB(234, 72, 96, 1);
        }
        self.praiseNumLab.text = [NSString stringWithFormat:@"%@",_model.praiseNum];
        self.nickName.text = [NSString stringWithFormat:@"%@",_model.nickname];
        self.content.text = [NSString stringWithFormat:@"%@",_model.comment];
        self.creatTime.text = [NSString stringWithFormat:@"%@",_model.createTime];
        [self.headerViewCell sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_model.headUrl]] placeholderImage:PlaceholderImageView];

    }
}
- (UIButton *)readedNumber{
    if (_readedNumber) {
        return _readedNumber;
    }
    UIButton *button = [[UIButton alloc] init];
    [button setAttributedTitle:[PSCContentNTableViewCell returnAttributedStringWith:[UIFont pingfangRegularFontWithSize:13] textColor:[UIColor grayColor] imageName:@"icon_news_praise_s" insertIndex:0 content:@"0" tag:101] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(readNumberButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    return button;
    
}
- (void)readNumberButtonPressed:(UIButton *)sender{
    [self.delegate giveLikeButtonPressedWithCell:sender];
}


@end
