//
//  HMDeal.m
//  美团HD
//
//  Created by apple on 15/6/19.
//  Copyright (c) 2015年 chenMH. All rights reserved.
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

/**
 *  这个方法的作用 : 比较self和other是否为同一个对象
 */
- (BOOL)isEqual:(HMDeal *)other
{
    //    if ([self.deal_id isEqualToString:other.deal_id]) {
    //        return YES;
    //    } else {
    //        return NO;
    //    }
    //    HMLog(@"%@ - %@", self, other);
    return [self.deal_id isEqualToString:other.deal_id];
}

#pragma mark - <NSCoding> 协议

MJCodingImplementation
/**
 *  将对象写入文件时调用 (归档, 在这个方法中说明哪些属性需要存储, 怎么存储)
 */
//- (void)encodeWithCoder:(NSCoder *)aCoder
//{
//    [aCoder encodeObject:self.title forKey:@"title"];
//    [aCoder encodeObject:self.deal_id forKey:@"deal_id"];
//    [aCoder encodeObject:self.desc forKey:@"desc"];
//}

/**
 *  从文件中读取一个对象时会调用 (解档, 在这个方法中说明哪些属性需要获取, 怎么获取)
 */
//- (id)initWithCoder:(NSCoder *)aDecoder
//{
//    if (self = [super init]) {
//        self.title = [aDecoder decodeObjectForKey:@"title"];
//        self.deal_id = [aDecoder decodeObjectForKey:@"deal_id"];
//    }
//    return self;
//}

@end
