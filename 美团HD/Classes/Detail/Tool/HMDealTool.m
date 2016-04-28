//
//  HMDealTool.m
//  美团HD
//
//  Created by apple on 15/8/4.
//  Copyright (c) 2015年 chenMH. All rights reserved.
//

#import "HMDealTool.h"
#import "HMDeal.h"

/** 最大的历史记录个数 */
static int const HMMaxHistoryDealsCount = 9;

#define HMCollectFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"collect_deal.data"]

#define HMHistoryFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"history_deal.data"]

@implementation HMDealTool

// 收藏数组
static NSMutableArray *_collectedDeals;
// 历史记录数组
static NSMutableArray *_historyDeals;

+ (void)initialize
{
    // 从文件中读取之前收藏的团购
    _collectedDeals = [NSKeyedUnarchiver unarchiveObjectWithFile:HMCollectFile];
    // 如果是第一次收藏团购,先初始化一个可变的数组
    if (_collectedDeals == nil) {
        _collectedDeals = [NSMutableArray array];
    }
    // 从文件中读取之前历史的团购
    _historyDeals = [NSKeyedUnarchiver unarchiveObjectWithFile:HMHistoryFile];
    // 如果是第一次历史团购,先初始化一个可变的数组
    if (_historyDeals == nil) {
        _historyDeals = [NSMutableArray array];
    }

}

#pragma mark - 收藏记录

+ (void)collect:(HMDeal *)deal
{
    // 1. 将收藏的团购插入到数组的最前面
    [_collectedDeals insertObject:deal atIndex:0];
    // 2. 归档
    [NSKeyedArchiver archiveRootObject:_collectedDeals toFile:HMCollectFile];
}

+ (void)uncollect:(HMDeal *)deal
{
    // 1. 移除团购
    [_collectedDeals removeObject:deal];
    // 2. 归档
    [NSKeyedArchiver archiveRootObject:_collectedDeals toFile:HMCollectFile];
}

+ (BOOL)isCollected:(HMDeal *)deal
{
    return [_collectedDeals containsObject:deal];
}

+ (NSArray *)collectedDeals
{
    return _collectedDeals;
}

+ (void)uncollectDeals:(NSArray *)deals
{
    [_collectedDeals removeObjectsInArray:deals];
    // 归档
    [NSKeyedArchiver archiveRootObject:_collectedDeals toFile:HMCollectFile];
}

#pragma mark - 历史记录

/**
 *  返回用户浏览的所有团购
 */
+ (NSArray *)historyDeals
{
    return _historyDeals;
}

/**
 *  添加一个最近访问的团购
 */
+ (void)addHistoryDeal:(HMDeal *)deal
{
    [_historyDeals removeObject:deal];
    [_historyDeals insertObject:deal atIndex:0];
    
    if (_historyDeals.count > HMMaxHistoryDealsCount) {
        // 删除最后一个团购
        [_historyDeals removeLastObject];
    }
    
    // 归档
    [NSKeyedArchiver archiveRootObject:_historyDeals toFile:HMHistoryFile];
}

/**
 *  删除团购
 */
+ (void)removeHistoryDeal:(HMDeal *)deal
{
    [_historyDeals removeObject:deal];
    // 归档
    [NSKeyedArchiver archiveRootObject:_historyDeals toFile:HMHistoryFile];
}

/**
 *  删除团购数组
 */
+ (void)removeHistoryDeals:(NSArray *)deals
{
    [_historyDeals removeObjectsInArray:deals];
    // 归档
    [NSKeyedArchiver archiveRootObject:_historyDeals toFile:HMHistoryFile];
}


@end
