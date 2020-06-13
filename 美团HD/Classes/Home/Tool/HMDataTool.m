//
//  HMDataTool.m
//  美团HD
//
//  Created by apple on 20/6/9.
//  Copyright (c) 2020年 itheima. All rights reserved.
//

#import "HMDataTool.h"
#import "HMSort.h"
#import "HMCategory.h"
#import "HMCityGroup.h"
#import <MJExtension.h>

@implementation HMDataTool

static NSArray *_sorts;
+ (NSArray *)sorts
{
    if (_sorts == nil) {
        _sorts = [HMSort objectArrayWithFilename:@"sorts.plist"];
    }
    return _sorts;
}

static NSArray *_categories;
+ (NSArray *)categories
{
    if (_categories == nil) {
        _categories = [HMCategory objectArrayWithFilename:@"categories.plist"];
    }
    return _categories;
}

static NSArray *_cityGroups;
+ (NSArray *)cityGroups
{
    if (_cityGroups == nil) {
        _cityGroups = [HMCityGroup objectArrayWithFilename:@"cityGroups.plist"];
    }
    return _cityGroups;
}

@end
