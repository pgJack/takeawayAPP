//
//  HMFineDealResult.h
//  美团HD
//
//  Created by apple on 15/6/19.
//  Copyright (c) 2015年 itheima. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMFineDealResult : NSObject
/** 所有页面团购总数 */
@property (nonatomic, assign) int total_count;
/** 本次团购数据 (里面都是HMDeal模型) */
@property (nonatomic, strong) NSArray *deals;

@end
