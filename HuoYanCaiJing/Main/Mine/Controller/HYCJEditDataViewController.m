//
//  HYCJEditDataViewController.m
//  HuoYanCaiJing
//
//  Created by ZPF Mac Pro on 2018/1/10.
//  Copyright © 2018年 shilei. All rights reserved.
//

#import "HYCJEditDataViewController.h"
#import "LJTXPerfectInformationSettingViewController.h"

@interface HYCJEditDataViewController ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    NSString *nameStr;
    NSString *sexStr;
    NSString *avatarStr;
    NSString *identityStr;
    NSDictionary *dataDic;
    NSString * region;
    NSString * introduce;
}

@property (strong,nonatomic) UIImageView *headerImage;
@property (strong,nonatomic) UILabel *nameLabel;
@property (strong,nonatomic) UILabel *sex;
@property (strong,nonatomic) UILabel *nomal;
@property (strong,nonatomic) UILabel *introduce;
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSMutableArray *tableData;
@property (strong,nonatomic) UIButton *exitLogin;

@end

@implementation HYCJEditDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"编辑资料";
    avatarStr = @"";
    UIButton *backmainButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 52/3, 52/3)];
    [backmainButton setImage:[UIImage imageNamed:@"return_white"] forState:UIControlStateNormal];
    [backmainButton addTarget:self action:@selector(backmain) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backmainItem = [[UIBarButtonItem alloc] initWithCustomView:backmainButton];
    [self.navigationItem setLeftBarButtonItem:backmainItem];
    
    identityStr = @"1";
    self.tableView = [self tableView];
    [self.view addSubview:_tableView];
    [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
    }];
    [self loadUserInfoData];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(HYCJEditDataViewControllerUI:) name:@"HYCJEditDataViewControllerUI" object:nil];
}

- (void)HYCJEditDataViewControllerUI:(NSNotification *)notification{
    [self loadUserInfoData];
}

- (void)backmain{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableView *)tableView{
    if (_tableView) {
        //        [_tableView removeFromSuperview];
        return _tableView;
    }
    
    UITableView *table = [[UITableView alloc] init];
    table.delegate = self;
    table.dataSource = self;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.backgroundColor = UIColorFromHex(0xF7F7F7);
    table.scrollEnabled = NO;
    return table;
}

- (UIImageView *)headerImage{
    if (_headerImage) {
//        [_headerImage removeFromSuperview];
        return _headerImage;
    }
    
    UIImageView *view = [[UIImageView alloc] init];
    view.contentMode = UIViewContentModeScaleAspectFill;
    view.clipsToBounds = YES;
    view.layer.cornerRadius = 32;
    view.backgroundColor = [UIColor grayColor];
    return view;
}

- (UILabel *)nameLabel{
    if (_nameLabel) {
//        [_nameLabel removeFromSuperview];
        return _nameLabel;
    }
    
    UILabel *label = [[UILabel alloc] init];
    label.text = nameStr;
    label.font = [UIFont pingfangRegularFontWithSize:13];
    label.textColor = RGB(90, 90, 90, 1.0);
    return label;
}
- (UILabel *)introduce{
    if (_introduce) {
//        [_introduce removeFromSuperview];
        return _introduce;
    }
    
    UILabel *label = [[UILabel alloc] init];
    label.text = nameStr;
    label.font = [UIFont pingfangRegularFontWithSize:13];
    label.textColor = RGB(90, 90, 90, 1.0);
    return label;
}

- (UILabel *)sex{
    if (_sex) {
//        [_sex removeFromSuperview];
        return _sex;
    }
    
    UILabel *label = [[UILabel alloc] init];
    label.text = sexStr;
    label.font = [UIFont pingfangRegularFontWithSize:13];
    label.textColor = RGB(90, 90, 90, 1.0);
    return label;
}

