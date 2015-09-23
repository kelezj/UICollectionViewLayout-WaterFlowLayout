//
//  ZJWaterFlowLayout.h
//  0829-瀑布流
//
//  Created by 张健 on 15/8/29.
//  Copyright (c) 2015年 张健. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZJWaterFlowLayout;
@protocol ZJWaterFlowLayoutDelegate <NSObject>
- (CGFloat)waterFloatLayout:(ZJWaterFlowLayout *)waterFlowLayout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath;
@end

@interface ZJWaterFlowLayout : UICollectionViewLayout
/** 显示的列数 */
@property (nonatomic, assign) int listCount;
/** 列间距 */
@property (nonatomic, assign) CGFloat listMargin;
/** 行间距 */
@property (nonatomic, assign) CGFloat lineMargin;
/** 四周间距 */
@property (nonatomic, assign) UIEdgeInsets sectionInset;
/** 代理 */
@property (nonatomic, weak) id<ZJWaterFlowLayoutDelegate> delegate;
@end
