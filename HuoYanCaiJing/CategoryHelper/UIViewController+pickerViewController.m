//
//  UIViewController+pickerViewController.m
//  onLineLive
//
//  Created by uwant on 16/11/17.
//  Copyright © 2016年 mobiletrain. All rights reserved.
//

#import "UIViewController+pickerViewController.h"


@implementation UIViewController (pickerViewController)

- (void)showOptionImgTypeView {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    LiveMyAlertAction *actionCancel = [LiveMyAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    //actionCancel.textColor = [ColorTool colorWithHexString:@"#333333"];
    __weak typeof(self) weakSelf = self;
    LiveMyAlertAction *actionLibrary = [LiveMyAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf showImgaePickerViewController:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    //actionLibrary.textColor = [ColorTool colorWithHexString:@"#fea018"];
    
    LiveMyAlertAction *actionCamera = [LiveMyAlertAction actionWithTitle:@"拍摄" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf showImgaePickerViewController:UIImagePickerControllerSourceTypeCamera];
    }];
    //actionCamera.textColor = [ColorTool colorWithHexString:@"#fea018"];
    
    [alertVC addAction:actionCancel];
    [alertVC addAction:actionLibrary];
    [alertVC addAction:actionCamera];
    [self presentViewController:alertVC animated:YES completion:nil];
}


- (void) showImgaePickerViewController:(UIImagePickerControllerSourceType)sourceType {
    UIImagePickerController *pickerVC = [[UIImagePickerController alloc] init];
    pickerVC.sourceType = sourceType;
    pickerVC.allowsEditing = YES;
    pickerVC.delegate = self;
    [self presentViewController:pickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    if ([self respondsToSelector:@selector(imagePickerControllerWithImage:)]) {
        [self imagePickerControllerWithImage:image];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerWithImage:(UIImage *)image {
    
}


@end
