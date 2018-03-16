//
//  ShareItemModel.h
//  Education
//
//  Created by 赵慎修 on 17/3/9.
//  Copyright © 2017年 CD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareItemModel : NSObject

@property (nonatomic, copy) NSString *itemName;

@property (nonatomic, strong) UIImage *itemImage;

@property (nonatomic, assign) NSInteger itemShareType;

- (instancetype) initWithDict:(NSDictionary *) dict;

+ (instancetype) newWithDict:(NSDictionary *) dict;

+ (NSArray *) shareItemList;


@end
