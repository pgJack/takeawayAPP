//
//  HMHomeTopItem.m
//  美团HD
//
//  Created by apple on 20/6/13.
//  Copyright (c) 2020年 itheima. All rights reserved.
//

#import "HMHomeTopItem.h"

@implementation HMHomeTopItem

+ (instancetype)item
{
    return [[[NSBundle mainBundle] loadNibNamed:@"HMHomeTopItem" owner:nil options:nil] firstObject];
}

- (void)awakeFromNib
{
    self.autoresizingMask = UIViewAutoresizingNone;
//    self.translatesAutoresizingMaskIntoConstraints = NO;
}

@end
