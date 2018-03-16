//
//  CollectionLayout.m
//  Waterfalls
//
//  Created by 郭艾超 on 16/9/26.
//  Copyright © 2016年 Steven. All rights reserved.
//

#import "CollectionLayout.h"
@interface CollectionLayout()
@property (assign, nonatomic) NSInteger columnNum;
@property (assign, nonatomic) CGFloat rowSpacing;
@property (assign, nonatomic) CGFloat columnSpacing;
@property (assign, nonatomic) UIEdgeInsets sectionInset;
@property (strong, nonatomic) NSMutableDictionary * everyColumnHDict;
@property (strong, nonatomic) NSMutableArray * attributeArr;
@end

@implementation CollectionLayout
- (instancetype)initOptionWithColumnNum:(NSInteger)columnNum rowSpacing:(CGFloat)rowSpacing columnSpacing:(CGFloat)columnSpacing sectionInset:(UIEdgeInsets)sectionInset {
    if (self = [super init]) {
        _columnNum = columnNum;
        _rowSpacing = rowSpacing;
        _columnSpacing = columnSpacing;
        _sectionInset = sectionInset;
        _everyColumnHDict = [NSMutableDictionary dictionary];
        _attributeArr = [NSMutableArray array];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(CollectionLayoutNotification:) name:@"CollectionLayoutNotification" object:nil];
    }
    return self;
}
- (void)CollectionLayoutNotification:(NSNotification *)notification{
    _everyColumnHDict = [NSMutableDictionary dictionary];
    _attributeArr = [NSMutableArray array];
}
- (CGFloat)calculateImageHeightWithCount:(NSInteger)i withWidth:(CGFloat)width {
    NSString * titleName = _titleDataArr[i];
    NSString * contentName = _titleDataArr[i];
//    UIImage * image = [UIImage imageNamed:imageName];
//    CGFloat imageH = image.size.height / image.size.width * width;
    CGFloat THeight = [self calculateTitleHeight:titleName];
    CGFloat CHeight = [self calculateContentHeight:contentName];

//    NSLog(@"%f",height);
    
    return THeight +CHeight + 140;
}

#pragma mark - 重写CollectionView方法
- (void)prepareLayout {
    [super prepareLayout];
    for (int i = 0; i < _columnNum; i++) {
        [_everyColumnHDict setObject:@(_sectionInset.top) forKey:[NSString stringWithFormat:@"%d",i]];
    }
    
    for (int i = 0; i < _titleDataArr.count; i++) {
        [_attributeArr addObject:[self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]]];
    }
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes * attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    //计算宽度(等宽)
    CGFloat itemW = (self.collectionView.bounds.size.width - _sectionInset.left - _sectionInset.right - (_columnNum - 1) * _rowSpacing) / _columnNum;
    
    NSString * titleName = _titleDataArr[indexPath.row];
    NSString * contentName = _contentDataArr[indexPath.row];
    CGFloat titleHeight = [self calculateTitleHeight:titleName];
    CGFloat contentHeight = [self calculateContentHeight:contentName];
    NSLog(@"-----titleHeight=-%f ----contentHeight=-%f",titleHeight,contentHeight);
    
    CGFloat itemH = titleHeight + contentHeight + 140;
//    CGFloat itemH = [self calculateImageHeightWithCount:indexPath.row withWidth:itemW];
    
    CGRect frame = CGRectMake(0, 0, itemW, itemH);
    
    NSInteger x = 0;
    CGFloat y = 0.0f;
    for (id temKey in _everyColumnHDict) {
        CGFloat temHeight = [_everyColumnHDict[temKey] floatValue];
        if (y == 0) {
            y = temHeight;
            x = [temKey integerValue];
            continue;
        }
        
        if(y > temHeight ) {
            y = temHeight;
            x = [temKey integerValue];
        }
    }
    frame.origin = CGPointMake(_sectionInset.left + x * (itemW + _rowSpacing), y);
    NSString * key = [NSString stringWithFormat:@"%ld",x];
    NSNumber * height = @(_columnSpacing + y + itemH);
    [_everyColumnHDict setObject:height forKey:key];

    attribute.frame = frame;
    return attribute;
}

- (CGSize)collectionViewContentSize {    
    CGFloat height = 0.0f;
    for (id key in _everyColumnHDict) {
        CGFloat temHeight = [_everyColumnHDict[key] floatValue];
        height = height > temHeight ? height : temHeight;
    }
    return CGSizeMake(self.collectionView.frame.size.width, height + _sectionInset.bottom);
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return _attributeArr;
}

- (CGFloat)calculateTitleHeight:(NSString *)String{
    CGSize size = [NSString stringLengthWithAttrStr:String width:(self.collectionView.bounds.size.width - _sectionInset.left - _sectionInset.right - (_columnNum - 1) * _rowSpacing) / _columnNum - 12 font:16 lineSpace:2];
    return size.height;
}
- (CGFloat)calculateContentHeight:(NSString *)String{
    CGSize size = [NSString stringLengthWithAttrStr:String width:(self.collectionView.bounds.size.width - _sectionInset.left - _sectionInset.right - (_columnNum - 1) * _rowSpacing) / _columnNum - 12 font:14 lineSpace:2];
    return size.height;
}
//移除通知
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}

@end
