//
//  ZJContentView.h
//  ZJScrollPageView
//
//  Created by jasnig on 16/5/6.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZJScrollSegmentView;

@protocol ZJScrollSegmentDelegate <NSObject>

@optional
- (void) scrollcurrentIndex:(NSInteger )index;

@end

@interface ZJContentView : UIView

@property (nonatomic, weak) id<ZJScrollSegmentDelegate>indexDelegate;

- (instancetype)initWithFrame:(CGRect)frame childVcs:(NSArray *)childVcs segmentView:(ZJScrollSegmentView *)segmentView parentViewController:(XZFBaseViewController *)parentViewController;

/** 给外界可以设置ContentOffSet的方法 */
- (void)setContentOffSet:(CGPoint)offset animated:(BOOL)animated;
/** 给外界刷新视图的方法 */
- (void)reloadAllViewsWithNewChildVcs:(NSArray *)newChileVcs;
@end
