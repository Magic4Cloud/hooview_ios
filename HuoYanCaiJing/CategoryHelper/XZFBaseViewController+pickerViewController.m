//
//  UIViewController+pickerViewController.m
//  onLineLive
//
//  Created by uwant on 16/11/17.
//  Copyright © 2016年 mobiletrain. All rights reserved.
//

#import "XZFBaseViewController+pickerViewController.h"
#import "QBImagePickerController.h"

@implementation XZFBaseViewController (pickerViewController)

- (void)showOptionImgTypeView {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    LiveMyAlertAction *actionCancel = [LiveMyAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    __weak typeof(self) weakSelf = self;
    LiveMyAlertAction *actionLibrary = [LiveMyAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf showImgaePickerViewController:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
   
    
    LiveMyAlertAction *actionCamera = [LiveMyAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf showImgaePickerViewController:UIImagePickerControllerSourceTypeCamera];
    }];
    
    [actionCamera setValue:UIColorFromHex(0x000000) forKey:@"_titleTextColor"];
    [actionLibrary setValue:UIColorFromHex(0x000000) forKey:@"_titleTextColor"];
    [actionCancel setValue:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]] forKey:@"_titleTextColor"];

    
    [alertVC addAction:actionCancel];
    [alertVC addAction:actionLibrary];
    [alertVC addAction:actionCamera];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)showManyOptionImgTypeView {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    LiveMyAlertAction *actionCancel = [LiveMyAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    LiveMyAlertAction *actionLibrary = [LiveMyAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (self.smallImages.count == self.imageSize) {
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"最多可选%ld张图片",self.imageSize]];
        } else {
            [self chooseThePicture];
        }
    }];
    
    
    LiveMyAlertAction *actionCamera = [LiveMyAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (self.smallImages.count == self.imageSize) {
            [SVProgressHUD setMinimumDismissTimeInterval:1];
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"最多可选%ld张图片",self.imageSize]];
        } else {
            [self showImgaePickerViewController:UIImagePickerControllerSourceTypeCamera];;
        }
    }];
    
    
    [alertVC addAction:actionCancel];
    [alertVC addAction:actionLibrary];
    [alertVC addAction:actionCamera];
    [self presentViewController:alertVC animated:YES completion:nil];
}


- (void)showImgaePickerViewController:(UIImagePickerControllerSourceType)sourceType {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        picker.sourceType = sourceType;
        picker.allowsEditing = YES;
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:nil];
        
    } else {
        if (sourceType == UIImagePickerControllerSourceTypeCamera) {
            [SVProgressHUD setMinimumDismissTimeInterval:1];
            [SVProgressHUD showErrorWithStatus:@"当前照相机不可用"];
        } else if (sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
            [SVProgressHUD setMinimumDismissTimeInterval:1];
            [SVProgressHUD showErrorWithStatus:@"当前照片不可用"];
        }
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
    UIImage * img = [info objectForKey:UIImagePickerControllerEditedImage];
    NSData *data = UIImagePNGRepresentation(img);
    if (!self.smallImages) {
        self.smallImages = [NSMutableArray array];
    }
    if (!self.dataImages) {
        self.dataImages = [NSMutableArray array];
    }
    [self.smallImages addObject:img];
    [self.dataImages addObject:data];
    
    if ([self respondsToSelector:@selector(finishChoosePhoto)]) {
        [self finishChoosePhoto];
    }
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    if ([self respondsToSelector:@selector(imagePickerControllerWithImage:)]) {
        [self imagePickerControllerWithImage:image];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}


- (void)chooseThePicture {
    
    if ([QBImagePickerController isAccessible]) {
        QBImagePickerController *imagePickerController =[[QBImagePickerController alloc] init];
        
        imagePickerController.title = @"相册";
        imagePickerController.delegate = self;
        imagePickerController.allowsMultipleSelection = YES;
        imagePickerController.maximumNumberOfSelection = self.imageSize - self.smallImages.count;//设置选择图像数量上限
        imagePickerController.showsCancelButton = YES;
        imagePickerController.filterType = QBImagePickerControllerFilterTypePhotos;
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
        [self presentViewController:nav animated:YES completion:nil];
    } else {
        [SVProgressHUD setMinimumDismissTimeInterval:1];
        [SVProgressHUD showErrorWithStatus:@"当前没有相册权限"];
    }
    
    
    
}

- (void)imagePickerController:(QBImagePickerController *)imagePickerController didSelectAssets:(NSArray *)assets{
    if (! self.dataImages) {
        self.dataImages = [NSMutableArray array];
    }
    if (!self.smallImages) {
        self.smallImages = [NSMutableArray array];
    }
    
    for (ALAsset *asset in assets) {
        ALAssetRepresentation * defaultRepresentation = [asset defaultRepresentation];
        UIImage * img = [UIImage imageWithCGImage:defaultRepresentation.fullScreenImage];
        NSData * data = UIImagePNGRepresentation(img);
        [self.dataImages addObject:data];
    }
    for (ALAsset *asset in assets) {
        [self.smallImages addObject:[UIImage imageWithCGImage:asset.thumbnail]];
    }
    if ([self respondsToSelector:@selector(finishChoosePhoto)]) {
        [self finishChoosePhoto];
    }
    if ([self respondsToSelector:@selector(imagePickerControllerWithImageArray:)]) {
        [self imagePickerControllerWithImageArray:self.dataImages];
    }
    
    
    [imagePickerController dismissViewControllerAnimated:YES completion:nil];
}

@end
