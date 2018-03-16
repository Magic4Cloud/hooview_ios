//
//  HYCJMySetViewController.m
//  HuoYanCaiJing
//
//  Created by ZPF Mac Pro on 2018/1/13.
//  Copyright © 2018年 shilei. All rights reserved.
//

#import "HYCJMySetViewController.h"
#import "HYCJAccountManagementViewController.h"
#import "HYCJFeedbackViewController.h"
#import "HYCJAboutViewController.h"
@interface HYCJMySetViewController ()<UITableViewDataSource,UITableViewDelegate>{
    CGFloat fileSize;
    NSString *cacheDir;
}
@property (strong,nonatomic) UITableView *tableView;

@end

@implementation HYCJMySetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"系统设置";
    [self setupNavigationBar];
    
    cacheDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    [self clearCacheWithPath:cacheDir];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 50) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = RGB(241, 241, 241, 1.0);
//    [self.tableView registerNib:[UINib nibWithNibName:@"HYCJMyMessageTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:identify];
    
    [self.view addSubview:self.tableView];
    
    UIButton *loginOutButton = [[UIButton alloc] initWithFrame:CGRectMake(0, HEIGHT - 50 - 64, WIDTH, 50)];
    [loginOutButton setTitle:@"退出登录" forState:UIControlStateNormal];
    [loginOutButton setTitleColor:RGB(143, 141, 141, 1) forState:UIControlStateNormal];
    loginOutButton.titleLabel.font = [UIFont systemFontOfSize:18];
    loginOutButton.backgroundColor = [UIColor whiteColor];
    [loginOutButton addTarget:self action:@selector(loginOutButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginOutButton];
    
    
    
}

- (void)loginOutButtonAction{
    [XZFHttpManager POST:LogoutUrl parameters:@{} requestSerializer:NO requestToken:YES success:^(id respondseObject) {
        
        NSLog(@"--退出---%@",respondseObject);
//        EMError *error = nil;
//        - (EMError *)logout:(BOOL)aIsUnbindDeviceToken;
        [[EMClient sharedClient]  logout:YES];
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userId"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"loginChangeTableViewUI" object:nil userInfo:nil];
        
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if (section == 1) {
//        return 2;
//    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0&&indexPath.row==0){
        UITableViewCell *cell = [UITableViewCell new];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView *tubeview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_mycenter_more"]];
        [cell.contentView addSubview:tubeview];
        [tubeview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-16);
            //make.top.mas_equalTo(10);
            make.height.mas_equalTo(23);
            make.width.mas_equalTo(23);
            make.centerY.mas_equalTo(cell.contentView.mas_centerY);
            
        }];
        UILabel *dataLabel = [[UILabel alloc]init];
        dataLabel.text = @"账号管理";
        dataLabel.textAlignment = NSTextAlignmentLeft;
        dataLabel.textColor = RGB(74, 74, 74, 1);
        dataLabel.font = [UIFont systemFontOfSize:17];
        [cell.contentView addSubview:dataLabel];
        [dataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(11.5);
            make.centerY.mas_equalTo(cell.contentView.mas_centerY);
            make.height.mas_equalTo(20);
        }];
        return cell;
    }else if (indexPath.section == 1 && indexPath.row == 0){
//        UITableViewCell *cell = [UITableViewCell new];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
//        UILabel *dataLabel = [[UILabel alloc]init];
//        dataLabel.text = @"直播提醒";
//        dataLabel.textAlignment = NSTextAlignmentLeft;
//        dataLabel.textColor = RGB(74, 74, 74, 1);
//        dataLabel.font = [UIFont systemFontOfSize:17];
//        [cell.contentView addSubview:dataLabel];
//        [dataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(11.5);
//            make.centerY.mas_equalTo(cell.contentView.mas_centerY);
//            make.height.mas_equalTo(20);
//        }];
//        
//        UISwitch *mainSwitch = [[UISwitch alloc] init];
//        mainSwitch.on = YES;
//        [cell.contentView addSubview:mainSwitch];
//        [mainSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.mas_equalTo(-16);
//            //make.top.mas_equalTo(10);
////            make.height.mas_equalTo(20);
//            make.centerY.mas_equalTo(cell.contentView.mas_centerY);
//            
//        }];
//        
//        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(9.5, 49, WIDTH - 9.5, 1)];
//        lineView.backgroundColor = RGB(219, 218, 218, 1);
//        [cell.contentView addSubview:lineView];
//        
//        return cell;
//    }else if (indexPath.section == 1 && indexPath.row == 1){
        UITableViewCell *cell = [UITableViewCell new];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *dataLabel = [[UILabel alloc]init];
        dataLabel.text = @"系统缓存";
        dataLabel.textAlignment = NSTextAlignmentLeft;
        dataLabel.textColor = RGB(74, 74, 74, 1);
        dataLabel.font = [UIFont systemFontOfSize:17];
        [cell.contentView addSubview:dataLabel];
        [dataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(11.5);
            make.centerY.mas_equalTo(cell.contentView.mas_centerY);
            make.height.mas_equalTo(20);
        }];
        
        UILabel *numberLab = [[UILabel alloc] init];
        numberLab.text = [NSString stringWithFormat:@"%.2lfM",fileSize];
        numberLab.font = [UIFont systemFontOfSize:17];
        numberLab.textColor = RGB(155, 155, 155, 1);
        numberLab.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:numberLab];
        
        [numberLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-16);
            //make.top.mas_equalTo(10);
            make.height.mas_equalTo(20);
            make.centerY.mas_equalTo(cell.contentView.mas_centerY);
            
        }];
        return cell;
    }else if (indexPath.section == 2 && indexPath.row == 0){
        UITableViewCell *cell = [UITableViewCell new];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *dataLabel = [[UILabel alloc]init];
        dataLabel.text = @"关于火眼";
        dataLabel.textAlignment = NSTextAlignmentLeft;
        dataLabel.textColor = RGB(74, 74, 74, 1);
        dataLabel.font = [UIFont systemFontOfSize:17];
        [cell.contentView addSubview:dataLabel];
        [dataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(11.5);
            make.centerY.mas_equalTo(cell.contentView.mas_centerY);
            make.height.mas_equalTo(20);
        }];
        
        
        UIImageView *tubeview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_mycenter_more"]];
        [cell.contentView addSubview:tubeview];
        [tubeview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-16);
            //make.top.mas_equalTo(10);
            make.height.mas_equalTo(23);
            make.width.mas_equalTo(23);
            make.centerY.mas_equalTo(cell.contentView.mas_centerY);
            
        }];
        
        UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_logo_ colour"]];
        [cell.contentView addSubview:image];
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(tubeview.mas_left).offset(0);
            make.height.mas_equalTo(23);
            make.width.mas_equalTo(23);
            make.centerY.mas_equalTo(cell.contentView.mas_centerY);
            
        }];
        return cell;
    }else{
        UITableViewCell *cell = [UITableViewCell new];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *dataLabel = [[UILabel alloc]init];
        dataLabel.text = @"意见反馈";
        dataLabel.textAlignment = NSTextAlignmentLeft;
        dataLabel.textColor = RGB(74, 74, 74, 1);
        dataLabel.font = [UIFont systemFontOfSize:17];
        [cell.contentView addSubview:dataLabel];
        [dataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(11.5);
            make.centerY.mas_equalTo(cell.contentView.mas_centerY);
            make.height.mas_equalTo(20);
        }];
        
        UIImageView *tubeview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_mycenter_more"]];
        [cell.contentView addSubview:tubeview];
        [tubeview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-16);
            //make.top.mas_equalTo(10);
            make.height.mas_equalTo(23);
            make.width.mas_equalTo(23);
            make.centerY.mas_equalTo(cell.contentView.mas_centerY);
            
        }];
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            HYCJAccountManagementViewController *HYCJ = [[HYCJAccountManagementViewController alloc] init];
            [self.navigationController pushViewController:HYCJ animated:YES];
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            
//        }else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"缓存大小为%.2lfM.确定要清理缓存吗？",fileSize] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            
            UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self clearCachenow:cacheDir];//确定清除
                [SVProgressHUD setMinimumDismissTimeInterval:1];
                [SVProgressHUD showSuccessWithStatus:@"清除成功"];
                fileSize = 0;
                [self.tableView reloadData];
                
                //                [MBProgressHUD showWithView:self.view WithText:@"清除成功" afterDelay:2];
            }];
            
            [alert addAction:cancelAction];
            [alert addAction:confirmAction];
            
            [self.navigationController presentViewController:alert animated:YES completion:nil];
        }
    }else if (indexPath.section == 2){
        HYCJAboutViewController *HYCJ = [[HYCJAboutViewController alloc] init];
        [self.navigationController pushViewController:HYCJ animated:YES];
        
    }else if (indexPath.section == 3){
        HYCJFeedbackViewController *HYCJ = [[HYCJFeedbackViewController alloc] init];
        [self.navigationController pushViewController:HYCJ animated:YES];
        
    }
}

