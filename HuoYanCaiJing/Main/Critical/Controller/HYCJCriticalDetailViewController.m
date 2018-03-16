//
//  HYCJCriticalDetailViewController.m
//  HuoYanCaiJing
//
//  Created by ZPF Mac Pro on 2018/1/28.
//  Copyright © 2018年 shilei. All rights reserved.
//

#import "HYCJCriticalDetailViewController.h"
#import "BottomRecommView.h"
#import "ShareView.h"
#import "HYCJCommentsListViewController.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>

@interface HYCJCriticalDetailViewController ()<UIWebViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,BottomRecommViewDelegate,ShareViewDelegate,TencentSessionDelegate>{
    NSString *webStr;
    CGFloat oneWebViewHeight;
    UIButton *textButton;
    UIView *bottomBGView;
    NSArray *recommendList;
    NSDictionary *dic;
    NSString *financeInfoIdStr;
    NSInteger followInt;//是否关注
    NSInteger praiseInt;//是否点赞
    NSInteger collectionInt;//是否收藏
    UIButton *collectionButton;
    UIImage *image;
    UILabel *newMoneyOneLab;
    UILabel *newMoneyTwoLab;
    UIImageView *iconImg;
}
@property (nonatomic ,strong) UIWebView *webView;
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) BottomRecommView *bottomView;
@property (nonatomic, strong) TencentOAuth *oauth;

@end

@implementation HYCJCriticalDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    oneWebViewHeight = 0;
    followInt = 0;
    praiseInt = 0;
    collectionInt = 0;
//    [self setupNavigationBar];
    self.view.backgroundColor = UIColorFromHex(0xF0F0F0);
    webStr = @"";
    financeInfoIdStr = self.financeInfoId;
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL  URLWithString:[NSString stringWithFormat:@"%@",self.model.coverPic]]];
    image = [UIImage imageWithData:data];
    
    
    iconImg = [[UIImageView alloc] initWithFrame:CGRectMake(12, 20, 38, 38)];
    iconImg.image = [UIImage imageNamed:@"morentu"];
    iconImg.layer.cornerRadius = 19;
    iconImg.layer.masksToBounds = YES;
    [self.navigationController.view addSubview:iconImg];
    
    newMoneyOneLab = [[UILabel alloc] initWithFrame:CGRectMake(57, 22, 200, 20)];
    newMoneyOneLab.text = @"";
    newMoneyOneLab.textAlignment = NSTextAlignmentLeft;
    newMoneyOneLab.font = [UIFont systemFontOfSize:16];
    newMoneyOneLab.textColor = [UIColor whiteColor];
    [self.navigationController.view addSubview: newMoneyOneLab];
    
    newMoneyTwoLab = [[UILabel alloc] initWithFrame:CGRectMake(57, 42, 230*KWidth_Scale, 20)];
    newMoneyTwoLab.text = @"你生活中的财经专家";
    newMoneyTwoLab.textAlignment = NSTextAlignmentLeft;
    newMoneyTwoLab.font = [UIFont systemFontOfSize:13];
    newMoneyTwoLab.textColor = [UIColor whiteColor];
    [self.navigationController.view addSubview: newMoneyTwoLab];
    
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 50 - 64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = UIColorFromHex(0xF0F0F0);
    
    [self.view addSubview:self.tableView];
    
    _bottomView = [[BottomRecommView alloc] init];
    _bottomView.delegate = self;
    _bottomView.textFiled.delegate = self;
    [self.view addSubview:_bottomView];
    
    [_bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.mas_bottom).offset(0);
        make.right.left.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
