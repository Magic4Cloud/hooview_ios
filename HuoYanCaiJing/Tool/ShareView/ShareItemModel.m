//
//  ShareItemModel.m
//  Education
//
//  Created by 赵慎修 on 17/3/9.
//  Copyright © 2017年 CD. All rights reserved.
//

#import "ShareItemModel.h"

@implementation ShareItemModel

- (instancetype) initWithDict:(NSDictionary *)dict {
    
    if (self = [super init]) {
        
        self.itemName = dict[@"itemName"];
        self.itemImage = [UIImage imageNamed:dict[@"itemImage"]];
        self.itemShareType = [dict[@"itemShareType"] integerValue];
    }
    
    return self;
}

+ (instancetype) newWithDict:(NSDictionary *)dict {
    
    return [[self alloc] initWithDict:dict];
}

+ (NSArray *) shareItemList {
    
    NSArray * array = [[NSArray alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"ShareItem.plist" ofType:nil]];
    NSMutableArray * functionListArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary * dict in array) {
        [functionListArray addObject:[self newWithDict:dict]];
    }
    
    return functionListArray;
}

@end
