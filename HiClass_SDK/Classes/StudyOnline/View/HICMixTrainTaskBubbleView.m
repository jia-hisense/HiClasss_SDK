//
//  HICMixTrainTaskBubbleView.m
//  HiClass
//
//  Created by WorkOffice on 2020/6/16.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import "HICMixTrainTaskBubbleView.h"
@interface HICMixTrainTaskBubbleView()
@property (nonatomic ,strong)UIBezierPath *maskPath;
@property (nonatomic ,strong)UILabel *titleLabel;
@end
@implementation HICMixTrainTaskBubbleView
-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}
- (void)setFillColor:(UIColor *)fillColor{
    [self setupUIWithColor:fillColor];
    [self createUI];
}
-(void)setupUIWithColor:(UIColor*)color{
    self.maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height-6.6)  byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(4 ,4)];
    
    [_maskPath moveToPoint:CGPointMake(self.bounds.size.width/2.0-6.6, self.bounds.size.height-6.6)];
    [_maskPath addLineToPoint:CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height)];
    [_maskPath addLineToPoint:CGPointMake(self.bounds.size.width/2.0+6.6, self.bounds.size.height-6.6)];

    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = _maskPath.CGPath;
    maskLayer.fillColor = color.CGColor;
    [self.layer addSublayer:maskLayer];

}
- (void)createUI{
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(4, 6, self.width - 8, self.height - 17)];
    _titleLabel.textColor = UIColor.whiteColor;
    _titleLabel.numberOfLines = 2;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = FONT_REGULAR_13;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    [self addGestureRecognizer:tap];
    self.userInteractionEnabled = YES;
    [self addSubview:_titleLabel];
}
-(void)setTitle:(NSString *)title{
    _titleLabel.text = title;
}
-(void)setViewFrame:(CGRect)frame {
    CGFloat centerX = frame.origin.x + frame.size.width/2.0;
    CGFloat centerY = frame.origin.y - self.bounds.size.height/2.0;
    self.center = CGPointMake(centerX, centerY);
}
-(void)tap{
    if ([self.delegate respondsToSelector:@selector(clickToJump)]) {
        [self.delegate clickToJump];
    }
}
@end