//        make.height.offset(50);
    }];
    
    bottomBGView = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT - 50 - 64, WIDTH, 50)];
    bottomBGView.backgroundColor = UIColorFromHex(0xEDEDED);
    [self.view addSubview:bottomBGView];
    
    UIButton *leftButton = [[UIButton alloc] init];
    [leftButton setImage:[UIImage imageNamed:@"icon_news_detail_back"] forState:UIControlStateNormal];
    leftButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [leftButton addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBGView addSubview:leftButton];
    
    [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.equalTo(bottomBGView).offset(0);
        make.width.offset(50);
    }];
    
    
    textButton = [[UIButton alloc]initWithFrame:CGRectMake(65, 10, WIDTH - 180, 30)];
    textButton.backgroundColor = [UIColor whiteColor];
    textButton.layer.cornerRadius = 15;
    [textButton addTarget:self action:@selector(backmain) forControlEvents:UIControlEventTouchUpInside];
    
    [bottomBGView addSubview:textButton];
    
    UILabel *textLab = [[UILabel alloc] initWithFrame:CGRectMake(70, 10, 100, 30)];
    textLab.text = @"输入评论";
    textLab.font = [UIFont systemFontOfSize:14];
    textLab.textColor = UIColorFromHex(0x999999);
    [bottomBGView addSubview:textLab];
    
    
    NSArray *imgArr = @[@"icon_news_detail_share",@"icon_news_detail_favorite",@"icon_news_detail_comment"];

    for (int i = 0; i < 3; i ++) {
        
        if (i != 1) {
            UIButton *rightButton = [[UIButton alloc] init];
            [rightButton setImage:[UIImage imageNamed:imgArr[i]] forState:UIControlStateNormal];
            rightButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
            rightButton.tag = i + 1;
            [rightButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [bottomBGView addSubview:rightButton];
            
            [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(bottomBGView.mas_top).offset(10);
                make.right.offset(-(5 + 35 * i));
                make.width.offset(30);
                make.height.offset(30);
            }];
        }
    }
    
    collectionButton = [[UIButton alloc] init];
    [collectionButton setImage:[UIImage imageNamed:@"icon_news_detail_favorite"] forState:UIControlStateNormal];
    collectionButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [collectionButton addTarget:self action:@selector(collectionButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBGView addSubview:collectionButton];
    
    [collectionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomBGView.mas_top).offset(10);
        make.right.offset(-(5 + 35 * 1));
        make.width.offset(30);
        make.height.offset(30);
    }];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [self loadFinanceDetailData];
}
- (void) keyboardWillHide:(NSNotification*)notification {
    bottomBGView.frame = CGRectMake(0, HEIGHT - 50 - 64, WIDTH, 50);
    bottomBGView.hidden = NO;
}
- (void)backmain{
    bottomBGView.hidden = YES;
    bottomBGView.frame = CGRectMake(0, HEIGHT - 50 - 64, WIDTH, 0);
    [_bottomView.textFiled becomeFirstResponder];
}
- (void)leftButtonAction:(UIButton *)sender{
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
}

#pragma mark --- 发送评论

