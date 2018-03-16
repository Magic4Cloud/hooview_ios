//
//  UIViewController+pickerViewController.h
//  onLineLive
//
//  Created by uwant on 16/11/17.
//  Copyright © 2016年 mobiletrain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (pickerViewController)<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

- (void) showOptionImgTypeView;

- (void) imagePickerControllerWithImage:(UIImage *)image;



@end
