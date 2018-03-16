//
//  HYCJHomeLiveDetailMessageViewController.m
//  HuoYanCaiJing
//
//  Created by ZPF Mac Pro on 2018/1/28.
//  Copyright © 2018年 shilei. All rights reserved.
//

#import "HYCJHomeLiveDetailMessageViewController.h"
#import "HYCJLiveMessageTableViewCell.h"
#import "ShareView.h"
#import "AppDelegate.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>

#define SEND_USER_HEAD  @"send_user_head"
#define SEND_USER_NAME  @"nickname"

@interface HYCJHomeLiveDetailMessageViewController ()<EMChatManagerDelegate, EMCDDeviceManagerDelegate, EMChatToolbarDelegate, EaseChatBarMoreViewDelegate, EMLocationViewDelegate,EMChatroomManagerDelegate, EaseMessageCellDelegate,EaseMessageViewControllerDelegate,EaseMessageViewControllerDataSource,ShareViewDelegate,TencentSessionDelegate>{
    UIView *view;
    BOOL _isNetConnect;
    UIImageView *iconImg;
    UILabel *nameLab;
    UILabel *titleLab;
    NSInteger followInt;
    NSDictionary *dic;
    UIButton *attentionButton;
    UIImage *image;
    UIButton *addButton;
    NSInteger collectionInt;//是否收藏
    
}
@property (nonatomic, strong) TencentOAuth *oauth;

@end

@implementation HYCJHomeLiveDetailMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.tableView.frame = CGRectMake(0, 120, WIDTH, HEIGHT - 120);
    self.tableView.backgroundColor = RGB(0, 0, 0, 1);
    self.navigationController.delegate = self;
    self.showRefreshHeader = YES;
    self.delegate = self;
    self.dataSource = self;
    followInt = 0;
    [self.chatBarMoreView removeItematIndex:0];
    [self.chatBarMoreView removeItematIndex:1];
    [self.chatBarMoreView removeItematIndex:2];
    
    _isNetConnect = [[EMClient sharedClient] isConnected];
    
    if (_isNetConnect == YES) {
        NSLog(@"1111111111");
    }else{
        NSLog(@"2222222222");
    }

    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];

    view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 120)];
    view.backgroundColor = RGB(28, 37, 42, 1);
    [self.view addSubview:view];
    
    iconImg = [[UIImageView alloc] initWithFrame:CGRectMake(10.5, 16.5, 38, 38)];
    iconImg.image  = [UIImage imageNamed:@"icon_logo_ colour"];
    iconImg.layer.cornerRadius = 19;
    iconImg.layer.masksToBounds = YES;
    [view addSubview:iconImg];
    
    nameLab = [[UILabel alloc] initWithFrame:CGRectMake(55.5, 14.5, 200, 20)];
    nameLab.text = @"";
    nameLab.font = [UIFont systemFontOfSize:16];
    nameLab.textColor = RGB(255, 255, 255, 1);
    [view addSubview:nameLab];
    
    titleLab = [[UILabel alloc] initWithFrame:CGRectMake(55.5, 35, 200, 20)];
    titleLab.text = @"";
    titleLab.font = [UIFont systemFontOfSize:13];
    titleLab.textColor = RGB(255, 255, 255, 1);
    [view addSubview:titleLab];
    
    attentionButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - 60, 30, 50, 20)];
    [attentionButton setTitle:@"关注" forState:UIControlStateNormal];
    attentionButton.layer.cornerRadius = 10;
    attentionButton.layer.borderColor = [UIColor whiteColor].CGColor;
    attentionButton.layer.borderWidth = 1;
    attentionButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [attentionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [attentionButton addTarget:self action:@selector(attentionButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:attentionButton];
    
    NSArray *imgArr = @[@"icon_live_details_bbs",@"icon_live_details_favorite",@"icon_live_details_share"];
    NSArray *titleArr = @[@"聊天",@"收藏",@"分享"];

    for (int i = 0; i < 3; i ++) {
        if (i != 1) {
            UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(5 + 80 * i, 75, 70, 30)];
            [rightButton setImage:[UIImage imageNamed:imgArr[i]] forState:UIControlStateNormal];
            [rightButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
            [rightButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
            rightButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
            rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
            [rightButton setTitle:[NSString stringWithFormat:@"%@",titleArr[i]] forState:UIControlStateNormal];
            [rightButton setTitleColor:RGB(255, 255, 255, 1) forState:UIControlStateNormal];
            rightButton.tag = i + 1;
            [rightButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:rightButton];
        }
    }
    addButton = [[UIButton alloc] initWithFrame:CGRectMake(85, 75, 70, 30)];
    [addButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [addButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
    addButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    addButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [addButton setTitle:@"收藏" forState:UIControlStateNormal];
    [addButton setTitleColor:RGB(255, 255, 255, 1) forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(collectionButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:addButton];
    UIImageView *bottomImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 110, WIDTH, 10)];
    bottomImg.image = [UIImage imageNamed:@"liveBGView"];
    [view addSubview:bottomImg];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    BOOL tokenBool = [BTToolFormatJudge iSStringNull:token];
    if (tokenBool == NO) {
        [self loadData];
    }else{
        [iconImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.model.logourl]] placeholderImage:PlaceholderImg];
//        nameLab.text = [NSString stringWithFormat:@"%@",self.model.nickname];
        
        NSString *nickNameStr = [NSString stringWithFormat:@"%@",self.model.nickname];
        if ([nickNameStr isEqualToString:@"<null>"] || [nickNameStr isEqualToString:@"(null)"]) {
            nameLab.text = @"";
        }else{
            nameLab.text = nickNameStr;
        }
        
        NSString *titleLabStr = [NSString stringWithFormat:@"%@",self.model.liveInfo];
        if ([titleLabStr isEqualToString:@"<null>"] || [titleLabStr isEqualToString:@"(null)"]) {
            titleLab.text = @"你生活中的财经专家";
        }else{
            titleLab.text = titleLabStr;
        }
    }
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL  URLWithString:[NSString stringWithFormat:@"%@",self.model.logourl]]];
    image = [UIImage imageWithData:data];
    


}