-(void)senButtonPressedWith:(NSString *)content{
    NSString *userId = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]];
    [SVProgressHUD show];
    
    [XZFHttpManager POST:FinanceCommentUrl parameters:@{@"financeInfoId":self.financeInfoId,@"comment":content,@"userId":userId} requestSerializer:NO requestToken:YES success:^(id respondseObject) {
        
        NSLog(@"------发送评论--------%@",respondseObject);
    [[NSNotificationCenter defaultCenter]postNotificationName:@"EmptyTextFiledNotification" object:nil userInfo:nil];
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        
    }];

}
- (void)rightButtonAction:(UIButton *)sender{
    switch (sender.tag) {
        case 1:
        {
            ShareView *share = [[ShareView alloc]init];
            [self.view addSubview:share];
            share.delegate = self;
            [share mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.view);
            }];
        }
            break;
        case 2:
        {
            
        }
            break;
        case 3:
        {
            HYCJCommentsListViewController *HYCJVC = [[HYCJCommentsListViewController alloc] init];
            HYCJVC.financeInfoId = financeInfoIdStr;
            //    HYCJVC.hidesBottomBarWhenPushed = YES;
            //    [self.navigationController pushViewController:HYCJVC animated:YES];
            XZFNavigationController *nav=[[XZFNavigationController alloc]initWithRootViewController:HYCJVC];
            [self presentViewController :nav animated:NO completion:nil];
        }
            break;
            
        default:
            break;
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
        urlMessage.title = @"火眼财经";//分享标题
        urlMessage.description = [NSString stringWithFormat:@"%@",self.model.summary];//分享描述
        [urlMessage setThumbImage:image];//分享图片,使用SDK的setThumbImage方法可压缩图片大小
        //创建多媒体对象
        WXWebpageObject *webObj = [WXWebpageObject object];
        webObj.webpageUrl = [NSString stringWithFormat:@"http://hyzb.hooview.com/#/SharePage/%@",self.financeInfoId];//分享链接
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
        urlMessage.title = @"火眼财经";//分享标题
        urlMessage.description = [NSString stringWithFormat:@"%@",self.model.summary];//分享描述
        [urlMessage setThumbImage:image];//分享图片,使用SDK的setThumbImage方法可压缩图片大小
        //创建多媒体对象
        WXWebpageObject *webObj = [WXWebpageObject object];
        webObj.webpageUrl = [NSString stringWithFormat:@"http://hyzb.hooview.com/#/SharePage/%@",self.financeInfoId];//分享链接
        //完成发送对象实例
        urlMessage.mediaObject = webObj;
        sendReq.message = urlMessage;
        //发送分享信息
        [WXApi sendReq:sendReq];
    }else if (platformType == 2){
        _oauth = [[TencentOAuth alloc] initWithAppId:@"1105885323" andDelegate:self];
        QQApiURLObject *urlObject = [QQApiURLObject objectWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://hyzb.hooview.com/#/SharePage/%@",self.financeInfoId]] title:@"火眼财经" description:[NSString stringWithFormat:@"%@",self.model.summary] previewImageData:UIImageJPEGRepresentation(image, 1) targetContentType:QQApiURLTargetTypeNews];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:urlObject];
        [QQApiInterface sendReq:req];
        
    }else if (platformType == 3){
        _oauth = [[TencentOAuth alloc] initWithAppId:@"1105885323" andDelegate:self];
        NSString *utf8String = [NSString stringWithFormat:@"http://hyzb.hooview.com/#/SharePage/%@",self.financeInfoId];;
        NSString *title = @"火眼财经";
        NSString *description = [NSString stringWithFormat:@"%@",self.model.summary];
        NSString *previewImageUrl = [NSString stringWithFormat:@"%@",self.model.coverPic];
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
- (void)handleSendResult:(QQApiSendResultCode)sendResult
{
    switch (sendResult)
    {
        case EQQAPIAPPNOTREGISTED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"App未注册" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            
            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送参数错误" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            
            break;
        }
        case EQQAPIQQNOTINSTALLED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"未安装手Q" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            
            break;
        }
        case EQQAPIQQNOTSUPPORTAPI:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"API接口不支持" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            
            break;
        }
        case EQQAPISENDFAILD:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            
            break;
        }
        case EQQAPIVERSIONNEEDUPDATE:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"当前QQ版本太低，需要更新" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        default:
        {
            break;
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return oneWebViewHeight;
        }
        
        return 120;
    }
    
    return 50;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        return recommendList.count;
    }
    return 2;
}
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headrView = [[UIView alloc] init];
    headrView.backgroundColor = [UIColor whiteColor];
    if (section == 0) {
        headrView.frame = CGRectMake(0, 0, WIDTH, 133);
        CGFloat titleHeight = [self calculateTitleHeight:[NSString stringWithFormat:@"%@",dic[@"title"]]];
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(12.5, 13, WIDTH - 25, titleHeight)];
        titleLab.text = [NSString stringWithFormat:@"%@",dic[@"title"]];
        titleLab.textColor = RGB(55, 55, 55, 1);
        titleLab.font = [UIFont systemFontOfSize:18];
        titleLab.numberOfLines = 0;
        [headrView addSubview:titleLab];
        
        UILabel *timeLab = [[UILabel alloc] initWithFrame:CGRectMake(12.5, titleHeight + 18, 200, 18)];
        timeLab.text = [NSString stringWithFormat:@"%@",dic[@"createTime"]];
        timeLab.textColor = RGB(147, 147, 147, 1);
        timeLab.font = [UIFont systemFontOfSize:13];
        [headrView addSubview:timeLab];
        
        
        NSString *keywordStr = [NSString stringWithFormat:@"%@",dic[@"keyword"]];
        if ([keywordStr isEqualToString:@"(null)"] || [keywordStr isEqualToString:@"<null>"]) {
            
        }else{
            NSArray  *keywordArray = [keywordStr componentsSeparatedByString:@","];
            CGFloat widthNum = 0;
            NSLog(@"-------------%@",keywordArray);
            for (int i = 0; i < keywordArray.count; i ++) {
                CGFloat width = [self widthForString:[NSString stringWithFormat:@"%@",keywordArray[i]] fontSize:13 andHeight:23];
                widthNum = widthNum + width + 20 + 7;
                if (i == 0) {
                    widthNum = 0;
                }
                UILabel *keywordLab = [[UILabel alloc] initWithFrame:CGRectMake(10 + widthNum, titleHeight + 45, width + 20, 23)];
                keywordLab.text = [NSString stringWithFormat:@"%@",keywordArray[i]];
                keywordLab.textColor = RGB(55, 55, 55, 1);
                keywordLab.backgroundColor = RGB(241, 241, 241, 1);
                keywordLab.font = [UIFont systemFontOfSize:13];
                keywordLab.layer.cornerRadius = 2.5;
                keywordLab.textAlignment = NSTextAlignmentCenter;
                [headrView addSubview:keywordLab];
            }
        }
        
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, titleHeight + 83, WIDTH - 20, 1.5)];
        lineView.backgroundColor = RGB(205, 205, 205, 1);
        [headrView addSubview:lineView];
        
    }else{
        headrView.frame = CGRectMake(0, 0, WIDTH, 50);
        UILabel *recommendTopLab = [[UILabel alloc] initWithFrame:CGRectMake(10.5, 19, 230*KWidth_Scale, 20)];
        recommendTopLab.text = @"相关推荐";
        recommendTopLab.textAlignment = NSTextAlignmentLeft;
        recommendTopLab.font = [UIFont systemFontOfSize:18];
        recommendTopLab.textColor = RGB(234, 72, 96, 1);
        [headrView addSubview:recommendTopLab];
    }
    return headrView;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 50;
    }
    CGFloat titleHeight = [self calculateTitleHeight:[NSString stringWithFormat:@"%@",dic[@"title"]]];
    return titleHeight + 85;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [UITableViewCell new];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            self.webView = [[UIWebView alloc]init];
            self.webView.delegate = self;
            self.webView.scrollView.showsVerticalScrollIndicator = NO;
            self.webView.scrollView.scrollEnabled = NO;
            self.webView.backgroundColor = [UIColor whiteColor];
            //        self.webView.scrollView.showsVerticalScrollIndicator = NO;
            if (webStr.length > 0) {
                [self.webView loadHTMLString:webStr baseURL:nil];
            }
            [cell.contentView addSubview:self.webView];
            [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(0);
                make.top.mas_equalTo(0);
                make.right.mas_equalTo(0);
                make.bottom.mas_equalTo(0);
            }];
        }else{
            UIButton *goodButton = [[UIButton alloc]init];
            NSString *praiseStr = [NSString stringWithFormat:@"%@",dic[@"praise"]];
            if ([praiseStr isEqualToString:@"1"]) {
                [goodButton setImage:[UIImage imageNamed:@"icon_news_praise_x_sure"] forState:UIControlStateNormal];
                praiseInt = 2;
            }else{
                [goodButton setImage:[UIImage imageNamed:@"icon_news_praise_x"] forState:UIControlStateNormal];
                praiseInt = 1;
            }
            [goodButton addTarget:self action:@selector(goodButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:goodButton];
            [goodButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(51);
                make.height.mas_equalTo(51);
                make.centerY.mas_equalTo(cell.contentView.mas_centerY);
                make.centerX.mas_equalTo(cell.contentView.mas_centerX);
            }];
            
            UILabel *praiseNumLab = [[UILabel alloc] init];
            praiseNumLab.textColor = RGB(55, 55, 55, 1);
            praiseNumLab.font = [UIFont systemFontOfSize:16];
            praiseNumLab.textAlignment = NSTextAlignmentCenter;
            NSString *praiseNumStr = [NSString stringWithFormat:@"%@",dic[@"praiseNum"]];
            if (![praiseNumStr isEqualToString:@"<null>"] || ![praiseNumStr isEqualToString:@"(null)"]) {
                praiseNumLab.text = praiseNumStr;
            }else{
                praiseNumLab.text = 0;
            }
            
            [cell.contentView addSubview:praiseNumLab];
            [praiseNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(200);
                make.height.mas_equalTo(20);
                make.centerX.mas_equalTo(cell.contentView.mas_centerX);
                make.top.equalTo(goodButton.mas_bottom).offset(5);
            }];
        }
        
    }else{
        UILabel *recommendedLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 13, WIDTH - 20, 20)];
        if (recommendList.count > 0) {
            recommendedLab.text = recommendList[indexPath.row][@"title"];
        }
        recommendedLab.textAlignment = NSTextAlignmentLeft;
        recommendedLab.font = [UIFont systemFontOfSize:16];
        recommendedLab.textColor = RGB(74, 74, 74, 1);
        
        [cell.contentView addSubview:recommendedLab];
    }
    
    return cell;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        financeInfoIdStr = [NSString stringWithFormat:@"%@",recommendList[indexPath.row][@"financeInfoId"]];
        oneWebViewHeight = 0;
        webStr = @"";
        [self loadFinanceDetailData];
    }
}
#pragma mark - UIWebViewDelegate
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [SVProgressHUD showErrorWithStatus:@"加载失败"];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    if (self.webView) {
        CGFloat height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
        
        self.webView.scrollView.contentSize = CGSizeMake(0, height + 25);
        
        if (oneWebViewHeight == 0) {
            oneWebViewHeight = height + 15;
            NSLog(@"---------------%f",oneWebViewHeight);
            [self.tableView reloadData];
//            [SVProgressHUD dismiss];
        }
    }
}

