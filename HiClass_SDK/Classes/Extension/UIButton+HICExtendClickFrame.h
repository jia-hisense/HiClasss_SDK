//
//  UIButton+HICExtendClickFrame.h
//  HiClass
//
//  Created by WorkOffice on 2020/2/12.
//  Copyright © 2020 jingxianglong. All rights reserved.
//
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef struct HICClickEdgeInsets {
    
    CGFloat top,left,bottom,right;
    
} HICClickEdgeInsets;

UIKIT_STATIC_INLINE  HICClickEdgeInsets HICClickEdgeInsetsMake(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right) {
     HICClickEdgeInsets clickEdgeInsets = {top, left, bottom, right};
    return clickEdgeInsets;
}
@interface UIButton (HICExtendClickFrame)
/**
 改变button的点击范围
 length:范围边缘距离（四个边缘同样距离）
 */
- (void)hicChangeButtonClickLength:(CGFloat)length;

/**
 改变button的点击范围
 edgeInsets:范围边缘距离
 */
- (void)hicChangeButtonClickRange:(HICClickEdgeInsets)edgeInsets;

@end

NS_ASSUME_NONNULL_END
