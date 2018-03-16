//
//  BottomRecommView.m
//  XueZhiFei
//
//  Created by apple on 2017/11/9.
//  Copyright © 2017年 ZPF Mac Pro. All rights reserved.
//

#import "BottomRecommView.h"

@interface BottomRecommView ()

//@property (strong,nonatomic) UIButton *rightImage;
@property (strong,nonatomic) UIButton *send;

@end

@implementation BottomRecommView

- (instancetype)init{
    self = [super init];
    if (self) {
        
        self.backgroundColor = RGB(242, 244, 245, 1.0);
        
//        self.rightImage = [self rightImage];
        self.send = [self send];
        self.textFiled = [self textFiled];
        
//        [self addSubview:_rightImage];
        [self addSubview:_send];
        [self addSubview:_textFiled];
        
//        [_rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.bottom.left.equalTo(self).offset(0);
//            make.width.offset(50);
//        }];
        [_send mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(10);
            make.bottom.right.equalTo(self).offset(-10);
            make.width.offset(50);
        }];
        
        [_textFiled mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(9);
            make.bottom.equalTo(self).offset(-9);
            make.left.equalTo(self).offset(13);
            make.right.equalTo(self).offset(-70);
        }];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = RGB(230, 230, 230, 1.0);
        [self addSubview:line];
        [line mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(0);
            make.left.equalTo(self).offset(0);
            make.right.equalTo(self).offset(0);
            make.height.offset(0.5);
        }];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(EmptyTextFiledNotification:) name:@"EmptyTextFiledNotification" object:nil];
    }
    return self;
}
- (void)EmptyTextFiledNotification:(NSNotification *)notification{
    _textFiled.text = @"";
}
//- (UIButton *)rightImage{
//    if (_rightImage) {
//        return _rightImage;
//    }
//    UIButton *button = [[UIButton alloc] init];
//    [button setImage:[UIImage imageNamed:@"icon_news_detail_back"] forState:UIControlStateNormal];
//    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
//    return button;
//}

- (UITextField *)textFiled{
    if (_textFiled) {
        return _textFiled;
    }
    
    UITextField *text = [[UITextField alloc] init];
    text.font = [UIFont pingfangRegularFontWithSize:13];
    text.placeholder = @"请输入评论内容";
    text.layer.cornerRadius = 16;
    text.clipsToBounds = YES;
    text.backgroundColor = [UIColor whiteColor];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 5)];
    text.leftView = view;
    text.leftViewMode = UITextFieldViewModeAlways;
    return text;
}

- (UIButton *)send{
    if (_send) {
        return _send;
    }
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:@"发送" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor = UIColorFromHex(0xFB1414);
    button.titleLabel.font = [UIFont pingfangRegularFontWithSize:14];
    button.layer.cornerRadius = 15;
    [button addTarget:self action:@selector(bottomSenderPressed) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)bottomSenderPressed{
    if (_textFiled.text.length  == 0) {
        [SVProgressHUD setMinimumDismissTimeInterval:1];
        [SVProgressHUD showErrorWithStatus:@"请输入评论内容"];
        return;
    }
    
    [_textFiled resignFirstResponder];
    
    [self senButtonPressedWith:_textFiled.text];
}
- (void)beginInput{
    [_textFiled becomeFirstResponder];
}
- (void)endInput{
    [_textFiled resignFirstResponder];
}

- (void)setNormalPlaceHold:(NSString *)normalPlaceHold{
    _normalPlaceHold = normalPlaceHold;
    if (_normalPlaceHold) {
        _textFiled.attributedPlaceholder = nil;
        _textFiled.placeholder = _normalPlaceHold;
    }
}

- (void)setAttriedPlaceHold:(NSAttributedString *)attriedPlaceHold{
    _attriedPlaceHold = attriedPlaceHold;
    if (_attriedPlaceHold) {
        _textFiled.placeholder = nil;
        _textFiled.attributedPlaceholder = _attriedPlaceHold;
    }
}

- (void)senButtonPressedWith:(NSString *)content{
    [_delegate senButtonPressedWith:content];
}
//移除通知
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}
@end
