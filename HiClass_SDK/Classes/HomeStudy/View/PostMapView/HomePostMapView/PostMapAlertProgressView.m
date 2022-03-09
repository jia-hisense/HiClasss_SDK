//
//  PostMapAlertProgressView.m
//  iTest
//
//  Created by Sir_Jing on 2020/3/18.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import "PostMapAlertProgressView.h"

@interface PostMapAlertProgressView ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIProgressView * progressView;


@end

@implementation PostMapAlertProgressView

-(instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:CGRectMake(0, 0, 133, 73.6)]) {
        [self setupUI];
        [self createUI];
    }
    return self;
}

-(void)setupUI{
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height-6.6)  byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(4 ,4)];
    
    [maskPath moveToPoint:CGPointMake(self.bounds.size.width/2.0-6.6, self.bounds.size.height-6.6)];
    [maskPath addLineToPoint:CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height)];
    [maskPath addLineToPoint:CGPointMake(self.bounds.size.width/2.0+6.6, self.bounds.size.height-6.6)];

    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;

    maskLayer.fillColor = [UIColor whiteColor].CGColor;

    [self.layer addSublayer:maskLayer];

}

-(void)createUI {

    UIButton *closeBut = [[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width-5-12, 5, 12, 12)];
    [closeBut setImage:[UIImage imageNamed:@"进度小弹窗-关闭"] forState:UIControlStateNormal];
    [closeBut addTarget:self action:@selector(clickCloseBut:) forControlEvents:UIControlEventTouchUpInside];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, self.bounds.size.width-20, 20)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    self.titleLabel = titleLabel;

    UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(16, 47, self.bounds.size.width-32, 5)];
    progressView.progressTintColor = [UIColor colorWithRed:3/255.0 green:179/255.0 blue:204/255.0 alpha:1];
    progressView.tintColor = [UIColor colorWithRed:133/255.0 green:133/255.0 blue:133/255.0 alpha:1];
    progressView.progress = 0.5;
    progressView.layer.cornerRadius = 2.5;
    progressView.layer.masksToBounds = YES;
    self.progressView = progressView;

    [self addSubview:closeBut];
    [self addSubview:titleLabel];
    [self addSubview:progressView];

    // 测试
    titleLabel.text = @"iife";
}

-(void)setViewFrame:(CGRect)frame {

    CGFloat centerX = frame.origin.x + frame.size.width/2.0;
    CGFloat centerY = frame.origin.y - self.bounds.size.height/2.0;
    self.center = CGPointMake(centerX, centerY);
}

-(void)setProgress:(double)progress {

    _progress = progress;
    double pro = progress >= 100? 100:progress;
    _titleLabel.text = [NSString stringWithFormat:@"%@%.0f%%", NSLocalizableString(@"learningProcess", nil),pro];
    self.progressView.progress = pro/100;
}

-(void)clickCloseBut:(UIButton *)but {
    [self removeFromSuperview];
}

@end
