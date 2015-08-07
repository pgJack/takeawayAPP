//
//  HMDealTool.h
//  美团HD
//
//  Created by apple on 15/8/4.
//  Copyright (c) 2015年 itheima. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HMDeal;

@interface HMDealTool : NSObject

/**
 *  返回用户收藏的所有团购
 */
+ (NSArray *)collectedDeals;

/**
 *  收藏团购
 */
+ (void)collect:(HMDeal *)deal;

/**
 *  取消团购
 */
+ (void)uncollect:(HMDeal *)deal;

/**
 *  判断某个团购是否被收藏
 */
+ (BOOL)isCollected:(HMDeal *)deal;

@end
