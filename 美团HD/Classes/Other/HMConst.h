#import <UIKit/UIKit.h>

// 通知
/** 排序改变的通知 */
UIKIT_EXTERN NSString * const HMSortDidChangeNotification;
/** 通过这个key可以取出当前的排序模型 */
UIKIT_EXTERN NSString * const HMCurrentSortKey;

/** 类别改变的通知 */
UIKIT_EXTERN NSString * const HMCategoryDidChangeNotification;
/** 通过这个key可以取出当前的类别模型 */
UIKIT_EXTERN NSString * const HMCurrentCategoryKey;
/** 通过这个key可以取出当前子类别的索引 */
UIKIT_EXTERN NSString * const HMCurrentSubcategoryIndexKey;