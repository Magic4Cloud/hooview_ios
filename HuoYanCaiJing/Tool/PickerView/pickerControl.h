//
//  pickerControl.h
//  Education
//
//  Created by shilei on 16/7/19.
//  Copyright © 2016年 CD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface pickerControl : UIView

@property(nonatomic,strong)UILabel *titleLabel;

- (instancetype)initWithType:(NSInteger)type columuns:(NSInteger)col WithDataSource:(NSArray *)sources response:(void(^)(NSString*))block;
- (void)show;
@end
