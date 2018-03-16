//
//  HYCJHomeCollectionViewCell.m
//  HuoYanCaiJing
//
//  Created by ZPF Mac Pro on 2018/1/11.
//  Copyright © 2018年 shilei. All rights reserved.
//

#import "HYCJHomeCollectionViewCell.h"

@implementation HYCJHomeCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = UIColorFromHex(0xffffff);
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5*KHEIGHT_Scale,(WIDTH - 2)/2 - 20, 100*KHEIGHT_Scale)];
        self.imageView.backgroundColor = [UIColor redColor];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.image = [UIImage imageNamed:@"photoAlbum1"];
        self.imageView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.imageView];
        
        self.titleLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 110*KHEIGHT_Scale, (WIDTH - 2)/2 - 20, 20*KWidth_Scale)];
        self.titleLab.font = [UIFont pingfangFontWithSize:15 * KWidth_Scale];
        self.titleLab.textColor = RGB(71, 71, 71, 1);
        self.titleLab.textAlignment = NSTextAlignmentLeft;
        self.titleLab.text = @"#汇金财富在线直播";
        [self.contentView addSubview:self.titleLab];
        
        self.titleLabTwo = [[UILabel alloc] initWithFrame:CGRectMake(10, 130*KHEIGHT_Scale, (WIDTH - 2)/2 - 20, 20*KWidth_Scale)];
        self.titleLabTwo.font = [UIFont pingfangFontWithSize:12 * KWidth_Scale];
        self.titleLabTwo.textColor = RGB(166, 166, 166, 1);
        self.titleLabTwo.textAlignment = NSTextAlignmentLeft;
        self.titleLabTwo.text = @"金视界直播室";
        [self.contentView addSubview:self.titleLabTwo];
        
        self.pointImageView = [[UIImageView alloc] initWithFrame:CGRectMake(18.5, 88*KHEIGHT_Scale,9*KWidth_Scale, 9*KHEIGHT_Scale)];
        self.pointImageView.backgroundColor = RGB(67, 255, 0, 1);
        self.pointImageView.layer.cornerRadius = 4.5*KWidth_Scale;
        self.pointImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.pointImageView];
        
        self.numberLab = [[UILabel alloc] initWithFrame:CGRectMake(32*KWidth_Scale, 85*KWidth_Scale, (WIDTH - 2)/2 - 52*KWidth_Scale, 15*KWidth_Scale)];
        self.numberLab.font = [UIFont pingfangFontWithSize:10*KWidth_Scale];
        self.numberLab.textAlignment = NSTextAlignmentLeft;
        self.numberLab.backgroundColor = [UIColor clearColor];
        self.numberLab.textColor = RGB(255, 255, 255, 255);
        self.numberLab.text = @"543 人正在看";
        [self.contentView addSubview:self.numberLab];
        
        
//        self.titleButton = [[UIButton alloc] initWithFrame:CGRectMake((WIDTH - 2)/2 - 55*KWidth_Scale, 13*KWidth_Scale, 40*KWidth_Scale, 23*KWidth_Scale)];
//        self.titleButton.backgroundColor = RGB(234, 72, 96, 1);
//        self.titleButton.layer.cornerRadius = 1;
//        self.titleButton.titleLabel.font = [UIFont systemFontOfSize:12*KWidth_Scale];
//        [self.titleButton setTitle:@"股票" forState:UIControlStateNormal];
//        [self.titleButton setTitleColor:RGB(255, 255, 255, 1) forState:UIControlStateNormal];
//        [self.contentView addSubview:self.titleButton];
        
        self.titleType = [[UILabel alloc] init];
        self.titleType.font = [UIFont systemFontOfSize:12];
        self.titleType.textColor = RGB(255, 255, 255, 1);
        self.titleType.backgroundColor = RGB(234, 72, 96, 1);
        self.titleType.textAlignment = NSTextAlignmentCenter;
        self.titleType.layer.cornerRadius = 1;
        [self.contentView addSubview:self.titleType];
        [self.titleType mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-15);
            make.height.mas_equalTo(23);
            make.top.mas_equalTo(self.contentView.mas_top).offset(13);
        }];
        
        
        
    }
    return self;
}

- (void)setIndexCell:(NSInteger)indexCell{
    _indexCell = indexCell;
    if (indexCell %(2) == 0) {
        self.imageView.frame = CGRectMake(5, 5*KHEIGHT_Scale,(WIDTH - 2)/2 - 15, 100*KHEIGHT_Scale);
//        self.titleButton.frame = CGRectMake((WIDTH - 2)/2 - 60*KWidth_Scale, 13*KWidth_Scale, 40*KWidth_Scale, 23*KWidth_Scale);
    }else{
        self.imageView.frame = CGRectMake(10, 5*KHEIGHT_Scale,(WIDTH - 2)/2 - 15, 100*KHEIGHT_Scale);
//        self.titleButton.frame = CGRectMake((WIDTH - 2)/2 - 55*KWidth_Scale, 13*KWidth_Scale, 40*KWidth_Scale, 23*KWidth_Scale);
    }
    
}

@end
