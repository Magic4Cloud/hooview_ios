//
//  SLShowPhotoViewController.h
//  Education
//
//  Created by shilei on 16/11/7.
//  Copyright © 2016年 CD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLShowPhotoViewController : XZFBaseViewController
@property (nonatomic, strong) NSMutableArray *photoArray;
@property (nonatomic, strong) NSMutableArray *showNumberArr;
@property (nonatomic, strong) NSMutableArray *showStateArr;
@property (nonatomic, strong) NSMutableArray *showPhotoIdArr;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSString *comment_role;
@property (nonatomic, assign) NSInteger interfaceType;

@end
