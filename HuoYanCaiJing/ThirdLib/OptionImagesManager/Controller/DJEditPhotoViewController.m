//
//  DJEditPhotoViewController.m
//  DangJian
//
//  Created by uwant on 16/11/5.
//  Copyright © 2016年 luojing. All rights reserved.
//

#import "DJEditPhotoViewController.h"
#import "DJEditPictureViewModel.h"
#define UIColorFromHex(s) [UIColor colorWithRed:(((s & 0xFF0000) >> 16)) / 255.0 green:(((s &0xFF00) >> 8))/255.0 blue:((s &0xFF))/255.0 alpha:1.0]
@interface DJEditPhotoViewController ()<DJEditPictrueDelegate>

@property (nonatomic, strong) DJEditPictureViewModel *model;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, assign) NSInteger index;

@end

@implementation DJEditPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.index = self.currentIndex;
    [self setupNavigationBar];
    self.view.backgroundColor = [UIColor whiteColor];
    if (self.hiddenDelete) {
        
    }else {
        [self setupRightNavigationBarWithTitle:@"删除"];
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.index inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
    UIView *navigationBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    navigationBarView.backgroundColor = UIColorFromHex(0x000000);
//    navigationBarView.alpha = 0.6;
    [self.view addSubview:navigationBarView];
    
    [self.view addSubview:self.collectionView];

    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 35, WIDTH - 100, 15)];
    self.titleLabel.text = [NSString stringWithFormat:@"%lu/%lu",self.currentIndex + 1,self.images.count];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.textColor = UIColorFromHex(0xffffff);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.titleLabel];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backSetKeyboardHide:)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
}
-(void)backSetKeyboardHide:(UITapGestureRecognizer*)tap{
    [self dismissViewControllerAnimated:YES completion:nil];
}

///**添加导航栏左边按钮*/
//- (void)setupNavigationBar {
//    
//    self.navigationController.navigationBarHidden = NO;
//    
//    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    leftButton.frame = CGRectMake(0, 0, 23/2, 38/2);
//    leftButton.backgroundColor = [UIColor clearColor];
//    [leftButton setImage:[UIImage imageNamed:@"houtui"] forState:UIControlStateNormal];
//    [leftButton addTarget:self action:@selector(leftButtonClicked) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
//}

- (void)leftButtonClicked {
    [self .navigationController popViewControllerAnimated:YES];
}

/**添加导航栏右边边按钮*/
- (void)setupRightNavigationBarWithTitle:(NSString *)title {
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 40, WIDTH-15);
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    rightBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [rightBtn setTitle:title forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(delete) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
}

#pragma mark 删除
- (void) delete {
    if (self.model.dataSource.count > 1) {
        [self.model.dataSource removeObjectAtIndex:self.index];
    }else {
        if (self.model.dataSource.count) {
            [self.model.dataSource removeObjectAtIndex:self.index];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    if (self.deleteDelegate && [self.deleteDelegate respondsToSelector:@selector(deleteImageupdataCellWithIndex:)]) {
        [self.deleteDelegate deleteImageupdataCellWithIndex:self.index];
    }
    if (self.index > self.model.dataSource.count - 1) {
        //在最后
          self.navigationItem.title = [NSString stringWithFormat:@"%lu/%lu",self.index,self.images.count];
        self.index -= 1;
    }else {
        
        self.navigationItem.title = [NSString stringWithFormat:@"%lu/%lu",self.index + 1,self.images.count];
    }
    [self.collectionView reloadData];
}

#pragma mark 懒加载
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64);
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64) collectionViewLayout:flowLayout];
        [_collectionView registerClass:[DJEditPictureCell class] forCellWithReuseIdentifier:@"DJEditPictureCell"];
        _collectionView.pagingEnabled = YES;
        _collectionView.delegate = self.model;
        _collectionView.dataSource = self.model;
    }
    return _collectionView;
}

- (DJEditPictureViewModel *)model {
    if (!_model) {
        _model = [DJEditPictureViewModel model];
        _model.dataSource = self.images;
        _model.editDelegte = self;
    }
    return _model;
}
#pragma mark DJEditPictrueDelegate
- (void)contentPictrueForIndex:(NSInteger)index {
    self.titleLabel.text = [NSString stringWithFormat:@"%lu/%lu",index + 1,self.images.count];
    self.index = index;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
