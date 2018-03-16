//
//  HYCJCriticalDetailViewController.h
//  HuoYanCaiJing
//
//  Created by ZPF Mac Pro on 2018/1/28.
//  Copyright © 2018年 shilei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYCJCriticalModel.h"

@interface HYCJCriticalDetailViewController : XZFBaseViewController
@property (nonatomic , strong ) NSString *financeInfoId;
@property (nonatomic , strong ) HYCJCriticalModel *model;

@end
