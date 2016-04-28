//
//  HMDropDownLeftCell.m
//  美团HD
//
//  Created by apple on 20/6/10.
//  Copyright (c) 2020年 chenMH. All rights reserved.
//

#import "HMDropDownLeftCell.h"

@implementation HMDropDownLeftCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *leftId = @"left";
    HMDropDownLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:leftId];
    if (cell == nil) {
        cell = [[HMDropDownLeftCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:leftId];
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_dropdown_leftpart"]];
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_dropdown_left_selected"]];
    }
    return cell;
}

@end
