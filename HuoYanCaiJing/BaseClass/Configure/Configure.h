//
//  Configure.h
//  SecurityCheckAccess
//
//  Created by ZPF Mac Pro on 2017/10/16.
//  Copyright © 2017年 ZPF Mac Pro. All rights reserved.
//

#ifndef Configure_h
#define Configure_h


#ifdef DEBUG

#define SLLog(FORMAT, ...) fprintf(stderr, "%s:%zd\t%s\n", [[[NSString stringWithUTF8String: __FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat: FORMAT, ## __VA_ARGS__] UTF8String]);
#else

#define SLLog(FORMAT, ...) nil

#endif

#define WYXNetworkStatusDidChangedNote @"WYXNetworkStatusDidChangedNote"
#define WYXRefreshPersonDataNote @"WYXRefreshPersonDataNote"


/**屏幕宽度*/
#define WIDTH [UIScreen mainScreen].bounds.size.width
/**屏幕高度*/
#define HEIGHT [UIScreen mainScreen].bounds.size.height
/**导航高度*/
#define NAV_HEIGTH 64*SCALE
/**tabbar高度*/
#define TABBAR_HEIGTH 49*SCALE

#define SCREEN_BOUNDS [UIScreen mainScreen].bounds
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
/**相对6p缩放比例*/
#define SCALE (IS_IPHONE_6_PLUS?1:1)
/**UI等比例高度计算**/
#define scaleHeight(height) WIDTH * height/750

//颜色
#define UIColorFromHex(s) [UIColor colorWithRed:(((s & 0xFF0000) >> 16)) / 255.0 green:(((s &0xFF00) >> 8))/255.0 blue:((s &0xFF))/255.0 alpha:1.0]
#define RGB(r,g,b,a)    [UIColor colorWithRed:(r)/255.f green:(g)/255.f blue:(b)/255.f alpha:a/1.f]

#define WEAKSELF typeof(self) __weak weakSelf = self;
/**
 *  相对iphone6 屏幕比
 */
#define KWidth_Scale    [UIScreen mainScreen].bounds.size.width/375.0f
#define KHEIGHT_Scale   [UIScreen mainScreen].bounds.size.height/667.0f

/**设备型号*/
#define IS_IPHONE_5 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double )568) < DBL_EPSILON )
#define IS_IPHONE_6 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double )667) < DBL_EPSILON )
#define IS_IPHONE_6_PLUS (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double )960) < DBL_EPSILON )

//默认图片
#define PlaceholderImg [UIImage imageNamed:@"icon_logo_ colour"]
#define PlaceholderImageView [UIImage imageNamed:@"morentu"]

#define BASE_URL @"http://47.96.130.210:8670/api/"

#define kAppVersion @"kAppVersion"


#define LoginUrl @"user/login" //登录
#define RegisterUrl @"user/register" //注册
#define VerifyUrl @"user/getcode" //验证码
#define CheckcodeUrl @"user/checkcode" //验证验证码

#define ForgetUrl @"user/setPassword" //修改密码


#define AgreementUrl @"user/agreement" //获取注册协议
#define LogoutUrl @"user/logout" //退出

//--- 首页
#define BannerListUrl @"banner/list" //轮播图
#define ApplyOpenUrl @"apply/open" //申请开户

#define LiveTypeListUrl @"liveType/list" //直播分类
#define LiveListUrl @"live/list" //直播列表查询
#define liveInfoUrl @"live/info" //直播详情


//-------资讯
#define FinanceinfoListUrl @"financeinfo/list" //资讯列表
#define FinanceinfoInfoUrl @"financeinfo/info" //资讯详情
#define FinanceCommentListUrl @"financeInfo/commentlist" //资讯评论列表
#define FinanceCommentUrl @"financeInfo/comment" //资讯评论

#define financeInfoCommentpraiseUrl @"financeInfo/commentpraise" //资讯评论点赞
#define financeInfoCommentPraiseCancelUrl @"financeInfo/commentPraiseCancel" //资讯评论点赞取消



#define UserFollowUrl @"user/follow" //关注
#define UserDeleteFollowUrl @"user/deleteFollow" //取消关注

#define FinanceInfoPraiseUrl @"financeInfo/praise" //点赞
#define FinanceInfoCancelPraiseUrl @"financeInfo/cancelPraise" //点赞
#define CollectionAddUrl @"collection/add" //收藏直播&文章


#define CollectionDeleteUrl @"collection/delete" //删除我的收藏
#define UserDeleteMsgUrl @"user/deleteMsg" //删除我的消息
#define UserDeleteHistoryUrl @"user/deleteHistory" //删除历史记录





//-----个人中心
#define UserInfoUrl @"user/info" //获取个人信息
#define FileUploadUrl @"file/upload" //文件上传
#define UserUpdateUrl @"user/update" //修改个人信息

#define UserApplyanchorUrl @"user/applyanchor" //申请主播
#define UserMyfollowUrl @"user/myfollow" //我的关注
#define UserMyfansUrl @"user/myfans" //我的粉丝
#define UserMyMsgUrl @"user/msg" //我的消息
#define UserMymyOrderUrl @"user/myorder" //我的消息
#define CollectionLiveUrl @"collection/live" //我的直播收藏
#define CollectionFinanceUrl @"collection/finance" //我的财经收藏
#define UserHistoryUrl @"user/history" //历史记录
#define UserApplyanchorUrl @"user/applyanchor" //申请主播

#define UserOpinionUrl @"user/opinion" //意见反馈

#define AboutUsInfoUrl @"aboutUs/info" //关于我们








#endif /* Configure_h */
