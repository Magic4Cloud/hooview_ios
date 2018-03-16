//
//  SLShowPhotoViewController.m
//  Education
//
//  Created by shilei on 16/11/7.
//  Copyright © 2016年 CD. All rights reserved.
//

#import "SLShowPhotoViewController.h"
  

@interface SLShowPhotoViewController ()<UIScrollViewDelegate,UIActionSheetDelegate>{
    NSInteger numberPhoto;//图片下标
    NSInteger numberPhotoImage;//当前图片下标
    UILabel *numberLab;//点赞数
    UIButton *rightPraiseB;//点赞按钮
    NSString *photoId;//照片ID
    NSString *YesOrNo;//是否选择0：选择，1：未选
    UILabel *pageNumberLab;//点赞数

}
//照片数据数组
@property (nonatomic,strong)NSMutableArray      *imageNames;
@property (nonatomic,strong)UIScrollView        *scrollView;
//滚动界面进入时界面下标
@property (nonatomic,assign)NSInteger           currentIndex;
//图片界面数组
@property (nonatomic,strong)NSMutableArray      *contentViews;
//点赞是否选中状态
@property (assign,nonatomic)BOOL selectState;//
//选择状态数组
@property (nonatomic,strong)NSMutableArray      *YesOrNoArr;
@property (strong,nonatomic) UIActionSheet *sheet;

@property (nonatomic,strong)UILabel      *titleLab;
@property (nonatomic,strong)UITextView      *descView;

@property (nonatomic,strong)NSMutableArray      *descArr;


@end

@implementation SLShowPhotoViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromHex(0xd1d8e0);
//    [self createNav];//导航
    
    
    //数据
    _imageNames = [NSMutableArray array];
    _contentViews = [NSMutableArray array];
    _YesOrNoArr = [NSMutableArray array];
    _descArr = [NSMutableArray array];

    //照片数组赋值
    if (_type == 1) {
        for (int i = 0; i<[self.photoArray count]; i++) {
            [_imageNames addObject:self.photoArray[i][@"url"]];
            [_descArr addObject:self.photoArray[i][@"title"]];
        }
    }else{
        for (int i = 0; i<[self.photoArray count]; i++) {
            [_imageNames addObject:self.photoArray[i]];
        }
    }

    //进入时默认显示的图片（下标）
    _currentIndex = self.selectIndex;
    pageNumberLab.text = [NSString stringWithFormat:@"%ld/%ld",_currentIndex + 1,_imageNames.count];

    //界面
    //关闭自适应
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    _scrollView.backgroundColor = UIColorFromHex(0x000000);
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.bounds)*3, CGRectGetHeight(self.scrollView.bounds));
    _scrollView.pagingEnabled = YES;
    //设置代理
    _scrollView.delegate = self;
    
    //偏移量
    _scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.scrollView.bounds), 0);
    for (int i = 0; i<3; i++) {
        NSInteger index = [self indexWithCurrentIndex:_currentIndex+i-1 totalCount:_imageNames.count];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.scrollView.bounds)*i, 0, CGRectGetWidth(self.scrollView.bounds), CGRectGetHeight(self.scrollView.bounds))];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.imageNames[index]]];
        
        numberPhoto = index;
        numberPhotoImage = index;
        //**************************进入时赋值***************************
        //进入时判断是否为最后一张，最后一张图片下标为0需改变为图片张数-1，其他图片为进入时的下标-1；
        if (numberPhoto == 0) {
            numberPhotoImage = _imageNames.count - 1;
            photoId = [NSString stringWithFormat:@"%@",self.showPhotoIdArr[numberPhotoImage]];
            YesOrNo = [NSString stringWithFormat:@"%@",self.showStateArr[numberPhotoImage]];
            numberLab.text = [NSString stringWithFormat:@"%@",self.showNumberArr[numberPhotoImage]];
            if ([YesOrNo isEqualToString:@"0"]) {
                rightPraiseB.selected = YES;
            }else if ([YesOrNo isEqualToString:@"1"]){
                rightPraiseB.selected = NO;
            }else{
                rightPraiseB.selected = NO;
            }
        }else{
            numberPhotoImage = numberPhoto - 1;
            photoId = [NSString stringWithFormat:@"%@",self.showPhotoIdArr[numberPhotoImage]];
            YesOrNo = [NSString stringWithFormat:@"%@",self.showStateArr[numberPhotoImage]];
            numberLab.text = [NSString stringWithFormat:@"%@",self.showNumberArr[numberPhotoImage]];
            NSLog(@"图片点赞数---%@",numberLab.text);
            NSLog(@"图片是否点赞---%@",YesOrNo);
            
            if ([YesOrNo isEqualToString:@"0"]) {
                rightPraiseB.selected = YES;
            }else if ([YesOrNo isEqualToString:@"1"]){
                rightPraiseB.selected = NO;
            }else{
                rightPraiseB.selected = NO;
            }
            
        }

        [self.scrollView addSubview:imageView];
        [self.contentViews addObject:imageView];
    }
    
    [self.view addSubview:_scrollView];
