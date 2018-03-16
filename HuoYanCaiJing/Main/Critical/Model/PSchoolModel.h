//
//  PSchoolModel.h
//  XueZhiFei
//
//  Created by apple on 2017/11/9.
//  Copyright © 2017年 ZPF Mac Pro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PSchoolModel : NSObject

@property (assign,nonatomic) NSInteger praise;//是否点赞（0-否，1-是）

@property (nonatomic , strong) NSString *infoCommentId;
@property (nonatomic , strong) NSString *comment;
@property (nonatomic , strong) NSString *nickname;
@property (nonatomic , strong) NSString *headUrl;

@property (nonatomic , strong) NSString *createTime
;
@property (nonatomic , strong) NSString *praiseNum;

@property (nonatomic , assign) NSInteger clickStatus;//点赞处理，1增加，2减少



@end
