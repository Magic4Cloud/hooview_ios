//
//  LVOptionImageCell.m
//  onLineLive
//
//  Created by uwant on 16/11/21.
//  Copyright © 2016年 mobiletrain. All rights reserved.
//

#import "LVOptionImageCell.h"
#import "LVOptionImageModel.h"

@interface LVOptionImageCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation LVOptionImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setImage:(id)image {
    if (image) {
        if ([image isKindOfClass:[NSString class]]) {
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@""]];
        }else {
            __weak typeof(self) weakSelf = self;
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                UIImage *tempImage = nil;
                if ([image isKindOfClass:[UIImage class]]) {
                    tempImage = image;
                }else {
                    tempImage = [UIImage imageWithData:image];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.imageView.image = tempImage;
                });
            });
        }
    }
}

- (void)setSelectCell:(BOOL)selectCell {
    if (selectCell) {
        self.imageView.frame = CGRectMake(self.frame.size.width / 2.0 - 38 / 2.0, self.frame.size.height / 2.0 - 31 / 2.0, 38, 31);
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"F4F4F4"];
    }else {
        self.imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
}



@end
