//
//  HMDataTool.h
//  美团HD
//
//  Created by apple on 20/6/9.
//  Copyright (c) 2020年 itheima. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMDataTool : NSObject
/**
 *  返回所有的排序数据 (里面都是HMSort模型)
 */
+ (NSArray *)sorts;

/**
 *  返回所有的排序数据 (里面都是HMCategory模型)
 */
+ (NSArray *)categories;

/**
 *  返回所有的城市数据 (里面都是HMCityGroup模型)
 */
+ (NSArray *)cityGroups;

/**
 *  返回所有的城市名字 (里面都是NSString对象)
 */
+ (NSArray *)cityNames;

/**
 *  返回所有的城市 (里面都是HMCity模型)
 */
+ (NSArray *)cities;

@end
