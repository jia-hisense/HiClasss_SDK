//
//  GradientView.h
//  
//
//  Created by 尚轩瑕 on 2017/12/10.
//

#import <UIKit/UIKit.h>

/// 到航线
@interface GradientView : UIView

/// 图片类型的构造方式
/// @param image 需要展示的图片
/// @param frame 位置信息
-(instancetype)initWithImage:(UIImage *)image andFrame:(CGRect)frame;

/**
 渐变的颜色数组
 */
@property (copy, nonatomic) NSArray *gradientLayerColors;


/**
 颜色分割线
 */
@property (copy, nonatomic) NSArray *gradientLayerLocations;

@end
