//
//  UIViewController+pickerViewController.h
//  onLineLive
//
//  Created by uwant on 16/11/17.
//  Copyright © 2016年 mobiletrain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QBImagePickerController.h"
#import "XZFBaseViewController.h"

@interface XZFBaseViewController (pickerViewController)<UIImagePickerControllerDelegate,UINavigationControllerDelegate,QBImagePickerControllerDelegate>



- (void) showOptionImgTypeView;

- (void) imagePickerControllerWithImage:(UIImage *)image;

- (void) imagePickerControllerWithImageArray:(NSArray *)imageArray;

- (void)showManyOptionImgTypeView;

- (void)finishChoosePhoto;

@end
