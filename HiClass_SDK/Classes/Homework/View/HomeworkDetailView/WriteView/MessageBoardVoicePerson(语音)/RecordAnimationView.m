//
//  RecordAnimationView.m
//  HiClass
//
//  Created by 铁柱， on 2020/3/27.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "RecordAnimationView.h"

@implementation RecordAnimationView
// 84的款 22的高
-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}

-(void)createView {

    UIBezierPath *path = [UIBezierPath new];

    CGFloat lineWidth = 4;

    [path moveToPoint:CGPointMake(2, 7)];
    [path addLineToPoint:CGPointMake(2, 15)];

    [path moveToPoint:CGPointMake(12, 5.5)];

    [path addLineToPoint:CGPointMake(12, 16.5)];

    [path moveToPoint:CGPointMake(22, 4)];

    [path addLineToPoint:CGPointMake(22, 18)];

    [path moveToPoint:CGPointMake(32, 2.5)];

    [path addLineToPoint:CGPointMake(32, 19.5)];

    [path moveToPoint:CGPointMake(42, 0)];

    [path addLineToPoint:CGPointMake(42, 22)];

    [path moveToPoint:CGPointMake(52, 2.5)];

    [path addLineToPoint:CGPointMake(52, 19.5)];

    [path moveToPoint:CGPointMake(62, 4)];

    [path addLineToPoint:CGPointMake(62, 18)];

    [path moveToPoint:CGPointMake(72, 5.5)];
    [path addLineToPoint:CGPointMake(72, 16.5)];

    [path moveToPoint:CGPointMake(82, 7)];
    [path addLineToPoint:CGPointMake(82, 15)];

    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineJoinRound;

    CAShapeLayer *layer = CAShapeLayer.new;
    layer.lineWidth = lineWidth;
    layer.path = path.CGPath;
    layer.lineCap = kCALineCapRound;
    layer.fillColor = UIColor.clearColor.CGColor;
    layer.strokeColor = [UIColor colorWithHexString:@"#03b3cc"].CGColor;
    
    [self.layer addSublayer:layer];
}

@end
