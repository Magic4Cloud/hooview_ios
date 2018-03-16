//
//  HYCJMineHistoryModel.h
//  HuoYanCaiJing
//
//  Created by ZPF Mac Pro on 2018/1/27.
//  Copyright © 2018年 shilei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYCJMineHistoryModel : NSObject
@property (strong,nonatomic) NSString *browseHistoryId;
@property (strong,nonatomic) NSString *sourceId;
@property (strong,nonatomic) NSString *sourceType;
@property (strong,nonatomic) NSString *createTime;
@property (strong,nonatomic) NSString *title;
@property (strong,nonatomic) NSString *vid;
@property (strong,nonatomic) NSString *liveTypeName;
@property (strong,nonatomic) NSString *logoUrl;
@property (strong,nonatomic) NSString *nickName;
@property (strong,nonatomic) NSString *liveStatus;
@end