- (UILabel *)nomal{
    if (_nomal) {
//        [_nomal removeFromSuperview];
        return _nomal;
    }
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"老师";
    label.font = [UIFont pingfangRegularFontWithSize:13];
    label.textColor = RGB(90, 90, 90, 1.0);
    return label;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 74.5;
    }
    else if (indexPath.row == 3){
        return 52 + 10;
    }
    else{
        return 52;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIImageView *temp = [[UIImageView alloc] init];
    temp.contentMode = UIViewContentModeScaleAspectFit;
    temp.image = [UIImage imageNamed:@"icon_mycenter_more"];
    [cell.contentView addSubview:temp];
    
    UIView *bottomline = [[UIView alloc] init];
    bottomline.backgroundColor = UIColorFromHex(0xF7F7F7);
    [cell.contentView addSubview:bottomline];
    
    if (indexPath.row == 0) {
        self.headerImage = [self headerImage];
        [self.headerImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dataDic[@"headUrl"]]] placeholderImage:PlaceholderImageView];
        
        [cell.contentView addSubview:_headerImage];
        
        [temp mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView).offset(0);
            make.right.equalTo(cell.contentView).offset(-15);
            make.bottom.equalTo(cell.contentView).offset(-scaleHeight(20));
        }];
        
        [_headerImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(temp.mas_left).offset(-5);
            make.bottom.equalTo(cell.contentView).offset(-8);
            make.width.offset(64);
            make.height.offset(64);
        }];
        
        [bottomline mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(cell.contentView).offset(0);
            make.height.offset(0.8);
        }];
    }
    else{
        [bottomline mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(cell.contentView).offset(0);
            make.height.offset(0.8);
        }];
        
        [temp mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(cell.contentView).offset(0);
            make.right.equalTo(cell.contentView).offset(-15);
        }];
        if (indexPath.row == 1) {
            self.nameLabel = [self nameLabel];
            nameStr = [NSString stringWithFormat:@"%@",dataDic[@"nickname"]];
            if ([nameStr isEqualToString:@"<null>"]) {
                self.nameLabel.text = @"";
            }else{
                self.nameLabel.text = nameStr;
            }
            [cell.contentView addSubview:_nameLabel];
            
            [_nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell.contentView).offset(0);
                make.bottom.equalTo(bottomline.mas_top).offset(0);
                make.right.equalTo(temp.mas_left).offset(-10);
            }];
            [bottomline mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.left.right.equalTo(cell.contentView).offset(0);
                make.height.offset(10);
            }];
        }
        else if (indexPath.row == 2){
            self.sex = [self sex];
            sexStr = [NSString stringWithFormat:@"%@",dataDic[@"sex"]];
            if ([sexStr isEqualToString:@"<null>"]) {
                self.sex.text = @"";
            }else{
                if ([sexStr isEqualToString:@"1"]) {
                    self.sex.text = @"男";
                }else if ([sexStr isEqualToString:@"0"]){
                    self.sex.text = @"女";
                }else{
                    self.sex.text = @"";
                }
                
            }
            [cell.contentView addSubview:_sex];
            
            [_sex mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell.contentView).offset(0);
                make.bottom.equalTo(bottomline.mas_top).offset(0);
                make.right.equalTo(temp.mas_left).offset(-10);
            }];
        }
        else if (indexPath.row == 3){
            [bottomline mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.left.right.equalTo(cell.contentView).offset(0);
                make.height.offset(0.8);
            }];
            
            self.nomal = [self nomal];
            region = [NSString stringWithFormat:@"%@",dataDic[@"region"]];
            if ([region isEqualToString:@"<null>"]) {
                self.nomal.text = @"";
                region = @"";
            }else{
                self.nomal.text = region;
            }
            _nomal.textAlignment = NSTextAlignmentRight;
            [cell.contentView addSubview:_nomal];
            [_nomal mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell.contentView).offset(0);
                make.bottom.equalTo(bottomline.mas_top).offset(0);
                make.right.equalTo(temp.mas_left).offset(-10);
                make.left.offset(60);
            }];
            
            [temp mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell.contentView).offset(0);
                make.bottom.equalTo(cell.contentView).offset(-10);
                make.right.equalTo(cell.contentView).offset(-15);
            }];
        }else if (indexPath.row == 4){
            self.introduce = [self introduce];
            introduce = [NSString stringWithFormat:@"%@",dataDic[@"introduce"]];
            if ([introduce isEqualToString:@"<null>"]) {
                self.introduce.text = @"";
                introduce = @"";
            }else{
                self.introduce.text = introduce;
            }
            _introduce.textAlignment = NSTextAlignmentRight;
            [cell.contentView addSubview:_introduce];
            [_introduce mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell.contentView).offset(0);
                make.bottom.equalTo(bottomline.mas_top).offset(0);
                make.right.equalTo(temp.mas_left).offset(-10);
                make.left.offset(60);
            }];
        }
        
    }
    
    cell.textLabel.font = [UIFont pingfangRegularFontWithSize:17];
    cell.textLabel.textColor = RGB(74, 74, 74, 1.0);
    cell.textLabel.text = @[@"头像",@"昵称",@"性别",@"地区",@"介绍"][indexPath.row];
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        [self showOptionImgTypeView];
        
    }
    else if (indexPath.row == 2){
        pickerControl *pic = [[pickerControl alloc] initWithType:0 columuns:1 WithDataSource:@[@"男",@"女"] response:^(NSString *content) {
            if (content && content.length > 0) {
                
                
                [self setSexLoadDataWithSexString:content];
            }
        }];
        [pic show];
    }else{
        LJTXPerfectInformationSettingViewController *LJTXVC = [[LJTXPerfectInformationSettingViewController alloc] init];
        LJTXVC.titleStr = @[@"头像",@"昵称",@"性别",@"地区",@"介绍"][indexPath.row];
        LJTXVC.cellInt = indexPath.row;
        if (indexPath.row == 1) {
            LJTXVC.contentStr = nameStr;
        }else if (indexPath.row == 3){
            LJTXVC.contentStr = region;
        }else if (indexPath.row == 4){
            LJTXVC.contentStr = introduce;
        }
        
        [self.navigationController pushViewController:LJTXVC animated:YES];
    }
    
}
#pragma mark - private method
- (void)imagePickerControllerWithImage:(UIImage *)image {
    if (image) {
        [SVProgressHUD show];
        [XZFHttpManager updateHeadImg:FileUploadUrl parameters:@{@"type":@"2"} postName:@"file" image:image success:^(id respondseObject) {
            NSLog(@"====图片上传====%@",respondseObject);
            
            avatarStr = [NSString stringWithFormat:@"%@",respondseObject[@"fileUrl"]];
            [self loadData];
            
            
        } failure:^(NSError *error) {
            
        }];
    }
}
- (void)setSexLoadDataWithSexString:(NSString *)sexString{
    [SVProgressHUD show];
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    NSInteger sexInt = 2;
    if ([sexString isEqualToString:@"男"]) {
        sexInt = 1;
    }else{
        sexInt = 0;
    }
    [XZFHttpManager POST:UserUpdateUrl parameters:@{@"userId":userId,@"sex":@(sexInt)} requestSerializer:NO requestToken:YES success:^(id respondseObject) {
        
        NSLog(@"----性别-----%@",respondseObject);
        
        [self loadUserInfoData];
        
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        
    }];
}

- (void)loadData{
    
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    
    [XZFHttpManager POST:UserUpdateUrl parameters:@{@"userId":userId,@"headUrl":avatarStr} requestSerializer:NO requestToken:YES success:^(id respondseObject) {
        
        NSLog(@"----头像上传-----%@",respondseObject);
        [[NSNotificationCenter defaultCenter]postNotificationName:@"MeFViewControllerUI" object:nil userInfo:nil];
        [self loadUserInfoData];
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        
    }];
}

- (void)loadUserInfoData{
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    [SVProgressHUD show];
    [XZFHttpManager GET:UserInfoUrl parameters:@{@"userId":userId} requestSerializer:NO requestToken:YES success:^(id respondseObject) {
        NSLog(@"--------获取个人信息--------%@",respondseObject);
        dataDic = respondseObject[@"userInfo"];
        
        [self.tableView reloadData];
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        
        
    }];
}





@end
