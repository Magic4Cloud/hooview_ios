//
//  ShareItemCollectionViewCell.m
//  Education
//
//  Created by 赵慎修 on 17/3/9.
//  Copyright © 2017年 CD. All rights reserved.
//

#import "ShareItemCollectionViewCell.h"
#import "ShareItemModel.h"

@interface ShareItemCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;

@property (weak, nonatomic) IBOutlet UILabel *itemNameLabel;

@end
@implementation ShareItemCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setShareItemModel:(ShareItemModel *)shareItemModel {

    _shareItemModel = shareItemModel;
    _itemImageView.image = shareItemModel.itemImage;
    _itemNameLabel.text = shareItemModel.itemName;
}

@end
