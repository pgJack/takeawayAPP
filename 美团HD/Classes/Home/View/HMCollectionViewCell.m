//
//  HMCollectionViewCell.m
//  美团HD
//
//  Created by apple on 15/6/19.
//  Copyright (c) 2015年 itheima. All rights reserved.
//

#import "HMCollectionViewCell.h"
#import "HMCenterLineLabel.h"     
#import "HMDeal.h"
#import <UIImageView+WebCache.h>

@interface HMCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentPriceLabel;
@property (weak, nonatomic) IBOutlet HMCenterLineLabel *listPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *purchaseCountLabel;


@end

@implementation HMCollectionViewCell

- (void)drawRect:(CGRect)rect
{
    UIImage *image = [UIImage imageNamed:@"bg_dealcell"];
    [image drawInRect:rect];
}

- (void)setDeal:(HMDeal *)deal
{
    _deal = deal;
    
    // 图片
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:deal.image_url] placeholderImage:[UIImage imageNamed:@"placeholder_deal"]];
    // 标题
    self.titleLabel.text = deal.title;
    // 描述
    self.descLabel.text = deal.desc;
    // 原价
    self.listPriceLabel.text = [NSString stringWithFormat:@"￥%@",deal.list_price];
    // 现价
//    self.currentPriceLabel.text = [NSString stringWithFormat:@"￥%@", [NSString dealedPriceString:deal.current_price]];
    //    self.currentPriceLabel.text = [NSString stringWithFormat:@"￥%@", deal.current_price.dealedPriceString];
    self.currentPriceLabel.text = [NSString stringWithFormat:@"￥%@", deal.current_price];
    // 购买数
    self.purchaseCountLabel.text = [NSString stringWithFormat:@"已售%@",deal.purchase_count];
}

@end
