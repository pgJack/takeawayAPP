//
//  HMGetSingleDealResult.m
//  美团HD
//
//  Created by apple on 15/7/28.
//  Copyright (c) 2015年 chenMH. All rights reserved.
//

#import "HMGetSingleDealResult.h"
#import "HMDeal.h"

@implementation HMGetSingleDealResult

+ (NSDictionary *)objectClassInArray
{
    return @{@"deals" : [HMDeal class]};
}

@end