//
//  HMSingleton.h
//  美团HD
//
//  Created by apple on 20/6/9.
//  Copyright (c) 2020年 itheima. All rights reserved.
//

#define HMSingleton_H + (instancetype)sharedInstance;

#define HMSingleton_M \
static id _instance; \
+ (instancetype)allocWithZone:(struct _NSZone *)zone \
{ \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        _instance = [super allocWithZone:zone]; \
    }); \
    return _instance; \
} \
+ (instancetype)sharedInstance \
{ \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        _instance = [[self alloc] init]; \
    }); \
    return _instance; \
}

