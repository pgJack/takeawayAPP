//
//  HMCity.h
//  美团HD
//
//  Created by apple on 15/6/16.
//  Copyright (c) 2015年 itheima. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMCity : NSObject
/** 城市名字 */
@property (nonatomic, copy) NSString *name;
/** 城市名字的拼音 */
@property (nonatomic, copy) NSString *pinYin;
/** 城市名字拼音的声母 */
@property (nonatomic, copy) NSString *pinYinHead;

@end