//    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGesture:)];
//    [self.view addGestureRecognizer:longGesture];
    
    UIButton *backmainButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 25, 42, 52)];
    [backmainButton setImage:[UIImage imageNamed:@"return_white"] forState:UIControlStateNormal];
    [backmainButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backmainButton];
    
    if (self.interfaceType == 1) {
        UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT - 120, WIDTH, 120)];
        bgView.backgroundColor = RGB(0, 0, 0, 0.2);
        [self.view addSubview:bgView];
        
        _descView = [[UITextView alloc]initWithFrame:CGRectMake(15, HEIGHT - 120, WIDTH - 30, 100)];
        _descView.backgroundColor = [UIColor clearColor];
        _descView.text = [NSString stringWithFormat:@"%@",_descArr[_selectIndex]];
        _descView.textColor = [UIColor whiteColor];
        _descView.editable = NO;
        _descView.font = [UIFont pingfangFontWithSize:13];
        [self.view addSubview:_descView];
        
        
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH - 62, HEIGHT-20, 62, 13)];
        lab.text = [NSString stringWithFormat:@"/%ld",self.photoArray.count];
        lab.textAlignment = NSTextAlignmentLeft;
        lab.font = [UIFont pingfangFontWithSize:13];
        lab.textColor = UIColorFromHex(0xffffff);
        [self.view addSubview:lab];
        
        self.titleLab = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH - 80 - 62, HEIGHT-22, 80, 16)];
        _titleLab.font = [UIFont pingfangFontWithSize:16];
        _titleLab.text = [NSString stringWithFormat:@"%ld",_selectIndex + 1];
        _titleLab.textAlignment = NSTextAlignmentRight;
        _titleLab.textColor = [UIColor whiteColor];
        _titleLab.textColor = UIColorFromHex(0xffffff);
        
        [self.view addSubview:self.titleLab];
    }else{
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH - 62, HEIGHT-53, 62, 13)];
        lab.text = [NSString stringWithFormat:@"/%ld",self.photoArray.count];
        lab.textAlignment = NSTextAlignmentLeft;
        lab.font = [UIFont pingfangFontWithSize:13];
        lab.textColor = UIColorFromHex(0xffffff);
        [self.view addSubview:lab];
        
        self.titleLab = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH - 80 - 62, HEIGHT-55, 80, 16)];
        _titleLab.font = [UIFont pingfangFontWithSize:16];
        _titleLab.text = [NSString stringWithFormat:@"%ld",_selectIndex + 1];
        _titleLab.textAlignment = NSTextAlignmentRight;
        _titleLab.textColor = [UIColor whiteColor];
        _titleLab.textColor = UIColorFromHex(0xffffff);
        
        [self.view addSubview:self.titleLab];
    }
    


}


#pragma mark - <UIScrollView>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"%@",NSStringFromSelector(_cmd));
    [self updateScrollView:scrollView];
}

#pragma mark - Method
- (void)updateScrollView:(UIScrollView *)scrollView {
    BOOL shouldUpdate = NO;
    //小于第一张图片最左边（左滑）
    if (scrollView.contentOffset.x <= 0) {
        _currentIndex = [self indexWithCurrentIndex:_currentIndex-1 totalCount:_imageNames.count];
        shouldUpdate = YES;
    }
    //大于最后一张图片最右边（右滑）
    else if (scrollView.contentOffset.x >= CGRectGetWidth(self.scrollView.bounds)*2) {
        _currentIndex = [self indexWithCurrentIndex:_currentIndex+1 totalCount:_imageNames.count];
        shouldUpdate = YES;
    }
    
    if (!shouldUpdate) {
        return;
    }
    
    for (int i=0; i<3; i++) {
        NSInteger index = [self indexWithCurrentIndex:_currentIndex+i-1 totalCount:_imageNames.count];
        
        UIImageView *imageView = (UIImageView *)_contentViews[i];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        NSLog(@"-----****currentIndex*****-------%ld",_currentIndex);
        
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        NSString* key = [manager cacheKeyForURL:[NSURL URLWithString:self.imageNames[index]]];
        SDImageCache* cache = [SDImageCache sharedImageCache];
        //此方法会先从memory中取。
        if (![cache imageFromDiskCacheForKey:key]) {
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:self.imageNames[index]] placeholderImage:[UIImage imageNamed:@"homeland_img_loading"]];
        } else {
            
            imageView.image = [cache imageFromDiskCacheForKey:key];
        }

