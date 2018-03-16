//
//  SXRightIndexView.m
//  Education
//
//  Created by 赵慎修 on 16/12/20.
//  Copyright © 2016年 CD. All rights reserved.
//

#import "SXRightIndexView.h"

@implementation SXRightIndexView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self createUI];
    }
    
    return self;
}

- (void) createUI {

    self.backgroundColor = [UIColor clearColor];
    self.indexArray = @[ @"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z", @"#"];
    CGFloat buttonX = 0;
    CGFloat buttonW = self.frame.size.width;
    CGFloat buttonH = self.frame.size.height / 27.0f;

    for (int i = 0; i < self.indexArray.count; i++) {
    
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(buttonX, buttonH * i, buttonW, buttonH)];
        button.backgroundColor = [UIColor clearColor];
        button.tag = 10 + i;
        [button setTitle:self.indexArray[i] forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromHex(0x999999) forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:11];
        [button addTarget:self action:@selector(rightIndexOnclicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
}

- (void) rightIndexOnclicked:(UIButton *) btn {

    [self.delegate rightOnclickedWithIndex:self.indexArray[btn.tag - 10]];
}

@end
