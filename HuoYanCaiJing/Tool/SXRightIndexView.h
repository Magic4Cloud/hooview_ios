//
//  SXRightIndexView.h
//  Education
//
//  Created by 赵慎修 on 16/12/20.
//  Copyright © 2016年 CD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SXRightIndexViewDelegate <NSObject>

- (void) rightOnclickedWithIndex:(NSString *) indexStr;

@end
@interface SXRightIndexView : UIView

@property (nonatomic, weak) id<SXRightIndexViewDelegate> delegate;
@property (nonatomic, strong) NSArray *indexArray;
@end
