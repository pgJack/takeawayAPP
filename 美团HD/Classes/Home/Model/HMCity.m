//
//  HMCity.m
//  美团HD
//
//  Created by apple on 15/6/16.
//  Copyright (c) 2015年 chenMH. All rights reserved.
//

#import "HMCity.h"
#import "HMDistrict.h"
#import <MJExtension.h>

@implementation HMCity

+ (NSDictionary *)objectClassInArray
{
    return @{@"districts" : [HMDistrict class]};
}

@end
