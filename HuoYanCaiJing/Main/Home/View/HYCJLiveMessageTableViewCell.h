//
//  HYCJLiveMessageTableViewCell.h
//  HuoYanCaiJing
//
//  Created by ZPF Mac Pro on 2018/1/28.
//  Copyright © 2018年 shilei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYCJLiveMessageTableViewCell : EaseMessageCell
{
    UILabel *_nameLabel;
}

/*
 *  头像尺寸大小
 */
@property (nonatomic) CGFloat avatarSize UI_APPEARANCE_SELECTOR; //default 30;

/*
 *  头像圆角
 */
@property (nonatomic) CGFloat avatarCornerRadius UI_APPEARANCE_SELECTOR; //default 0;

/*
 *  昵称显示字体
 */
@property (nonatomic) UIFont *messageNameFont UI_APPEARANCE_SELECTOR; //default [UIFont systemFontOfSize:10];

/*
 *  昵称显示颜色
 */
@property (nonatomic) UIColor *messageNameColor UI_APPEARANCE_SELECTOR; //default [UIColor grayColor];

/*
 *  昵称显示高度
 */
@property (nonatomic) CGFloat messageNameHeight UI_APPEARANCE_SELECTOR; //default 15;

/*
 *  昵称是否显示
 */
@property (nonatomic) BOOL messageNameIsHidden UI_APPEARANCE_SELECTOR; //default NO;
@end