- (void)loadFinanceDetailData{
    NSString *userId = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]];
    [SVProgressHUD show];
    [XZFHttpManager GET:FinanceinfoInfoUrl parameters:@{@"userId":userId,@"financeInfoId":financeInfoIdStr} requestSerializer:NO requestToken:NO success:^(id respondseObject) {
        
        //        NSLog(@"---资讯详情---%@",respondseObject);
        NSLog(@"---------%@",respondseObject[@"financeInfo"]);
        dic = respondseObject[@"financeInfo"];
        recommendList = dic[@"recommendList"];
        webStr = respondseObject[@"financeInfo"][@"content"];
        
//        iconImg = [[UIImageView alloc] initWithFrame:CGRectMake(12, 20, 38, 38)];
//        iconImg.image = PlaceholderImageView;
        [iconImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dic[@"headUrl"]]] placeholderImage:PlaceholderImageView];
//        iconImg.layer.cornerRadius = 19;
//        iconImg.layer.masksToBounds = YES;
//        [self.navigationController.view addSubview:iconImg];
        
//        newMoneyOneLab = [[UILabel alloc] initWithFrame:CGRectMake(57, 22, 200, 20)];
        newMoneyOneLab.text = dic[@"nickname"];
//        newMoneyOneLab.textAlignment = NSTextAlignmentLeft;
//        newMoneyOneLab.font = [UIFont systemFontOfSize:16];
//        newMoneyOneLab.textColor = [UIColor whiteColor];
//        [self.navigationController.view addSubview: newMoneyOneLab];
        
