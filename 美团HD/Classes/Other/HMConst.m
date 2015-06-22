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

/** 城市改变的通知 */
NSString * const HMCityDidChangeNotification = @"HMCityDidChangeNotification";
/** 通过这个key可以取出当前的城市模型 */
NSString * const HMCurrentCityKey = @"HMCurrentCityKey";

/** 区域改变的通知 */
NSString * const HMDistrictDidChangeNotification = @"HMDistrictDidChangeNotification";
/** 通过这个key可以取出当前的区域模型 */
NSString * const HMCurrentDistrictKey = @"HMCurrentDistrictKey";
/** 通过这个key可以取出当前子区域的索引 */
NSString * const HMCurrentSubdistrictIndexKey = @"HMCurrentSubdistrictIndexKey";

// 数值
CGFloat HMScreenMaxWH = 1024;
CGFloat HMScreenMinWH = 768;


