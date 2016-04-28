//
//  HMHomeTopItem.h
//  美团HD
//
//  Created by apple on 20/6/13.
//  Copyright (c) 2020年 chenMH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMHomeTopItem : UIView
+ (instancetype)item;

- (void)setTitle:(NSString *)title;
- (void)setSubtitle:(NSString *)subtitle;
- (void)setIcon:(NSString *)icon highIcon:(NSString *)highIcon;
- (void)addTarget:(id)target action:(SEL)action;

@end
