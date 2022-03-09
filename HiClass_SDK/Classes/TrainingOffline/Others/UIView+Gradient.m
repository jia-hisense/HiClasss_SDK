//
//  UIView+Gradient.m
//  HiClass
//
//  Created by hisense on 2020/4/20.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import "UIView+Gradient.h"


@implementation UIView (Gradient)

- (void)addGradientLayer:(CGPoint)startPoint endPoint:(CGPoint)endPoint colors:(NSArray *)colors {

    [self layoutIfNeeded];

    CAGradientLayer *gradientLayer = [CAGradientLayer layer];

    gradientLayer.frame = self.layer.bounds;
    gradientLayer.startPoint = startPoint;
    gradientLayer.endPoint = endPoint;
    gradientLayer.colors = colors;
    gradientLayer.cornerRadius = self.layer.cornerRadius;
    gradientLayer.masksToBounds = YES;
    [self.layer insertSublayer:gradientLayer atIndex:0];
    self.backgroundColor = [UIColor clearColor];
    self.layer.masksToBounds = NO;
    
}

- (void)addCornerWithRadius:(CGFloat)radius cornerType:(ViewCornerType)cornerType {
    
//    self.layer.masksToBounds = YES;

    switch (cornerType) {
        case CornerNone:
            [self removeCorner];
            break;
        case CornerTop:
            [self setCornerOnTopWithRadius:radius];
            break;
        case CornerBottom:
            [self setCornerOnBottomWithRadius:radius];
            break;
        case CornerAll:
            [self setAllCornerWithRadius:radius];
            break;
        default:
            break;
    }
}

- (void)setCornerOnTopWithRadius:(CGFloat)radius {
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                     byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
                                           cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;

}

- (void)setCornerOnBottomWithRadius:(CGFloat)radius {
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                     byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight)
                                           cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;

}

- (void)setAllCornerWithRadius:(CGFloat)radius {
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                          cornerRadius:radius];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;

}

- (void)removeCorner {
    self.layer.mask = nil;
}
    @end
