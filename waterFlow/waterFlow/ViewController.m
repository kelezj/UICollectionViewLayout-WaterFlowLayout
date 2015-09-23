//
//  ViewController.m
//  0829-瀑布流
//
//  Created by 张健 on 15/8/29.
//  Copyright (c) 2015年 张健. All rights reserved.
//

#import "ViewController.h"
#import "ZJWaterFlowLayout.h"
#import "MJExtension.h"
#import "ZJShop.h"
#import "ZJShopCell.h"
#import "MJRefresh.h"

@interface ViewController () <UICollectionViewDelegate,UICollectionViewDataSource,ZJWaterFlowLayoutDelegate>
@property (nonatomic, strong) NSMutableArray *shops;
@property (nonatomic, weak) UICollectionView *collectionView;
@end

@implementation ViewController

- (NSMutableArray *)shops{
    if (_shops == nil) {
        _shops = [NSMutableArray array];
    }
    return _shops;
}

static NSString * const ID = @"water";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *shops = [ZJShop objectArrayWithFilename:@"1.plist"];
    [self.shops addObjectsFromArray:shops];
    ZJWaterFlowLayout *layout = [[ZJWaterFlowLayout alloc] init];
    layout.delegate = self;
    CGRect frame = self.view.bounds;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor grayColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;

    [collectionView registerNib:[UINib nibWithNibName:@"ZJShopCell" bundle:nil] forCellWithReuseIdentifier:ID];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
    // 上拉刷新
    [self.collectionView addFooterWithTarget:self action:@selector(loadMoreDatas)];
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.shops.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ZJShopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
    cell.shop = self.shops[indexPath.item];
    return cell;
}

#pragma mark - <UICollectionViewDelegate> 点击删除
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.shops removeObjectAtIndex:indexPath.item];
    [collectionView deleteItemsAtIndexPaths:@[indexPath]];
}

#pragma mark - <ZJWaterFlowLayoutDelegate>
- (CGFloat)waterFloatLayout:(ZJWaterFlowLayout *)waterFlowLayout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath{
    ZJShop *shop = self.shops[indexPath.item];
    return shop.h / shop.w * width;
}

#pragma mark - 上拉刷新
- (void)loadMoreDatas{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray *shops = [ZJShop objectArrayWithFilename:@"1.plist"];
        [self.shops addObjectsFromArray:shops];
        
        [self.collectionView reloadData];
        [self.collectionView footerEndRefreshing];
        
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
