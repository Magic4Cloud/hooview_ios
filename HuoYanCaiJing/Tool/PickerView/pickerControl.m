//
//  pickerControl.m
//  Education
//
//  Created by shilei on 16/7/19.
//  Copyright © 2016年 CD. All rights reserved.
//
#import "pickerControl.h"
#import "AppDelegate.h"
@interface pickerControl () <UIPickerViewDataSource,UIPickerViewDelegate>{
    NSArray *dataSource;
    UIView *contentView;
    void(^backBlock)(NSString *);
    NSString *restr;
    NSInteger columns;
    NSArray *columns_two_dataSource;
}

@end
@implementation pickerControl

- (instancetype)initWithType:(NSInteger)type columuns:(NSInteger)col WithDataSource:(NSArray *)sources response:(void (^)(NSString *))block {
    if (self = [super init]) {
        columns = col;
        self.frame = [UIScreen mainScreen].bounds;
        [self setViewInterface];
        if (block) {
            backBlock = block;
        }
        if (sources) {
            dataSource = [sources copy];
        }
        if (type == 0) {
            [self pickerView];
        }else {
            [self dataPicker];
        }
        
        
    }
    return self;
}
#pragma mark View初始配置
- (void)setViewInterface {
    contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 241)];
    [self addSubview:contentView];
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];//设置背景颜色为黑色，并有0.4的透明度
    //添加白色view
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 44)];
    whiteView.backgroundColor = UIColorFromHex(0xF9F9F9);
    [contentView addSubview:whiteView];
    //添加确定和取消按钮
    for (int i = 0; i < 2; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((self.frame.size.width - 60) * i, 7, 60, 30)];
        [button setTitle:i == 0 ? @"取消" : @"确认" forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromHex(0x5C5C5C) forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [whiteView addSubview:button];
        [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 10 + i;
    }
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((self.frame.size.width - 100)/2, 20, 100, 16)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = UIColorFromHex(0x2EA2FD);
    _titleLabel.font = [UIFont systemFontOfSize:16];
    
    [whiteView addSubview:self.titleLabel];
    
    
}
- (void)buttonTapped:(UIButton *)sender {
    if (sender.tag == 10) {
        [self dismiss];
    }else {
        backBlock(restr);
        [self dismiss];
    }
}
#pragma mark dataPicker
- (void)dataPicker{
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 44, CGRectGetWidth(self.bounds), 197)];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.backgroundColor = [UIColor colorWithRed:255.0/255 green:255.0/255 blue:255.0/255 alpha:1];
    [datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY/MM/dd HH:mm:ss"];
    
    NSString *pickerViewType = [[NSUserDefaults standardUserDefaults] objectForKey:@"pickerViewType"];

//    if ([pickerViewType isEqualToString:@"1"]) {
//        
//    }else{
//        datePicker.maximumDate = currentDate;
//    }
    [contentView addSubview:datePicker];
    //判断是选择生日还是选择查询时间
    NSString *pageStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"InformationPage"];
    NSString *BtimeStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"PersonalBirthdayTime"];
    NSLog(@"====%@",BtimeStr);
    
    if ([pageStr isEqualToString:@"1"]) {
        //判断birthday字段是否为空，为空则默认为当前的时间
        if (BtimeStr.length == 0) {
            restr = [self changeToStringWithDate:[NSDate date]];//给一个最初值防止没滑动就直接确定
        }else{
            NSDateFormatter *dateFormatterOne = [[NSDateFormatter alloc]init];
            [dateFormatterOne setDateFormat:@"yyyy-MM-dd"];
            //生日
            NSDate *birthDay = [dateFormatterOne dateFromString:[NSString stringWithFormat:@"%@", BtimeStr]];
            [datePicker setDate:birthDay];
            restr = [self changeToStringWithDate:birthDay];//给一个最初值防止没滑动就直接确定
        }
        
    }else{
        restr = [self changeToStringWithDate:[NSDate date]];//给一个最初值防止没滑动就直接确定
    }
}
#pragma mark date 值改变方法
- (void)dateChange:(UIDatePicker *)datePicker {
    restr = [self changeToStringWithDate:datePicker.date];
}
- (NSString *)changeToStringWithDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter stringFromDate:date];
}
#pragma mark pickerView
- (void)pickerView {
    for (id obj in dataSource) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            columns_two_dataSource = [dataSource[0] allValues][0];
            restr = columns_two_dataSource[0];
        }else{
            restr = dataSource[0];
        }
        break;
    }
    
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, CGRectGetWidth(self.bounds), 197)];
    pickerView.delegate = self;
    pickerView.dataSource = self;
//    pickerView.backgroundColor = [UIColor colorWithRed:240.0/255 green:243.0/255 blue:250.0/255 alpha:1];
    pickerView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:pickerView];
}
#pragma mark 出现
- (void)show {
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.window addSubview:self];
    [UIView animateWithDuration:0.4 animations:^{
        contentView.center = CGPointMake(self.frame.size.width/2, contentView.center.y - contentView.frame.size.height);
    }];
}
#pragma mark 消失
- (void)dismiss{
    
    [UIView animateWithDuration:0.4 animations:^{
        contentView.center = CGPointMake(self.frame.size.width/2, contentView.center.y + contentView.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
#pragma mark UIPickerViewDataSource UIPickerViewDelegate
//返回有多少列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return columns;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return dataSource.count;
    }
    else {
        return columns_two_dataSource.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        if (columns_two_dataSource) {
            NSDictionary *dic = dataSource[row];
            NSArray *array = dic.allKeys;
            NSString *str1 = array[0];
            NSLog(@"*********%@",str1);
            [[NSUserDefaults standardUserDefaults] setObject:str1 forKey:@"abbreviations"];
            return [dataSource[row]allKeys][0];
        }else{
            return dataSource[row];
        }
        
    }else {
        return columns_two_dataSource[row];
    }
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        if (columns_two_dataSource) {
            columns_two_dataSource = [dataSource[row] allValues][0];
            restr = columns_two_dataSource[0];
            [pickerView reloadComponent:1];
        }else{
            restr = dataSource[row];
        }
        
    }else {
        restr = columns_two_dataSource[row];
    }
}
//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
//{
//    //设置分割线的颜色
//    for(UIView *singleLine in pickerView.subviews)
//    {
//        if (singleLine.frame.size.height < 1)
//        {
//            singleLine.backgroundColor = UIColorFromHex(0xe7e7e7);
//        }
//    }
//    //设置文字的属性
//    UILabel *genderLabel = [UILabel new];
//    genderLabel.textAlignment = NSTextAlignmentCenter;
//    genderLabel.font = [UIFont systemFontOfSize:16];
//    genderLabel.text = dataSource[row];//self.genderArray里边内容为@[@"男",@"女"]
//    genderLabel.textColor = UIColorFromHex(0x333333);
//    
//    return genderLabel;
//}

@end
