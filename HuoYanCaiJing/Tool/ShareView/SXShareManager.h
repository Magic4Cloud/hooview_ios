//
//  SXShareManager.h
//  Education
//
//  Created by 赵慎修 on 17/2/9.
//  Copyright © 2017年 CD. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    ImageResource,
    VideoResource,
    AudioResource,
    URLResource
} ResourceWithType;

@interface SXShareManager : NSObject
//
//+ (void) shareResourceWithType:(ResourceWithType) resourceType
//                  PlatformType:(UMSocialPlatformType) platformType
//                   ResourceUrl:(NSString *) resourceUrl
//                     ThumImage:(UIImage *) thumImage
//                 ResourceTitle:(NSString *) title
//                  ResourceDesc:(NSString *) desc;

@end
