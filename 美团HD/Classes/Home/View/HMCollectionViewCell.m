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
/** 如果方法以new,alloc,init开头,那么这些方法必须返回跟方法调用者同一类型的对象 */
@property (weak, nonatomic) IBOutlet UIImageView *dealNewMark;


@end

@implementation HMCollectionViewCell

- (void)awakeFromNib
{
    self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_dealcell"]];
}

//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    
//    [self setNeedsDisplay];
//}
//
//- (void)drawRect:(CGRect)rect
//{
//    UIImage *image = [UIImage imageNamed:@"bg_dealcell"];
//    [image drawInRect:rect];
//}

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
    self.currentPriceLabel.text = [NSString stringWithFormat:@"￥%@", deal.current_price];
    // 购买数
    self.purchaseCountLabel.text = [NSString stringWithFormat:@"已售%@",deal.purchase_count];
    // 新单
    // 获得今天的年月日
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *now = [fmt stringFromDate:[NSDate date]];
    // 比较
    // now : 2008-08-08
    // publish_date : 2009-08-09
    NSComparisonResult result = [now compare:deal.publish_date];
    self.dealNewMark.hidden = (result == NSOrderedDescending);
    
//    self.dealNewMark.hidden = (result == NSOrderedDescending) ? YES : NO;
//    if (result == NSOrderedSame || result == NSOrderedAscending) { // 新单
//        self.dealNewMark.hidden = NO;
//    } else { // 非新单
//        self.dealNewMark.hidden = YES;
//    }
    
    /*
     NSOrderedAscending = -1L, 升序 (左边 < 右边)
     NSOrderedSame,            相同 (左边 == 右边)
     NSOrderedDescending       降序 (左边 > 右边)
     */
}

@end
