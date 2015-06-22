//
//  HMCollectionViewCell.m
//  美团HD
//
//  Created by apple on 15/6/19.
//  Copyright (c) 2015年 itheima. All rights reserved.
//

#import "HMCollectionViewCell.h"
#import "HMCenterLineLabel.h"       

@interface HMCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentPriceLabel;
@property (weak, nonatomic) IBOutlet HMCenterLineLabel *listPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *perchaseCountLabel;


@end

@implementation HMCollectionViewCell

- (void)awakeFromNib {
//    self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_dealcell"]];
}

- (void)drawRect:(CGRect)rect
{
    UIImage *image = [UIImage imageNamed:@"bg_dealcell"];
    [image drawInRect:rect];
}

@end
