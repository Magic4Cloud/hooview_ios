//
//  HYCJMyMessageTableViewCell.h
//  HuoYanCaiJing
//
//  Created by ZPF Mac Pro on 2018/1/13.
//  Copyright © 2018年 shilei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYCJMyMessageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIImageView *bgImg;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UIButton *typeButton;
@property (weak, nonatomic) IBOutlet UIView *liveView;
@property (weak, nonatomic) IBOutlet UILabel *numberLab;

@end
