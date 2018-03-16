////
////  SXShareManager.m
////  Education
////
////  Created by 赵慎修 on 17/2/9.
////  Copyright © 2017年 CD. All rights reserved.
////
//
//#import "SXShareManager.h"
//
//@implementation SXShareManager
//
//+ (void)shareResourceWithType:(ResourceWithType)resourceType PlatformType:(UMSocialPlatformType)platformType ResourceUrl:(NSString *)resourceUrl ThumImage:(UIImage *)thumImage ResourceTitle:(NSString *)title ResourceDesc:(NSString *)desc{
//    [UMSocialShareUIConfig shareInstance].shareTitleViewConfig.isShow = NO;
//    [UMSocialShareUIConfig shareInstance].sharePageGroupViewConfig.sharePageGroupViewPostionType = UMSocialSharePageGroupViewPositionType_Bottom;
//    [UMSocialShareUIConfig shareInstance].shareCancelControlConfig.isShow = YES;
//    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
//    if (resourceType == ImageResource) {
//        
//        UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
//        [shareObject setShareImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:resourceUrl]]]];
//        
//        messageObject.shareObject = shareObject;
//        
//    } else if (resourceType == VideoResource) {
//        
//        //创建视频内容对象
//        UMShareVideoObject *shareObject = [UMShareVideoObject shareObjectWithTitle:title descr:desc thumImage:thumImage];
//        //设置视频网页播放地址
//        shareObject.videoUrl = resourceUrl;
//        //            shareObject.videoStreamUrl = @"这里设置视频数据流地址（如果有的话，而且也要看所分享的平台支不支持）";
//        
//        //分享消息对象设置分享内容对象
//        messageObject.shareObject = shareObject;
//        
//    } else if (resourceType == AudioResource) {
//    
//        //创建音乐内容对象
//        UMShareMusicObject *shareObject = [UMShareMusicObject shareObjectWithTitle:title descr:desc thumImage:thumImage];
//        //设置音乐网页播放地址
//        shareObject.musicUrl = resourceUrl;
//        //            shareObject.musicDataUrl = @"这里设置音乐数据流地址（如果有的话，而且也要看所分享的平台支不支持）";
//        //分享消息对象设置分享内容对象
//        messageObject.shareObject = shareObject;
//        
//    } else if (resourceType == URLResource) {
//        
//        //创建网页内容对象
//        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:desc thumImage:thumImage];
//        //设置网页地址
//        shareObject.webpageUrl = resourceUrl;
//        
//        //分享消息对象设置分享内容对象
//        messageObject.shareObject = shareObject;
//        
//    } else {
//    
//        return;
//    }
//    
//    //调用分享接口
//    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
//        if (error) {
//            NSLog(@"************Share fail with error %@*********",error);
//        }else{
//            NSLog(@"response data is %@",data);
//        }
//    }];
//
//}
//
//@end
