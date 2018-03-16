//
//  DJEditPictureViewModel.m
//  DangJian
//
//  Created by uwant on 16/11/5.
//  Copyright © 2016年 luojing. All rights reserved.
//

#import "DJEditPictureViewModel.h"

@implementation DJEditPictureViewModel

+ (instancetype)model {
    DJEditPictureViewModel *model = [[DJEditPictureViewModel alloc] init];
    model.dataSource = [NSMutableArray array];
    return model;
}

#pragma mark collection view data source
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DJEditPictureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DJEditPictureCell" forIndexPath:indexPath];
    NSLog(@"%lu",indexPath.row);
    cell.contentImg = self.dataSource[indexPath.row];
    return cell;
}

#pragma mark collection view delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x / [UIScreen mainScreen].bounds.size.width;
    NSLog(@"%lu",index);
    if (self.editDelegte && [self.editDelegte respondsToSelector:@selector(contentPictrueForIndex:)]) {
        [self.editDelegte contentPictrueForIndex:index];
    }
}



@end
