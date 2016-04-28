//
//  HMFineDealResult.m
//  美团HD
//
//  Created by apple on 15/6/19.
//  Copyright (c) 2015年 chenMH. All rights reserved.
//

#import "HMFineDealResult.h"
#import <MJExtension.h>
#import "HMDeal.h"

@implementation HMFineDealResult

+ (NSDictionary *)objectClassInArray
{
    return @{@"deals" : [HMDeal class]};
}

@end
