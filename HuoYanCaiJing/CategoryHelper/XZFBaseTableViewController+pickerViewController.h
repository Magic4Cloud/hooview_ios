//
//  WYXBaseTableViewController+pickerViewController.h
//  wuyuexin
//
//  Created by 万显武 on 17/6/8.
//  Copyright © 2017年 even. All rights reserved.
//

#import "XZFBaseTableViewController.h"

@interface XZFBaseTableViewController (pickerViewController) <UIImagePickerControllerDelegate,UINavigationControllerDelegate,QBImagePickerControllerDelegate>



- (void) showOptionImgTypeView;

- (void) imagePickerControllerWithImage:(UIImage *)image;


- (void)showManyOptionImgTypeView;

- (void)finishChoosePhoto;

@end