- (void)rightButtonAction:(UIButton *)sender{
    switch (sender.tag) {
        case 1:
        {
            
        }
            break;
        case 2:
        {
            
        }
            break;
        case 3:
        {
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            ShareView *share = [[ShareView alloc]init];
//            [self.view addSubview:share];
            [app.window addSubview:share];
            share.delegate = self;
            [share mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(app.window);
            }];
        }
            break;
        default:
            break;
    }
    
}
//收藏
- (void)collectionButtonAction:(UIButton *)sender{
    [SVProgressHUD show];
    if (collectionInt == 0) {
        NSString *userId = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]];
        [XZFHttpManager POST:CollectionAddUrl parameters:@{@"userId":userId,@"sourceId":self.model.liveId,@"sourceType":@"0"} requestSerializer:NO requestToken:YES success:^(id respondseObject) {
            NSLog(@"---收藏--%@",respondseObject);
            collectionInt = 1;
            [addButton setImage:[UIImage imageNamed:@"icon_news_detail_favorite_sure"] forState:UIControlStateNormal];
            [SVProgressHUD dismiss];
        } failure:^(NSError *error) {
            
        }];
    }else if (collectionInt == 1){
        
        NSString *userId = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]];
        [XZFHttpManager POST:CollectionDeleteUrl parameters:@{@"userId":userId,@"sourceId":self.model.liveId,@"sourceType":@"0"} requestSerializer:NO requestToken:YES success:^(id respondseObject) {
            NSLog(@"---取消收藏--%@",respondseObject);
            collectionInt = 0;
            [addButton setImage:[UIImage imageNamed:@"icon_news_detail_favorite"] forState:UIControlStateNormal];
            [SVProgressHUD dismiss];
        } failure:^(NSError *error) {
            
        }];
    }
}
- (void)shareButtonWithUMShareType:(NSInteger)platformType{
    
    if (platformType == 0) {
        //创建发送对象实例
        SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
        sendReq.bText = NO;//不使用文本信息
        sendReq.scene = 0;//0 = 好友列表 1 = 朋友圈 2 = 收藏
        //创建分享内容对象
        WXMediaMessage *urlMessage = [WXMediaMessage message];
        urlMessage.title = [NSString stringWithFormat:@"%@",self.model.liveTitle];//分享标题
        NSString *infoStr = [NSString stringWithFormat:@"%@",self.model.liveInfo];
        if ([infoStr isEqualToString:@"(null)"] || [infoStr isEqualToString:@"<null>"]) {
            infoStr = @"";
        }
        urlMessage.description = infoStr;//分享描述
        [urlMessage setThumbImage:image];//分享图片,使用SDK的setThumbImage方法可压缩图片大小
        //创建多媒体对象
        WXWebpageObject *webObj = [WXWebpageObject object];
        webObj.webpageUrl = [NSString stringWithFormat:@"http://hyzb.hooview.com/#/ShareVideoPage/%@",self.model.liveId];//分享链接
        //完成发送对象实例
        urlMessage.mediaObject = webObj;
        sendReq.message = urlMessage;
        //发送分享信息
        [WXApi sendReq:sendReq];
    }else if (platformType == 1){
        //创建发送对象实例
        SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
        sendReq.bText = NO;//不使用文本信息
        sendReq.scene = 1;//0 = 好友列表 1 = 朋友圈 2 = 收藏
        //创建分享内容对象
        WXMediaMessage *urlMessage = [WXMediaMessage message];
        urlMessage.title = [NSString stringWithFormat:@"%@",self.model.liveTitle];;//分享标题
        NSString *infoStr = [NSString stringWithFormat:@"%@",self.model.liveInfo];
        if ([infoStr isEqualToString:@"(null)"] || [infoStr isEqualToString:@"<null>"]) {
            infoStr = @"";
        }
        urlMessage.description = infoStr;//分享描述
        [urlMessage setThumbImage:image];//分享图片,使用SDK的setThumbImage方法可压缩图片大小
        //创建多媒体对象
        WXWebpageObject *webObj = [WXWebpageObject object];
        webObj.webpageUrl = [NSString stringWithFormat:@"http://hyzb.hooview.com/#/ShareVideoPage/%@",self.model.liveId];//分享链接
        //完成发送对象实例
        urlMessage.mediaObject = webObj;
        sendReq.message = urlMessage;
        //发送分享信息
        [WXApi sendReq:sendReq];
    }else if (platformType == 2){
        NSString *infoStr = [NSString stringWithFormat:@"%@",self.model.liveInfo];
        if ([infoStr isEqualToString:@"(null)"] || [infoStr isEqualToString:@"<null>"]) {
            infoStr = @"";
        }
        
        _oauth = [[TencentOAuth alloc] initWithAppId:@"1105885323" andDelegate:self];
        QQApiURLObject *urlObject = [QQApiURLObject objectWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://hyzb.hooview.com/#/ShareVideoPage/%@",self.model.liveId]] title:[NSString stringWithFormat:@"%@",self.model.liveTitle] description:infoStr previewImageData:UIImageJPEGRepresentation(image, 1) targetContentType:QQApiURLTargetTypeNews];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:urlObject];
        [QQApiInterface sendReq:req];
        
    }else if (platformType == 3){
        _oauth = [[TencentOAuth alloc] initWithAppId:@"1105885323" andDelegate:self];
        NSString *utf8String = [NSString stringWithFormat:@"http://hyzb.hooview.com/#/ShareVideoPage/%@",self.model.liveId];;
        NSString *title = [NSString stringWithFormat:@"%@",self.model.liveTitle];
        NSString *infoStr = [NSString stringWithFormat:@"%@",self.model.liveInfo];
        if ([infoStr isEqualToString:@"(null)"] || [infoStr isEqualToString:@"<null>"]) {
            infoStr = @"";
        }
        NSString *description = infoStr;
        
        NSString *previewImageUrl = [NSString stringWithFormat:@"%@",self.model.logourl];
        QQApiNewsObject *newsObj = [QQApiNewsObject
                                    objectWithURL:[NSURL URLWithString:utf8String]
                                    title:title
                                    description:description
                                    previewImageURL:[NSURL URLWithString:previewImageUrl]];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
        //将内容分享到qzone
        [QQApiInterface SendReqToQZone:req];
    }
}
- (void)attentionButtonAction:(UIButton *)sender{
    [SVProgressHUD show];
    if (followInt == 0) {
        //        UserFollowUrl
        NSString *userIdStr = [NSString stringWithFormat:@"%@",dic[@"userId"]];
        [XZFHttpManager POST:UserFollowUrl parameters:@{@"userId":userIdStr} requestSerializer:NO requestToken:YES success:^(id respondseObject) {
            NSLog(@"---关注--%@",respondseObject);
            attentionButton.frame = CGRectMake(WIDTH - 80, 30, 70, 20);
            [attentionButton setTitle:@"已关注" forState:UIControlStateNormal];
            followInt = 1;
            [SVProgressHUD dismiss];
        } failure:^(NSError *error) {
            
        }];
    }else if (followInt == 1){
        
        NSString *userIdStr = [NSString stringWithFormat:@"%@",dic[@"userId"]];
        [XZFHttpManager POST:UserDeleteFollowUrl parameters:@{@"userId":userIdStr} requestSerializer:NO requestToken:YES success:^(id respondseObject) {
            NSLog(@"---取消关注--%@",respondseObject);
            attentionButton.frame = CGRectMake(WIDTH - 60, 30, 50, 20);
            [attentionButton setTitle:@"关注" forState:UIControlStateNormal];
            followInt = 0;
            [SVProgressHUD dismiss];
        } failure:^(NSError *error) {
            
        }];
    }
}
- (void)loadData{
    NSString *userId = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]];
    NSString *liveId = [NSString stringWithFormat:@"%@",self.model.liveId];
