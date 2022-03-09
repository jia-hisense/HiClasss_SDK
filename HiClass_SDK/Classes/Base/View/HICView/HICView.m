//
//  HICView.m
//  HiClass
//
//  Created by jiafujia on 2021/8/4.
//  Copyright © 2021 hisense. All rights reserved.
//

#import "HICView.h"

@interface HICView () {
    CAGradientLayer *_gradientLayer;
}
@end

@implementation HICView

+ (Class)layerClass {
    return [CAGradientLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _gradientLayer = (CAGradientLayer *)self.layer;
        self.cornerRadii = CGSizeZero;
    }
    return self;
}

- (void)layoutSublayersOfLayer:(CALayer *)layer {
    [super layoutSublayersOfLayer:layer];
    [self addRoundCorners];
}

- (void)addRoundCorners {
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                     byRoundingCorners:self.corners
                                           cornerRadii:self.cornerRadii];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

/**
 *  重写setter,getter方法
 */
@synthesize colors = _colors;
- (void)setColors:(NSArray *)colors {
    _colors = colors;
    NSMutableArray *cgColors = [NSMutableArray array];
    for (UIColor *tmp in colors) {
        id cgColor = (__bridge id)tmp.CGColor;
        [cgColors addObject:cgColor];
    }
    _gradientLayer.colors = cgColors;
}
- (NSArray *)colors {
    return _colors;
}

@synthesize locations = _locations;
- (void)setLocations:(NSArray *)locations {
    _locations = locations;
    _gradientLayer.locations = _locations;
}

- (NSArray *)locations {
    return _locations;
}

@synthesize startPoint = _startPoint;
- (void)setStartPoint:(CGPoint)startPoint {
    _startPoint = startPoint;
    _gradientLayer.startPoint = startPoint;
}
- (CGPoint)startPoint {
    return _startPoint;
}

@synthesize endPoint = _endPoint;
- (void)setEndPoint:(CGPoint)endPoint {
    _endPoint = endPoint;
    _gradientLayer.endPoint = endPoint;
}
- (CGPoint)endPoint {
    return _endPoint;
}

@end
