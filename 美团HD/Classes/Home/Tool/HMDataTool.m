//
//  HMDataTool.m
//  美团HD
//
//  Created by apple on 20/6/9.
//  Copyright (c) 2020年 itheima. All rights reserved.
//

#import "HMDataTool.h"
#import "HMSort.h"
#import <MJExtension.h>

@implementation HMDataTool

static NSArray *_sorts;
//+ (void)initialize
//{
//    _sorts = [HMSort objectArrayWithFilename:@"sorts.plist"];
//}

+ (NSArray *)sorts
{
    if (_sorts == nil) {
        _sorts = [HMSort objectArrayWithFilename:@"sorts.plist"];
    }
    return _sorts;
}

@end
