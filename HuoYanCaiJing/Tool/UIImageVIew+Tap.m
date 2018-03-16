//
//  UIImageVIew+Tap.m
//  vWork
//
//  Created by vWork on 16/5/26.
//  Copyright © 2016年 vWork. All rights reserved.
//

#import "UIImageVIew+Tap.h"

@implementation UIImageView(Tap)
-(void)addTapGestureRecognizerWith:(id)target action:(SEL)action{
    self.userInteractionEnabled=YES;
    UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:target action:action];
    [self addGestureRecognizer:tap];
}

@end
