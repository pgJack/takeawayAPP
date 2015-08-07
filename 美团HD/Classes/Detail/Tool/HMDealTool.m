//
//  HMDealTool.m
//  美团HD
//
//  Created by apple on 15/8/4.
//  Copyright (c) 2015年 itheima. All rights reserved.
//

#import "HMDealTool.h"
#import "HMDeal.h"

#define HMCollectFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"collect_deal.data"]

@implementation HMDealTool

static NSMutableArray *_collectedDeal;
+ (void)initialize
{
    // 从文件中读取之前收藏的团购
    _collectedDeal = [NSKeyedUnarchiver unarchiveObjectWithFile:HMCollectFile];
    // 如果是第一次收藏团购,先初始化一个可变的数组
    if (_collectedDeal == nil) {
        _collectedDeal = [NSMutableArray array];
    }

}

+ (void)collect:(HMDeal *)deal
{
    // 1. 将收藏的团购插入到数组的最前面
    [_collectedDeal insertObject:deal atIndex:0];
    // 2. 归档
    [NSKeyedArchiver archiveRootObject:_collectedDeal toFile:HMCollectFile];
}

+ (void)uncollect:(HMDeal *)deal
{
    // 1. 移除团购
    [_collectedDeal removeObject:deal];
    // 2. 归档
    [NSKeyedArchiver archiveRootObject:_collectedDeal toFile:HMCollectFile];
}

+ (BOOL)isCollected:(HMDeal *)deal
{
    return [_collectedDeal containsObject:deal];
}

+ (NSArray *)collectedDeals
{
    return _collectedDeal;
}

@end