#pragma mark - 清除缓存
- (void)clearCacheWithPath:(NSString *)path
{
//    MBProgressHUD *hud = [MBProgressHUD MBProgressWithView:self.view withText:@"正在计算..."];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        fileSize = [self folderSizeAtPath:path];//计算文件大小
        
        // 回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.tableView reloadData];
//            [hud removeFromSuperview];
//            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"缓存大小为%.2lfM.确定要清理缓存吗？",fileSize] preferredStyle:UIAlertControllerStyleAlert];
//            
//            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//            
//            UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                [self clearCachenow:path];//确定清除
//                [SVProgressHUD setMinimumDismissTimeInterval:1];
//                [SVProgressHUD showSuccessWithStatus:@"修改成功"];
////                [MBProgressHUD showWithView:self.view WithText:@"清除成功" afterDelay:2];
//            }];
//            
//            [alert addAction:cancelAction];
//            [alert addAction:confirmAction];
//            
//            [self.navigationController presentViewController:alert animated:YES completion:nil];
        });
    });
    
    
    
}
+(float)fileSizeAtPath:(NSString *)path{
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    
    if([fileManager fileExistsAtPath:path]){
        long long size=[fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return size/1024.0/1024.0;
    }
    return 0;
}

- (float)folderSizeAtPath:(NSString *)path{
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    float folderSize;
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            folderSize += [HYCJMySetViewController fileSizeAtPath:absolutePath];
        }
        //SDWebImage框架自身计算缓存的实现
        folderSize += [[SDImageCache sharedImageCache] getSize]/1024.0/1024.0;
        return folderSize;
    }
    return 0;
}
- (void)clearCachenow:(NSString *)path{
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            //如有需要，加入条件，过滤掉不想删除的文件
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
    [[EMSDImageCache sharedImageCache] cleanDisk];
    //清除内存缓存
    [[[SDWebImageManager sharedManager] imageCache] clearMemory];
    //清除系统缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}



@end
