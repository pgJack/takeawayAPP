//
//  HMDistrictViewController.h
//  美团HD
//
//  Created by apple on 20/6/14.
//  Copyright (c) 2020年 chenMH. All rights reserved.
//  区域控制器

#import <UIKit/UIKit.h>

@interface HMDistrictViewController : UIViewController

/** 这个控制器显示的所有区域数据 (里面都是区域模型) */
@property (nonatomic, strong) NSArray *districts;
@end