//        [imageView sd_setImageWithURL:[NSURL URLWithString:self.imageNames[index]]];
        
        NSLog(@"-----*********-------%ld",index);
        numberPhoto = index;
    }
    
    if (numberPhoto == 0) {
        pageNumberLab.text = [NSString stringWithFormat:@"%ld/%ld",_imageNames.count,_imageNames.count];
        numberPhotoImage = _imageNames.count - 1;
        photoId = [NSString stringWithFormat:@"%@",self.showPhotoIdArr[numberPhotoImage]];
        YesOrNo = [NSString stringWithFormat:@"%@",self.showStateArr[numberPhotoImage]];
        numberLab.text = [NSString stringWithFormat:@"%@",self.showNumberArr[numberPhotoImage]];
        
        if ([YesOrNo isEqualToString:@"0"]) {
            rightPraiseB.selected = YES;
        }else if ([YesOrNo isEqualToString:@"1"]){
            rightPraiseB.selected = NO;
        }else{
            rightPraiseB.selected = NO;
        }
        
        
    }else{
//        [MBProgressHUD showWithView:self.view WithText:[NSString stringWithFormat:@"这是第 %ld 张图",numberPhoto] afterDelay:0.5];
        pageNumberLab.text = [NSString stringWithFormat:@"%ld/%ld",numberPhoto,_imageNames.count];
        numberPhotoImage = numberPhoto - 1;
        photoId = [NSString stringWithFormat:@"%@",self.showPhotoIdArr[numberPhotoImage]];
        YesOrNo = [NSString stringWithFormat:@"%@",self.showStateArr[numberPhotoImage]];
        numberLab.text = [NSString stringWithFormat:@"%@",self.showNumberArr[numberPhotoImage]];

        if ([YesOrNo isEqualToString:@"0"]) {
            rightPraiseB.selected = YES;
        }else if ([YesOrNo isEqualToString:@"1"]){
            rightPraiseB.selected = NO;
        }else{
            rightPraiseB.selected = NO;
        }
        
    }
    
    //复位
    [self.scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.scrollView.bounds), 0)];
}



- (NSInteger)indexWithCurrentIndex:(NSInteger)currentIndex totalCount:(NSInteger)totalCount {
    if (currentIndex < 0) {
        currentIndex = totalCount-1;
    }
    if (currentIndex >totalCount-1) {
        currentIndex = 0;
    }
    _titleLab.text = [NSString stringWithFormat:@"%ld",_currentIndex + 1];
//    _descView.text = [NSString stringWithFormat:@"%@",_descArr[_currentIndex]];
    return currentIndex;
    
    
}
- (void)done{
    
}

- (void)longGesture:(UILongPressGestureRecognizer *)gesture{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        if (!self.sheet) {
            self.sheet = [[UIActionSheet alloc] initWithTitle:@"提示" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"保存到相册" otherButtonTitles:nil, nil];
        }
        
        [self.sheet showInView:self.view];
    }
}
- (void)backButtonAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}
//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(long)buttonIndex{
//    if (buttonIndex == 0){
//        
//        UIImageView *saveImageView = _contentViews[1];
//        if([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
//            UIImageWriteToSavedPhotosAlbum(saveImageView.image, nil, nil, nil);
//            
//            if (saveImageView.image) {
//                
//                [MBProgressHUD showWithView:self.view WithText:@"保存成功" afterDelay:1];
//            } else {
//                
//                [MBProgressHUD showWithView:self.view WithText:@"保存失败" afterDelay:1];
//            }
//        } else {
//            
//            [MBProgressHUD showWithView:self.view WithText:@"保存失败" afterDelay:1];
//        }
//    }
//}
@end
