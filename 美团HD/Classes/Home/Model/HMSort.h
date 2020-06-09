//
//  HMSort.h
//  美团HD
//
//  Created by apple on 15/6/10.
//  Copyright (c) 2015年 itheima. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMSort : NSObject
/** 文字描述 */
@property (nonatomic, copy) NSString *label;
/** 这个排序具体的值 (将来需要发给服务器) */
@property (nonatomic, assign) int value;

@end
