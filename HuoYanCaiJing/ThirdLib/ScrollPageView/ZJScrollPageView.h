//
//  ZJScrollPageView.h
//  ZJScrollPageView
//
//  Created by jasnig on 16/5/6.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJScrollSegmentView.h"
#import "ZJContentView.h"
@interface ZJScrollPageView : UIView


typedef void(^ExtraBtnOnClick)(UIButton *extraBtn);

@property (weak, nonatomic) ZJScrollSegmentView *segmentView;
@property (copy, nonatomic) ExtraBtnOnClick extraBtnOnClick;



- (instancetype)initWithFrame:(CGRect)frame segmentStyle:(ZJSegmentStyle *)segmentStyle childVcs:(NSArray *)childVcs parentViewController:(XZFBaseViewController *)parentViewController;

/** 给外界设置选中的下标的方法 */
- (void)setSelectedIndex:(NSInteger)selectedIndex animated:(BOOL)animated;
/**  给外界重新设置视图内容的标题的方法 */
- (void)reloadChildVcsWithNewChildVcs:(NSArray *)newChildVcs;

/** title点击*/
@property (nonatomic, copy) void(^titleBtnOnClicked)(NSInteger);

@property (nonatomic, weak) id<ZJScrollSegmentDelegate>scrollSegmentDelegate;


@end
