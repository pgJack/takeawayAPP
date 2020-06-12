#import <UIKit/UIKit.h>

// 通知
/** 排序改变的通知 */
NSString * const HMSortDidChangeNotification = @"HMSortDidChangeNotification";
/** 通过这个key可以取出当前的排序模型 */
NSString * const HMCurrentSortKey = @"HMCurrentSortKey";

/** 类别改变的通知 */
NSString * const HMCategoryDidChangeNotification = @"HMCategoryDidChangeNotification";
/** 通过这个key可以取出当前的类别模型 */
NSString * const HMCurrentCategoryKey = @"HMCurrentCategoryKey";
/** 通过这个key可以取出当前子类别的索引 */
NSString * const HMCurrentSubcategoryIndexKey = @"HMCurrentSubcategoryIndexKey";