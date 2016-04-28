//
//  HMCollectionViewCell.h
//  美团HD
//
//  Created by apple on 15/6/19.
//  Copyright (c) 2015年 chenMH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HMDeal;

@interface HMCollectionViewCell : UICollectionViewCell
/** 团购模型 */
@property (nonatomic, strong) HMDeal *deal;

@end
