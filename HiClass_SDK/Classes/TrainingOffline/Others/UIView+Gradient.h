//
//  UIView+Gradient.h
//  HiClass
//
//  Created by hisense on 2020/4/20.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    CornerNone,
    CornerTop,
    CornerBottom,
    CornerAll
} ViewCornerType;

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Gradient)
- (void)addGradientLayer:(CGPoint)startPoint endPoint:(CGPoint)endPoint colors:(NSArray *)colors;
- (void)addCornerWithRadius:(CGFloat)radius cornerType:(ViewCornerType)cornerType;
- (void)removeCorner;
@end

NS_ASSUME_NONNULL_END
