//
//  HMPerson.m
//  美团HD
//
//  Created by apple on 20/6/9.
//  Copyright (c) 2020年 chenMH. All rights reserved.
//

#import "HMPerson.h"

@implementation HMPerson
#pragma mark - 单例模式
HMSingleton_M
//static id _instance;
//+ (instancetype)allocWithZone:(struct _NSZone *)zone
//{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        _instance = [super allocWithZone:zone];
//    });
//    return _instance;
//}
//+ (instancetype)sharedInstance
//{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        _instance = [[self alloc] init];
//    });
//    return _instance;
//}
@end
