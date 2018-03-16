//
//  LVOptionImageViewModel.m
//  onLineLive
//
//  Created by uwant on 16/11/21.
//  Copyright © 2016年 mobiletrain. All rights reserved.
//

#import "LVOptionImageViewModel.h"
#import "LVOptionImageCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "QBImagePickerController.h"
#import "DJEditPhotoViewController.h"

#define IMAGE_LIMIT 6  //限制图片张数 6 - 1 = 5需要减一

@interface LVOptionImageViewModel()<QBImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,LVDeleteImageUpdataCellDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
//小图
@property (nonatomic, strong) NSMutableArray *smallImages;
//大图
@property (nonatomic, strong) NSMutableArray *bagImages;

@property (nonatomic, strong) LVOptionImageCollectionView *collectionView;

@end

@implementation LVOptionImageViewModel

#pragma mark 懒加载
- (NSMutableArray *)smallImages {
    if (!_smallImages) {
        UIImage *image = [UIImage imageNamed:@"zhaoxiangji"];
        _smallImages = [NSMutableArray arrayWithObjects:image, nil];
    }
    return _smallImages;
}

- (NSMutableArray *)bagImages {
    if (!_bagImages) {
        _bagImages = [NSMutableArray array];
    }
    return _bagImages;
}

- (void)setImages:(NSArray *)images {
    for (NSString *imgUrl in images) {
        [self.bagImages addObject:imgUrl];
        [self.smallImages insertObject:imgUrl atIndex:self.smallImages.count - 1];
    }
}

#pragma mark 类方法创建对象
+ (instancetype)modelOnView:(UIView *)onView frame:(CGRect)frame{
    LVOptionImageViewModel *model = [[LVOptionImageViewModel alloc] init];
    model.collectionView = [LVOptionImageCollectionView collectionViewWithFrame:frame delegate:model];
    [onView addSubview:model.collectionView];
    return model;
}

#pragma mark colloction view data source
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.smallImages.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LVOptionImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LVOptionImageCell" forIndexPath:indexPath];
    if (self.smallImages.count) {
        cell.image = self.smallImages[indexPath.row];
    }
    if (indexPath.row == self.smallImages.count - 1) {
        cell.selectCell = YES;
    }else {
        cell.selectCell = NO;
    }
    return cell;
}

#pragma mark collection view delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //添加图片
    if (indexPath.row == self.smallImages.count - 1) {
        if (self.smallImages.count >= IMAGE_LIMIT) {
            //超过上限不让添加
            UIAlertController *alertVC2 = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"最多可设置%d张图片",IMAGE_LIMIT - 1] preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *cancal = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alertVC2 addAction:cancal];
            if (self.viewController) {
                [self.viewController presentViewController:alertVC2 animated:YES completion:nil];
            }
        }else {
            [self showAlertController];
        }
        //浏览图片
    }else{
        DJEditPhotoViewController *editPhotoVC = [[DJEditPhotoViewController alloc] init];
        editPhotoVC.images = self.bagImages;
        editPhotoVC.deleteDelegate = self;
        editPhotoVC.currentIndex = indexPath.row;
        if (self.viewController) {
            [self.viewController.navigationController pushViewController:editPhotoVC animated:YES];
        }
    }

}

#pragma mark 拍照&选择图片
- (void) showAlertController {
    __weak typeof(self) weakSelf = self;
    UIAlertController *alertVC2 = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancal = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *canca2 = [UIAlertAction actionWithTitle:@"从手机相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf chooiseThePicture];
    }];
    UIAlertAction *canca3 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf takeThePicture];
    }];
    [alertVC2 addAction:canca2];
    [alertVC2 addAction:cancal];
    [alertVC2 addAction:canca3];
    if (self.viewController) {
        [self.viewController presentViewController:alertVC2 animated:YES completion:nil];
    }
}

#pragma mark 拍照
- (void) takeThePicture {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.allowsEditing = YES;
        picker.delegate = self;
        if (self.viewController) {
            [self.viewController presentViewController:picker animated:YES completion:nil];
        }
    }else {
        
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)imagePickerController {
    if ([imagePickerController isKindOfClass:[QBImagePickerController class]]) {
        [imagePickerController dismissViewControllerAnimated:YES completion:nil];
    }else {
        [imagePickerController dismissViewControllerAnimated:YES completion:nil];
    }
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage * img = [info objectForKey:UIImagePickerControllerEditedImage];
    NSData *data = UIImagePNGRepresentation(img);
    [self.smallImages insertObject:img atIndex:self.smallImages.count - 1];
    if (! self.bagImages) {
        self.bagImages = [NSMutableArray array];
    }
    [self.bagImages addObject:data];
    [self updataPictureCell];
}

//刷新高度
- (void) updataPictureCell {
    [self.collectionView reloadData];
    if (self.pictureDelegate && [self.pictureDelegate respondsToSelector:@selector(updataCellFrameWithRowHeigth:images:)]) {
        CGFloat rowHeight = ceilf(self.smallImages.count / 4.0) * CELL_WIDTH + (ceilf(self.smallImages.count / 4.0) - 1) * 10;
        self.rowHeight = rowHeight;
        [self.pictureDelegate updataCellFrameWithRowHeigth:rowHeight images:self.bagImages];
    }
}

#pragma mark 选择图片
- (void) chooiseThePicture {
    QBImagePickerController *imagePickerController =[QBImagePickerController new];
    
    imagePickerController.title = @"相册";
    imagePickerController.delegate = self;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.maximumNumberOfSelection = IMAGE_LIMIT - self.smallImages.count;//设置选择图像数量上限
    imagePickerController.showsCancelButton = YES;
    imagePickerController.filterType = QBImagePickerControllerFilterTypePhotos;
    if (self.viewController) {
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
        [self.viewController presentViewController:nav animated:YES completion:nil];
    }
}

- (void)imagePickerController:(QBImagePickerController *)imagePickerController didSelectAssets:(NSArray *)assets{
    if (! self.bagImages) {
        self.bagImages = [NSMutableArray array];
    }
    
    for (ALAsset *asset in assets) {
        ALAssetRepresentation * defaultRepresentation = [asset defaultRepresentation];
        UIImage * img = [UIImage imageWithCGImage:defaultRepresentation.fullScreenImage];
        NSData * data = UIImagePNGRepresentation(img);
        [self.bagImages addObject:data];
    }
    for (ALAsset *asset in assets) {
        [self.smallImages insertObject:[UIImage imageWithCGImage:asset.thumbnail] atIndex:self.smallImages.count - 1];
    }
    [imagePickerController dismissViewControllerAnimated:YES completion:nil];
    [self updataPictureCell];
}

#pragma mark LVDeleteImageUpdataCellDelegate
- (void)deleteImageupdataCellWithIndex:(NSInteger)index {
    [self.smallImages removeObjectAtIndex:index];
    [self updataPictureCell];
}


- (void) updataCollectionViewHeightWithFrame:(CGRect)frame {
    self.collectionView.frame = frame;
    [self.collectionView reloadData];
}

@end
