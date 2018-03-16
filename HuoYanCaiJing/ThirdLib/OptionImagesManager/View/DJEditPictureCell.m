//
//  DJEditPictureCell.m
//  DangJian
//
//  Created by uwant on 16/11/5.
//  Copyright © 2016年 luojing. All rights reserved.
//

#import "DJEditPictureCell.h"

@interface DJEditPictureCell()

@property (nonatomic,strong) UIImageView *contentImageView;

@end

@implementation DJEditPictureCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(1, 0, [UIScreen mainScreen].bounds.size.width - 2,  [UIScreen mainScreen].bounds.size.height - 64)];
        [self.contentImageView setContentMode:UIViewContentModeScaleAspectFit];
        [self.contentView addSubview:self.contentImageView];
    }
    return self;
}

- (void)setContentImg:(id )contentImg {
    if (contentImg) {
        if ([contentImg isKindOfClass:[NSString class]]) {
            [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:contentImg] placeholderImage:[UIImage imageNamed:@""]];
        }else {
            __weak typeof(self) weakSelf = self;
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                UIImage *tempImage = nil;
                if ([contentImg isKindOfClass:[UIImage class]]) {
                    tempImage = contentImg;
                }else {
                    tempImage = [UIImage imageWithData:contentImg];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.contentImageView.image = tempImage;
                });
            });
        }
        
       
    }
}

@end
