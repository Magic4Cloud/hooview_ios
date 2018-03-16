//
//  HYCJHomeCollectionViewCell.h
//  HuoYanCaiJing
//
//  Created by ZPF Mac Pro on 2018/1/11.
//  Copyright © 2018年 shilei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYCJHomeCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *titleLab;
@property (strong, nonatomic) UILabel *numberLab;
@property (assign, nonatomic) NSInteger indexCell;
@property (strong, nonatomic) UIImageView *pointImageView;
@property (strong, nonatomic) UILabel *titleLabTwo;
//@property (strong, nonatomic) UIButton *titleButton;
@property (strong, nonatomic) UILabel *titleType;

@end
