//
//  HMDeal.h
//  美团HD
//
//  Created by apple on 15/6/19.
//  Copyright (c) 2015年 chenMH. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HMRestriction;

@interface HMDeal : NSObject <NSCoding>
/** 团购单ID */
@property (nonatomic,copy) NSString *deal_id;
/** 团购标题 */
@property (nonatomic,copy) NSString *title;
/** 团购描述 */
@property (nonatomic,copy) NSString *desc;
/** 团购包含商品原价值 */
@property (nonatomic,copy) NSString *list_price;
/** 团购价格 */
@property (nonatomic,copy) NSString *current_price;
/** 团购当前已购买数 */
@property (nonatomic,copy) NSString *purchase_count;
/** 团购图片链接，最大图片尺寸450×280 */
@property (nonatomic,copy) NSString *image_url;
/** 小尺寸团购图片链接，最大图片尺寸160×100 */
@property (nonatomic,copy) NSString *s_image_url;
/** 团购发布上线日期 */
@property (nonatomic,copy) NSString *publish_date;
/** 团购单的截止购买日期 */
@property (nonatomic,copy) NSString *purchase_deadline;
/** 团购Web页面链接，适用于网页应用 */
@property (nonatomic,copy) NSString *deal_url;
/** 团购HTML5页面链接，适用于移动应用和联网车载应用 */
@property (nonatomic,copy) NSString *deal_h5_url;
/** 是否支持随时退款，0：不是，1：是 */
@property (nonatomic, assign) BOOL is_refundable;

/** 记录当前团购的编辑状态 */
@property (nonatomic, assign, getter=isEditing) BOOL editing;
/** 是否被勾选 */
@property (nonatomic, assign, getter=isChecked) BOOL checked;


@end
