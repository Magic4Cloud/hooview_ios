//
//  ShareView.m
//  Education
//
//  Created by JN on 16/7/11.
//  Copyright © 2016年 CD. All rights reserved.
//

#import "ShareView.h"
//#import "FlexibleFrame.h"
#import "ShareItemModel.h"
#import "ShareItemCollectionViewCell.h"


@interface ShareView() <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *shareDataSource;

@end
static NSString *cellId = @"ShareItemCollectionViewCell";
@implementation ShareView

- (NSArray *)shareDataSource {

    if (!_shareDataSource) {
        
        _shareDataSource = [ShareItemModel shareItemList];
    }
    return _shareDataSource;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = RGB(1, 1, 1, 0.3);

        //白色底
        UIView *bgView = [[UIView alloc]init];
        bgView.backgroundColor = UIColorFromHex(0xF9F9F9);
        [self addSubview:bgView];
        
//        [bgView makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.bottom.equalTo(self);
//            make.height.equalTo(180);
//        }];
        
//        [bgView makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.bottom.equalTo(self);
//            make.height.equalTo(186);
//        }];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.mas_equalTo(186);
        }];
        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];
        
        //分享选项
        UICollectionViewFlowLayout *flayout = [UICollectionViewFlowLayout new];
        flayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 120) collectionViewLayout:flayout];
        self.collectionView.contentSize = CGSizeMake(WIDTH/4, 119);
        self.collectionView.showsHorizontalScrollIndicator = NO;
        self.collectionView.alwaysBounceHorizontal = YES;
        self.collectionView.directionalLockEnabled = YES;
        self.collectionView.backgroundColor = [UIColor whiteColor];
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        [self.collectionView registerNib:[UINib nibWithNibName:@"ShareItemCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:cellId];
        [bgView addSubview:self.collectionView];
        
        //取消按钮
        self.closeButton = ({
            
            UIButton *button = [[UIButton alloc]init];
            button.backgroundColor = [UIColor whiteColor];
            [button setTitle:@"取消" forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:20];
            [button setTitleColor:UIColorFromHex(0x5C5C5C) forState:UIControlStateNormal];
            [button addTarget:self action:@selector(closeButton_share) forControlEvents:UIControlEventTouchUpInside];
            [bgView addSubview:button];
            button;
        });

        [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(bgView);
            make.height.offset(56);
        }];
        
        bgView.transform = CGAffineTransformMakeTranslation(0, 180);
        [UIView animateWithDuration:0.25 animations:^{
            
            bgView.transform = CGAffineTransformIdentity;
        }];
    }
    return self;
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
//设置每个cell的宽和高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return CGSizeMake(WIDTH/4 - 8, 118);
}
//设置间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(1 , 1, 1, 1);
}


////设置最小行间距（默认是10）
////如果collectionView纵向滚动，行间距只能通过设置最小行间距来确定
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
//    
//    return 0;
//    
//}

//设置最小列间距（默认是10）
//如果collectionView横向滚动，列间距只能通过设置最小列间距来确定
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    
    return 0;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.shareDataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ShareItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.shareItemModel = self.shareDataSource[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
//    UMSocialPlatformType platformType = [[self.shareDataSource[indexPath.row] valueForKey:@"itemShareType"] integerValue];
    [self.delegate shareButtonWithUMShareType:indexPath.row];
    
    [self removeFromSuperview];
}


#pragma mark - button methods
//关闭分享框
- (void)closeButton_share
{
    [self removeFromSuperview];
}

@end
