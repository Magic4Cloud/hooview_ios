//
//  HYCJMyBuyTableViewCell.h
//  HuoYanCaiJing
//
//  Created by ZPF Mac Pro on 2018/1/13.
//  Copyright © 2018年 shilei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYCJMyBuyTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *lookButton;
@property (weak, nonatomic) IBOutlet UIImageView *cellImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *typeButton;
@property (weak, nonatomic) IBOutlet UILabel *liveLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;

@end
