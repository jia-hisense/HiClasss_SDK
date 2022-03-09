//
//  UIImage+HICExtension.h
//  HiClass
//
//  Created by Eddie Ma on 2020/2/13.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (HICExtension)

/** 生成指定颜色的image */
+ (UIImage *)imageWithColor:(UIColor *)color;
//图片加水印
//+ (UIImage *)waterLogo:(UIImage *)logoImage waterString:(NSString *)waterString;
@end

NS_ASSUME_NONNULL_END
