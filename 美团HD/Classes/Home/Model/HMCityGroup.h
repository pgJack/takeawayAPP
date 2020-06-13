//
//  HMCityGroup.h
//  美团HD
//
//  Created by apple on 20/6/13.
//  Copyright (c) 2020年 itheima. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMCityGroup : NSObject
/** 这组的名称 */
@property (nonatomic, copy) NSString *title;
/** 这组的城市名称 */
@property (nonatomic, strong) NSArray *cities;

@end
