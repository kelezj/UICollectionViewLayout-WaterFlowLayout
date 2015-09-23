//
//  ZJShopCell.m
//  0829-瀑布流
//
//  Created by 张健 on 15/8/29.
//  Copyright (c) 2015年 张健. All rights reserved.
//

#import "ZJShopCell.h"
#import "ZJShop.h"
#import "UIImageView+WebCache.h"

@interface ZJShopCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UILabel *priceL;

@end
@implementation ZJShopCell

- (void)awakeFromNib{
    _priceL.textAlignment = NSTextAlignmentCenter;
}


- (void)setShop:(ZJShop *)shop{
    _shop = shop;
    
    [_imgV sd_setImageWithURL:[NSURL URLWithString:shop.img] placeholderImage:[UIImage imageNamed:@"loading"]];
    _priceL.text = shop.price;
}

@end
