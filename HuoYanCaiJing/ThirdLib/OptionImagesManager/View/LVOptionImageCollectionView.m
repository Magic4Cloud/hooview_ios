//
//  LVOptionImageCollectionView.m
//  onLineLive
//
//  Created by uwant on 16/11/21.
//  Copyright © 2016年 mobiletrain. All rights reserved.
//

#import "LVOptionImageCollectionView.h"
#import "LVOptionImageCell.h"


@implementation LVOptionImageCollectionView

+ (instancetype)collectionViewWithFrame:(CGRect)frame delegate:(id<UICollectionViewDataSource,UICollectionViewDelegate>)delegate {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(CELL_WIDTH, CELL_WIDTH);
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    flowLayout.minimumLineSpacing = 10.0;
    flowLayout.minimumInteritemSpacing = 10.0;
    LVOptionImageCollectionView *collectionView = [[LVOptionImageCollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor whiteColor];
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([LVOptionImageCell class]) bundle:nil] forCellWithReuseIdentifier:@"LVOptionImageCell"];
    collectionView.delegate = delegate;
    collectionView.dataSource = delegate;
    return collectionView;
}

@end
