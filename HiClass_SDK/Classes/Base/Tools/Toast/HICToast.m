//
//  HICToast.m
//  swiftProject
//
//  Created by wangggang on 2020/1/10.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICToast.h"

#define DEFAULT_DISPLAY_DURATION    2.0
#define DEFAULT_DISPLAY_MARGIN_B    80.0

@interface HICToast () {
    UIButton *contentView;
    CGFloat  duration;
}

@end

@implementation HICToast

- (id)initWithText:(NSString *)text{
    if (self = [super init]) {
        NSInteger textLen = [text length];
        CGFloat textLabelWidth;
        if (textLen>20) {
            textLabelWidth = 292.0;
        } else {
            textLabelWidth = textLen*14.0+12.0;
        }
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(24*HIC_Toast_Divisor, 0, textLabelWidth, 14.0*(textLen/21+1)+22.0)];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.text = text;
        textLabel.textColor = [UIColor whiteColor];
        textLabel.font = [UIFont boldSystemFontOfSize:14.0];
        textLabel.numberOfLines = 0;

        contentView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, textLabel.frame.size.width+48*HIC_Toast_Divisor, textLabel.frame.size.height)];
        contentView.layer.cornerRadius = 5.0f;
        contentView.layer.borderWidth = 0.5f;
        contentView.layer.borderColor = [[UIColor grayColor] colorWithAlphaComponent:0.5].CGColor;
        contentView.backgroundColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.75];
        contentView.layer.cornerRadius = textLabel.frame.size.height/2;
        contentView.clipsToBounds = YES;
        [contentView addSubview:textLabel];
        contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [contentView addTarget:self action:@selector(toastTaped) forControlEvents:UIControlEventTouchDown];
        contentView.alpha = 0.0f;

        duration = DEFAULT_DISPLAY_DURATION;

    }
    return self;
}

-(void)toastTaped{
    [self hideAnimation];
}

-(void)hideAnimation{
    [UIView beginAnimations:@"hide" context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(dismissToast)];
    [UIView setAnimationDuration:0.3];
    contentView.alpha = 0.0f;
    [UIView commitAnimations];
}

-(void)dismissToast{
    [contentView removeFromSuperview];
}

- (void)setDuration:(CGFloat)showDuration{
    duration = showDuration;
}

-(void)showAnimation{
    [UIView beginAnimations:@"show" context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.3];
    contentView.alpha = 1.0f;
    [UIView commitAnimations];
}

- (void)show{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    contentView.center = window.center;
    [window  addSubview:contentView];
    [self showAnimation];
    [self performSelector:@selector(hideAnimation) withObject:nil afterDelay:duration];
}

- (void)showFromTopOffset:(CGFloat)top{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    contentView.center = CGPointMake(window.center.x, top + contentView.frame.size.height/2);
    [window  addSubview:contentView];
    [self showAnimation];
    [self performSelector:@selector(hideAnimation) withObject:nil afterDelay:duration];
}

- (void)showFromBottomOffset:(CGFloat)bottom{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    contentView.center = CGPointMake(window.center.x, [UIScreen mainScreen].bounds.size.height - (bottom + contentView.frame.size.height/2));
    [window  addSubview:contentView];
    [self showAnimation];
    [self performSelector:@selector(hideAnimation) withObject:nil afterDelay:duration];
}

#pragma mark - 对外封装的接口

+ (void)showWithText:(NSString *)text{
    [HICToast showWithText:text duration:DEFAULT_DISPLAY_DURATION];
}

+ (void)showWithText:(NSString *)text duration:(CGFloat)duration{
    HICToast *toast = [[HICToast alloc] initWithText:text];
    [toast setDuration:duration];
    [toast show];
}

+ (void)showWithText:(NSString *)text topOffset:(CGFloat)topOffset{
    [HICToast showWithText:text  topOffset:topOffset duration:DEFAULT_DISPLAY_DURATION];
}

+ (void)showWithText:(NSString *)text topOffset:(CGFloat)topOffset duration:(CGFloat)duration{
    HICToast *toast = [[HICToast alloc] initWithText:text];
    [toast setDuration:duration];
    [toast showFromTopOffset:topOffset];
}

+ (void)showWithText:(NSString *)text bottomOffset:(CGFloat)bottomOffset{
    [HICToast showWithText:text  bottomOffset:bottomOffset duration:DEFAULT_DISPLAY_DURATION];
}

+ (void)showWithText:(NSString *)text bottomOffset:(CGFloat)bottomOffset duration:(CGFloat)duration{
    HICToast *toast = [[HICToast alloc] initWithText:text];

    [toast setDuration:duration];
    [toast showFromBottomOffset:bottomOffset];
}

+ (void)showAtDefWithText:(NSString *)text {
    [HICToast showWithText:text bottomOffset:DEFAULT_DISPLAY_MARGIN_B duration:DEFAULT_DISPLAY_DURATION];
}

@end
