//
//  ZJWaterFlowLayout.m
//  0829-瀑布流
//
//  Created by 张健 on 15/8/29.
//  Copyright (c) 2015年 张健. All rights reserved.
//

#import "ZJWaterFlowLayout.h"

@interface ZJWaterFlowLayout ()
/** 存放每列最大y值 */
@property (nonatomic, strong) NSMutableDictionary *maxYDict;
/** 存放所有item属性 */
@property (nonatomic, strong) NSMutableArray *attrsArray;
@end

@implementation ZJWaterFlowLayout
- (NSMutableDictionary *)maxYDict{
    if (_maxYDict == nil) {
        _maxYDict = [NSMutableDictionary dictionary];
    }
    return _maxYDict;
}

- (NSMutableArray *)attrsArray{
    if (_attrsArray == nil) {
        _attrsArray = [NSMutableArray array];
    }
    return _attrsArray;
}

- (instancetype)init{
    if (self = [super init]) {
        self.listCount = 3;
        self.lineMargin = 10;
        self.listMargin = 10;
        self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    }
    return self;
}

- (void)prepareLayout{
    [super prepareLayout];
    // 还原，清空最大Y值
    for (int i = 0; i < self.listCount; i++) {
        NSString *list = [NSString stringWithFormat:@"%d",i];
        self.maxYDict[list] = @(self.sectionInset.top);
    }
    
    // 获取所有属性
    [self.attrsArray removeAllObjects];
    int count = (int)[self.collectionView numberOfItemsInSection:0];
    for (int i = 0; i < count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attrsArray addObject:attr];
    }
    
}

// 计算contentSize
- (CGSize)collectionViewContentSize{
    __block NSString *maxList = @"0";
    [self.maxYDict enumerateKeysAndObjectsUsingBlock:^(NSString *list, NSNumber *maxY, BOOL *stop) {
        if ([maxY floatValue] > [self.maxYDict[maxList] floatValue]) {
            maxList = list;
        }
    }];
    return CGSizeMake(0, [self.maxYDict[maxList] floatValue] +self.sectionInset.bottom);
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    // 查找Y值最小的列
    __block NSString *minList = @"0";
    [self.maxYDict enumerateKeysAndObjectsUsingBlock:^(NSString *list, NSNumber *maxY, BOOL *stop) {
        if ([maxY floatValue] < [self.maxYDict[minList] floatValue]) {
            minList = list;
        }
    }];
    
    // 计算放在Y最小列的cell的frame
    CGFloat width = (self.collectionView.frame.size.width - self.sectionInset.left - self.sectionInset.right - (self.listCount - 1) * self.listMargin) / self.listCount;
    CGFloat height = [self.delegate waterFloatLayout:self heightForWidth:width atIndexPath:indexPath];
    CGFloat x = self.sectionInset.left + (width + self.listMargin) * [minList floatValue];
    CGFloat y = [self.maxYDict[minList] floatValue] + self.lineMargin;
    
    self.maxYDict[minList] = @(y + height);
    
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attr.frame = CGRectMake(x, y, width, height);
    return attr;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
//    int count = (int)[self.collectionView numberOfItemsInSection:0];
//    for (int i = 0; i < count; i++) {
//        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
//        UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:indexPath];
//        [self.attrsArray addObject:attr];
//    }
    return self.attrsArray;
}

@end