//    [XZFHttpManager POST:liveInfoUrl parameters:@{@"liveId":liveId} requestSerializer:NO requestToken:YES success:^(id respondseObject) {
//        NSLog(@"---点赞--%@",respondseObject);
//        
//    } failure:^(NSError *error) {
//        
//        
//    }];
    
    [XZFHttpManager GET:liveInfoUrl parameters:@{@"userId":userId,@"liveId":liveId} requestSerializer:NO requestToken:NO success:^(id respondseObject) {
        NSLog(@"--------直播详情--------%@",respondseObject);
        dic = respondseObject[@"liveInfo"];
        [iconImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dic[@"logourl"]]] placeholderImage:PlaceholderImg];
        nameLab.text = [NSString stringWithFormat:@"%@",dic[@"nickname"]];
        
        NSString *titleLabStr = [NSString stringWithFormat:@"%@",dic[@"liveInfo"]];
        if ([titleLabStr isEqualToString:@"<null>"] || [titleLabStr isEqualToString:@"(null)"]) {
            titleLab.text = @"你生活中的财经专家";
        }else{
            titleLab.text = titleLabStr;
        }
        
        NSString *follow = [NSString stringWithFormat:@"%@",dic[@"follow"]];
        followInt = [follow integerValue];
        if (followInt == 1) {
            attentionButton.frame = CGRectMake(WIDTH - 80, 30, 70, 20);
            [attentionButton setTitle:@"已关注" forState:UIControlStateNormal];
        }else{
            attentionButton.frame = CGRectMake(WIDTH - 60, 30, 50, 20);
            [attentionButton setTitle:@"关注" forState:UIControlStateNormal];
        }
        
        NSString  *collectionStr= [NSString stringWithFormat:@"%@",dic[@"collection"]];
        collectionInt = [collectionStr integerValue];
        if (collectionInt == 1) {
            [addButton setImage:[UIImage imageNamed:@"icon_news_detail_favorite_sure"] forState:UIControlStateNormal];
        }else{
            [addButton setImage:[UIImage imageNamed:@"icon_live_details_favorite"] forState:UIControlStateNormal];
        }
    } failure:^(NSError *error) {
        
    }];
}
- (void) keyboardWillHide:(NSNotification*)notification {
    view.hidden = NO;
    view.frame = CGRectMake(0, 0, WIDTH, 120);
    self.tableView.frame = CGRectMake(0, 120, WIDTH, self.view.frame.size.height - 120 - 50);

}
- (void) keyboardWillShow:(NSNotification*)notification {
    view.hidden = YES;
    view.frame = CGRectMake(0, 0, WIDTH, 0);
    self.tableView.frame = CGRectMake(0, 0, WIDTH, self.view.frame.size.height - 120 - 50);
    
}
#pragma mark --- EaseMessageViewControllerDelegate
- (UITableViewCell *)messageViewController:(UITableView *)tableView cellForMessageModel:(id<IMessageModel>)messageModel
{
    
    NSString *CellIdentifier = [HYCJLiveMessageTableViewCell cellIdentifierWithModel:messageModel];
    
    HYCJLiveMessageTableViewCell *sendCell = (HYCJLiveMessageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (sendCell == nil) {
        sendCell = [[HYCJLiveMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier model:messageModel];
        sendCell.selectionStyle = UITableViewCellSelectionStyleNone;
        sendCell.delegate = self;
        sendCell.avatarSize = 0;
        
    }
    sendCell.model = messageModel;
    
    if (messageModel.isSender) {
        sendCell.messageNameColor = RGB(248, 231, 28, 1);
        sendCell.messageNameFont = [UIFont systemFontOfSize:12];
        sendCell.messageNameHeight = 15;
        
    }else{
        sendCell.messageNameColor = RGB(126, 211, 33, 1);
        sendCell.messageNameFont = [UIFont systemFontOfSize:12];
        sendCell.messageNameHeight = 15;
    }
    return sendCell;
    
}

#pragma mark - EaseMessageViewControllerDataSource
- (id<IMessageModel>)messageViewController:(EaseMessageViewController *)viewController
                           modelForMessage:(EMMessage *)message
{
    
    id<IMessageModel> model = nil;
    model = [[EaseMessageModel alloc] initWithMessage:message];
    
    NSString *nickname = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"nickname"]];
    NSString *logo = [NSString stringWithFormat:@"%@",@"http://aliimg.yizhibo.tv/online/user/fe/04/4727ff8aa749c6061ad8dac5110a8517.jpeg@640h_640w_90Q_0e_1c?DV"];
    if (model.isSender) {
        
        NSLog(@"----------------1111111---------------------我发送的");
        model.message.ext = @{SEND_USER_HEAD:logo,
                              SEND_USER_NAME:nickname,
                              };
        
        //头像
        model.avatarURLPath = logo;
        
        //昵称
        model.nickname = [NSString stringWithFormat:@"：%@",nickname];
        
        //消息发送方头像
        model.avatarImage = [UIImage imageNamed:@"d1_touxiang"];
        
    }else{
        NSLog(@"对方发送");
        NSLog(@"----------------222222222---------------------对方发送");
        //头像
        model.avatarURLPath = model.message.ext[SEND_USER_HEAD];
        
        //昵称
        model.nickname = [NSString stringWithFormat:@"%@：",model.message.ext[SEND_USER_NAME]];
        //头像占位图
        //        model.failImageName = @"d1_touxiang";
        //消息发送方头像
        model.avatarImage = [UIImage imageNamed:@"d1_touxiang"];
        
    }
    
    //    model.avatarImage = [UIImage imageNamed:@"d1_touxiang"];
    return model;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
