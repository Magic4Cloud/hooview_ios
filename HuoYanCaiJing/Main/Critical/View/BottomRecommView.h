//
//  BottomRecommView.h
//  XueZhiFei
//
//  Created by apple on 2017/11/9.
//  Copyright © 2017年 ZPF Mac Pro. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BottomRecommViewDelegate <NSObject>

@optional
- (void)senButtonPressedWith:(NSString *)content;

@end

@interface BottomRecommView : UIView

- (void)beginInput;
- (void)endInput;

@property (strong,nonatomic) NSString *normalPlaceHold;
@property (strong,nonatomic) NSAttributedString *attriedPlaceHold;
@property (strong,nonatomic) UITextField *textFiled;

@property (assign,nonatomic) id<BottomRecommViewDelegate>delegate;

@end
