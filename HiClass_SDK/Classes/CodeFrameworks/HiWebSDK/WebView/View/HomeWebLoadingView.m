//
//  HomeWebLoadingView.m
//  HiClass
//
//  Created by WorkOffice on 2020/1/20.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HomeWebLoadingView.h"

@interface HomeWebLoadingView ()

@property (nonatomic, weak) UIView *parentView;

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation HomeWebLoadingView

+(instancetype)createLoadingViewWith:(CGRect)frame onView:(UIView *)parentView {

    HomeWebLoadingView *view = [[HomeWebLoadingView alloc] initWithFrame:frame];

    view.hidden = YES; // 默认隐藏
    [parentView addSubview:view];

    return view;
}

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createLoadingImageWith:frame];
    }
    return self;
}

-(void)createLoadingImageWith:(CGRect)frame {

    CGFloat viewWidth = frame.size.width;
    CGFloat viewHeight = frame.size.height;
    CGFloat backWidth = 122.f;
    CGFloat backHeight = 53.f;
    // 1. 创建一个黑色背景
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake((viewWidth-backWidth)/2, (viewHeight - backHeight)/2, backWidth, backHeight)];
    backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    [self addSubview:backView];
    backView.layer.masksToBounds = YES;
    backView.layer.cornerRadius = 4.f;

    // 2. 创建一个image
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 18.5, 16, 16)];
    imageView.image = [UIImage imageNamed:@"webSDK-loading-white"];
    [backView addSubview:imageView];
    
    // 3. 创建一个label
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(42, 18.5, backWidth-42, 16)];
    label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15.f];
    label.text = NSLocalizableString(@"onTheCross", nil);
    label.textColor = [UIColor whiteColor];
    [backView addSubview:label];

    self.iconImageView = imageView;

    __weak typeof(self) weakSelf = self;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf startAnimation];
    }];
    [self.timer setFireDate:[NSDate distantFuture]];
}

-(void)showLoadingView {

    dispatch_async(dispatch_get_main_queue(), ^{
        self.hidden = NO;
//        [self startAnimation];
        [self.timer setFireDate:[NSDate date]];
    });

}

-(void)hidenLoadingView {

    dispatch_async(dispatch_get_main_queue(), ^{
        self.hidden = YES;
//        [self stopAnimation];
        [self.timer setFireDate:[NSDate distantFuture]];
    });

}

-(void)startAnimation {

//    CABasicAnimation* rotationAnimation;
//
//    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0];
//    rotationAnimation.duration = 0.6;
//    rotationAnimation.cumulative = YES;
//    rotationAnimation.repeatCount = HUGE_VALF;
//
//    [self.iconImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    CGAffineTransform transform = self.iconImageView.transform;
    self.iconImageView.transform = CGAffineTransformRotate(transform, M_PI/5);
}

-(void)stopAnimation {
    [self.iconImageView.layer removeAnimationForKey:@"rotationAnimation"];
}

@end