//        newMoneyTwoLab = [[UILabel alloc] initWithFrame:CGRectMake(57, 42, 230*KWidth_Scale, 20)];
        NSString *newMoneyTwoStr = [NSString stringWithFormat:@"%@",dic[@"introduce"]];
        if ([newMoneyTwoStr isEqualToString:@"<null>"] || [newMoneyTwoStr isEqualToString:@"(null)"]) {
            newMoneyTwoLab.text = @"你生活中的财经专家";
        }else{
            newMoneyTwoLab.text = newMoneyTwoStr;
        }
//        newMoneyTwoLab.textAlignment = NSTextAlignmentLeft;
//        newMoneyTwoLab.font = [UIFont systemFontOfSize:13];
//        newMoneyTwoLab.textColor = [UIColor whiteColor];
//        [self.navigationController.view addSubview: newMoneyTwoLab];
        
        UIButton *backmainButton = [[UIButton alloc] init];
        NSString *followStr = [NSString stringWithFormat:@"%@",dic[@"follow"]];
        if ([followStr isEqualToString:@"1"]) {
            backmainButton.frame = CGRectMake(0, 0, 70, 20);
            [backmainButton setTitle:@"已关注" forState:UIControlStateNormal];
            followInt = 2;
        }else{
            backmainButton.frame = CGRectMake(0, 0, 50, 20);
            [backmainButton setTitle:@"关注" forState:UIControlStateNormal];
            followInt = 1;
        }
        backmainButton.layer.cornerRadius = 10;
        backmainButton.layer.borderColor = [UIColor whiteColor].CGColor;
        backmainButton.layer.borderWidth = 1;
        backmainButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [backmainButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [backmainButton addTarget:self action:@selector(followAction:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backmainItem = [[UIBarButtonItem alloc] initWithCustomView:backmainButton];
        
        [self.navigationItem setRightBarButtonItem:backmainItem];
        
        NSString *collectionStr = [NSString stringWithFormat:@"%@",dic[@"collection"]];
        if ([collectionStr isEqualToString:@"1"]) {
            collectionInt = 2;
            [collectionButton setImage:[UIImage imageNamed:@"icon_news_detail_favorite_sure"] forState:UIControlStateNormal];
        }else{
            collectionInt = 1;
            [collectionButton setImage:[UIImage imageNamed:@"icon_news_detail_favorite"] forState:UIControlStateNormal];
        }
        

        
        [self.tableView reloadData];
        
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        
    }];
}


