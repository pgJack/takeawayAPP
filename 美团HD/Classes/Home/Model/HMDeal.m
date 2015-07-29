//
//  HMDeal.m
//  美团HD
//
//  Created by apple on 15/6/19.
//  Copyright (c) 2015年 itheima. All rights reserved.
//

#import "HMDeal.h"
#import "NSString+Extension.h"
#import <MJExtension.h>

@implementation HMDeal

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"desc" : @"description",
             @"is_refundable" : @"restrictions.is_refundable"};
}

- (void)setCurrent_price:(NSString *)current_price
{
    _current_price = current_price.dealedPriceString;
}

@end
