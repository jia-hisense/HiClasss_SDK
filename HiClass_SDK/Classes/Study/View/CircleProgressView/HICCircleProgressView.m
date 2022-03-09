//
//  HICCircleProgressView.m
//  HiClass
//
//  Created by Eddie Ma on 2020/2/4.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICCircleProgressView.h"

@interface HICCircleProgressView ()

// 圆环底层视图
@property (nonatomic, strong) UIView *bgView;
// 进度条
@property (nonatomic,strong) CAShapeLayer *progressLayer;

@end


@implementation HICCircleProgressView

- (UIView *)bgView{
    if (_bgView == nil) {
        _bgView = [[UIView alloc]init];
    }
    return _bgView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //创建基本视图
        [self createSubview];
        //创建路径及layer
        [self createLayerPath];
    }
    return self;
}

- (void)createSubview{
    [self addSubview:self.bgView];
//    [self addSubview:self.titleLab];
//    [self addSubview:self.progressLab];
//    [self addSubview:self.pointView];

    self.bgView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
//    self.titleLab.frame = CGRectMake(53, 63, 50, 15);
//    self.progressLab.frame = CGRectMake(53, 80, 120, 40);
//    self.pointView.frame = CGRectMake((lineWH-11)/2, 3, 11, 11);
}

- (void)createLayerPath{
    //贝塞尔曲线画圆弧
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2) radius:self.frame.size.height/2 - 2 startAngle:-M_PI/2 endAngle:3*M_PI/2 clockwise:YES];
    //设置颜色
    [[UIColor colorWithHexString:@"#E6E6E6"] set];
    circlePath.lineWidth = 3;
    //开始绘图
    [circlePath stroke];

    //创建背景视图
    CAShapeLayer *bgLayer = [CAShapeLayer layer];
    bgLayer.frame = self.bounds;
    bgLayer.fillColor = [UIColor clearColor].CGColor;//填充色 - 透明
    bgLayer.lineWidth = 3;//线条宽度
    bgLayer.strokeColor = [UIColor colorWithHexString:@"#E6E6E6"].CGColor;//线条颜色
    bgLayer.strokeStart = 0;//起始点
    bgLayer.strokeEnd = 1;//终点
    bgLayer.lineCap = kCALineCapRound;//让线两端是圆滑的状态
    bgLayer.path = circlePath.CGPath;//这里就是把背景的路径设为之前贝塞尔曲线的那个路径
    [self.bgView.layer addSublayer:bgLayer];

    //创建进度条视图
    _progressLayer = [CAShapeLayer layer];
    _progressLayer.frame = self.bounds;
    _progressLayer.fillColor = [UIColor clearColor].CGColor;
    _progressLayer.lineWidth = 3;
    _progressLayer.lineCap = kCALineCapRound;
    _progressLayer.strokeColor = [UIColor colorWithHexString:@"#C8A159"].CGColor;
    _progressLayer.strokeStart = 0;
    _progressLayer.strokeEnd = 0;
    _progressLayer.path = circlePath.CGPath;
    [self.bgView.layer addSublayer:_progressLayer];

    //创建渐变色图层
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;
    [self.bgView.layer addSublayer:gradientLayer];

    //#C8A159 #EBD6AB  C6A05D
    CAGradientLayer *leftGradientLayer = [CAGradientLayer layer];
    leftGradientLayer.frame = CGRectMake(0, 0, self.frame.size.width/2, self.frame.size.height);
    [leftGradientLayer setColors:[NSArray arrayWithObjects:(id)[UIColor colorWithHexString:@"#00E2D8"].CGColor, (id)[UIColor colorWithHexString:@"#00C5E0"].CGColor, nil]];
    [leftGradientLayer setLocations:@[@0.0,@1.0]];
    [leftGradientLayer setStartPoint:CGPointMake(0, 0)];
    [leftGradientLayer setEndPoint:CGPointMake(0, 1)];
    [gradientLayer addSublayer:leftGradientLayer];

    CAGradientLayer *rightGradientLayer = [CAGradientLayer layer];
    rightGradientLayer.frame = CGRectMake(self.frame.size.width/2, 0, self.frame.size.width/2, self.frame.size.height);
    [rightGradientLayer setColors:[NSArray arrayWithObjects:(id)[UIColor colorWithHexString:@"#00E2D8"].CGColor, (id)[UIColor colorWithHexString:@"#00C5E0"].CGColor, nil]];
    [rightGradientLayer setLocations:@[@0.0,@1.0]];
    [rightGradientLayer setStartPoint:CGPointMake(0, 0)];
    [rightGradientLayer setEndPoint:CGPointMake(0, 1)];
    [gradientLayer addSublayer:rightGradientLayer];
    [gradientLayer setMask:_progressLayer];
}

- (void)resetProgressStatus {
    [self.progressLayer removeAllAnimations];
    self.progressLayer.strokeEnd = 0;
}

- (void)updateProgressStatus:(CGFloat)percent {
    [self.progressLayer removeAllAnimations];
    self.progressLayer.strokeEnd = percent;
}


@end