//关注
- (void)followAction:(UIButton *)followAction{
    [SVProgressHUD show];
    if (followInt == 1) {
//        UserFollowUrl
        NSString *userIdStr = [NSString stringWithFormat:@"%@",dic[@"userId"]];
        [XZFHttpManager POST:UserFollowUrl parameters:@{@"userId":userIdStr} requestSerializer:NO requestToken:YES success:^(id respondseObject) {
            NSLog(@"---关注--%@",respondseObject);
            UIButton *backmainButton = [[UIButton alloc] init];
            backmainButton.frame = CGRectMake(0, 0, 70, 20);
            [backmainButton setTitle:@"已关注" forState:UIControlStateNormal];
            followInt = 2;
            backmainButton.layer.cornerRadius = 10;
            backmainButton.layer.borderColor = [UIColor whiteColor].CGColor;
            backmainButton.layer.borderWidth = 1;
            backmainButton.titleLabel.font = [UIFont systemFontOfSize:13];
            [backmainButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [backmainButton addTarget:self action:@selector(followAction:) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *backmainItem = [[UIBarButtonItem alloc] initWithCustomView:backmainButton];
            
            [self.navigationItem setRightBarButtonItem:backmainItem];
            [SVProgressHUD dismiss];
        } failure:^(NSError *error) {
            
        }];
    }else if (followInt == 2){
        
        NSString *userIdStr = [NSString stringWithFormat:@"%@",dic[@"userId"]];
        [XZFHttpManager POST:UserDeleteFollowUrl parameters:@{@"userId":userIdStr} requestSerializer:NO requestToken:YES success:^(id respondseObject) {
            NSLog(@"---取消关注--%@",respondseObject);
            UIButton *backmainButton = [[UIButton alloc] init];
            backmainButton.frame = CGRectMake(0, 0, 50, 20);
            [backmainButton setTitle:@"关注" forState:UIControlStateNormal];
            followInt = 1;
            backmainButton.layer.cornerRadius = 10;
            backmainButton.layer.borderColor = [UIColor whiteColor].CGColor;
            backmainButton.layer.borderWidth = 1;
            backmainButton.titleLabel.font = [UIFont systemFontOfSize:13];
            [backmainButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [backmainButton addTarget:self action:@selector(followAction:) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *backmainItem = [[UIBarButtonItem alloc] initWithCustomView:backmainButton];
            [self.navigationItem setRightBarButtonItem:backmainItem];
            [SVProgressHUD dismiss];
        } failure:^(NSError *error) {
            
        }];
    }
}
//点赞
- (void)goodButtonAction:(UIButton *)sender{
    [SVProgressHUD show];
    if (praiseInt == 1) {
        [XZFHttpManager POST:FinanceInfoPraiseUrl parameters:@{@"financeInfoId":financeInfoIdStr} requestSerializer:NO requestToken:YES success:^(id respondseObject) {
            NSLog(@"---点赞--%@",respondseObject);
            [self loadFinanceDetailData];
            
        } failure:^(NSError *error) {
            
            
        }];
    }else if (praiseInt == 2){
        
        [XZFHttpManager POST:FinanceInfoCancelPraiseUrl parameters:@{@"financeInfoId":financeInfoIdStr} requestSerializer:NO requestToken:YES success:^(id respondseObject) {
            NSLog(@"---取消点赞--%@",respondseObject);
            [self loadFinanceDetailData];
        } failure:^(NSError *error) {
            
        }];
    }
}
//收藏
- (void)collectionButtonAction:(UIButton *)sender{
    [SVProgressHUD show];
    if (collectionInt == 1) {
        NSString *userId = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]];
        [XZFHttpManager POST:CollectionAddUrl parameters:@{@"userId":userId,@"sourceId":financeInfoIdStr,@"sourceType":@"1"} requestSerializer:NO requestToken:YES success:^(id respondseObject) {
            NSLog(@"---收藏--%@",respondseObject);
            collectionInt = 2;
            [collectionButton setImage:[UIImage imageNamed:@"icon_news_detail_favorite_sure"] forState:UIControlStateNormal];
            [SVProgressHUD dismiss];
        } failure:^(NSError *error) {
            
        }];
    }else if (collectionInt == 2){
        
        NSString *userId = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]];
        [XZFHttpManager POST:CollectionDeleteUrl parameters:@{@"userId":userId,@"sourceId":financeInfoIdStr,@"sourceType":@"1"} requestSerializer:NO requestToken:YES success:^(id respondseObject) {
            NSLog(@"---取消收藏--%@",respondseObject);
            collectionInt = 1;
            [collectionButton setImage:[UIImage imageNamed:@"icon_news_detail_favorite"] forState:UIControlStateNormal];
            [SVProgressHUD dismiss];
        } failure:^(NSError *error) {
            
        }];
    }
}

- (CGFloat)calculateTitleHeight:(NSString *)String{
    CGSize size = [NSString stringLengthWithAttrStr:String width:WIDTH - 25 font:18 lineSpace:3];
    return size.height;
}
-(float) widthForString:(NSString *)value fontSize:(float)fontSize andHeight:(float)height

{
    
    CGSize sizeToFit = [value sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(CGFLOAT_MAX, height) lineBreakMode:NSLineBreakByWordWrapping];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
    
    return sizeToFit.width;
    
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
