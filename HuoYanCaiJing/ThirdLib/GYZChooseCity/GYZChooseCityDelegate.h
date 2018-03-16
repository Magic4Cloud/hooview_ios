//
//  GYZChooseCityDelegate.h
//  GYZChooseCityDemo
//  选择城市相关delegate
//  Created by wito on 15/12/29.
//  Copyright © 2015年 gouyz. All rights reserved.
//

@class GYZCity;
//@class GYZChooseCityController;
@class XZFChooseCityViewController;


@protocol GYZChooseCityDelegate <NSObject>

- (void) cityPickerController:(XZFChooseCityViewController *)chooseCityController
                didSelectCity:(GYZCity *)city;

- (void) cityPickerControllerDidCancel:(XZFChooseCityViewController *)chooseCityController;

@end

@protocol GYZCityGroupCellDelegate <NSObject>

- (void) cityGroupCellDidSelectCity:(GYZCity *)city;

@end
