//
//  WMZBannerConfig.h
//  WMZBanner
//
//  Created by wmz on 2019/9/6.
//  Copyright © 2019 wmz. All rights reserved.
//



#ifndef WMZBannerConfig_h
#define WMZBannerConfig_h

//#import "UIImageView+WebCache.h"
#import <UIKit/UIKit.h>

#define BannerWitdh  [UIScreen mainScreen].bounds.size.width
#define BannerHeight [UIScreen mainScreen].bounds.size.height

#define BannerWeakSelf(obj) __weak typeof(obj) weakObject = obj;
#define BannerStrongSelf(obj) __strong typeof(obj) strongObject = weakObject;

#define BannerColor(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define WMZBannerPropStatementAndPropSetFuncStatement(propertyModifier,className, propertyPointerType, propertyName)           \
@property(nonatomic,propertyModifier)propertyPointerType  propertyName;                                                 \
- (className * (^) (propertyPointerType propertyName)) propertyName##Set;

#define WMZBannerPropSetFuncImplementation(className, propertyPointerType, propertyName)                                \
- (className * (^) (propertyPointerType propertyName))propertyName##Set{                                                \
return ^(propertyPointerType propertyName) {                                                                            \
_##propertyName = propertyName;                                                                                         \
return self;                                                                                                        \
};                                                                                                                      \
}


/*
 * cell的block
 */
typedef UICollectionViewCell* (^BannerCellCallBlock)(NSIndexPath *indexPath,UICollectionView* collectionView,id model,UIImageView* bgImageView,NSArray*dataArr);

/*
 * 点击
 */
typedef void (^BannerClickBlock)(id anyID,NSInteger index);

/*
 * 自定义pageControl
 */
typedef void (^BannerPageControl)(UIPageControl* pageControl);

/*
 * 点击 ,可获取居中cell
 */
typedef void (^BannerCenterClickBlock)(id anyID,NSInteger index,BOOL isCenter,UICollectionViewCell* cell);

/*
 * 滚动结束
 */
typedef void (^BannerScrollEndBlock)(id anyID,NSInteger index,BOOL isCenter,UICollectionViewCell* cell);

/*
 *cell动画的位置
 */
typedef enum :NSInteger{
    BannerCellPositionCenter      = 0,             //居中 默认
    BannerCellPositionBottom      = 1,             //置底
}BannerCellPosition;

/*
 *pageControl的位置
 */
typedef enum :NSInteger{
    BannerControlCenter      = 0,             //居中 默认
    BannerControlLeft        = 1,             //左下
    BannerControlRight       = 2,             //右下
}BannerControlPosition;



#endif /* WMZBannerConfig_h */
