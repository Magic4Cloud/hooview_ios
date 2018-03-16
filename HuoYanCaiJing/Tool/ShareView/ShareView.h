//
//  ShareView.h
//  Education
//
//  Created by JN on 16/7/11.
//  Copyright © 2016年 CD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShareViewDelegate <NSObject>

- (void)shareButtonWithUMShareType:(NSInteger) platformType;

@end

@interface ShareView : UIView

@property (nonatomic, weak)id<ShareViewDelegate> delegate;

@property (nonatomic, strong)UILabel  *label;
@property (nonatomic, strong)UIButton  *closeButton;


@end
