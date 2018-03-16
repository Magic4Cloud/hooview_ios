//
//  HYCJVIPLiveTableViewCell.h
//  HuoYanCaiJing
//
//  Created by ZPF Mac Pro on 2018/1/15.
//  Copyright © 2018年 shilei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYCJVIPLiveTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *lookButton;
@property (weak, nonatomic) IBOutlet UILabel *numberLab;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *locationLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UIButton *typeButton;
@property (weak, nonatomic) IBOutlet UIImageView *bgImg;
@property (weak, nonatomic) IBOutlet UILabel *moneyL;

@end
