//
//  HICCustomerNetErrorView.m
//  HiClass
//
//  Created by 铁柱， on 2020/3/26.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICCustomerNetErrorView.h"

@interface HICCustomerNetErrorView ()

@property (nonatomic, copy) ClickAgain clickBlock;

@property (nonatomic, weak) UIView *parentView;

@end

@implementation HICCustomerNetErrorView

+(instancetype)createNetErrorWith:(UIView *)parentView clickBut:(ClickAgain)block {
    HICCustomerNetErrorView *view = [[HICCustomerNetErrorView alloc] initWithFrame:parentView.bounds];
    view.clickBlock = block;
    view.parentView = parentView;
    return view;
}

+(instancetype)createNetErrorWith:(UIView *)parentView frame:(CGRect)frame clickBut:(ClickAgain)block {
    HICCustomerNetErrorView *view = [[HICCustomerNetErrorView alloc] initWithFrame:frame];
    view.clickBlock = block;
    view.parentView = parentView;
    return view;
}

-(instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}

-(void)createView {

    CGFloat screenWidth = self.frame.size.width;
    CGFloat screenHeight = self.frame.size.height;
    CGFloat imageWidth = 110;
    CGFloat labelTotal = 31.f;

    CGFloat imageTop = screenHeight/2.0 - (imageWidth + labelTotal)/2.0 - 30;
    CGFloat imageLeft = screenWidth/2.0 - imageWidth/2.0;

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageLeft, imageTop, imageWidth, imageWidth)];
    imageView.image = [UIImage imageNamed:@"空白页-网络异常"];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, imageTop+imageWidth+8, screenWidth-40, 22)];
    label.text = NSLocalizableString(@"networkAnomaliesPrompt", nil);
    label.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];

    UIButton *but = [[UIButton alloc] initWithFrame:CGRectMake((screenWidth-90)/2.0, imageTop+imageWidth+8+22+10, 90, 40)];
    [but addTarget:self action:@selector(clickBut:) forControlEvents:UIControlEventTouchUpInside];
    [HICCommonUtils createGradientLayerWithBtn:but fromColor:[UIColor colorWithHexString:@"#00e2d8"] toColor:[UIColor colorWithHexString:@"#00c5e0"]];
    but.layer.cornerRadius = 4.f;
    but.layer.masksToBounds = YES;
    [but setTitle:NSLocalizableString(@"refresh", nil) forState:UIControlStateNormal];
    [but setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];

    [self addSubview:imageView];
    [self addSubview:label];
    [self addSubview:but];
    self.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
}

-(void)clickBut:(UIButton *)but {
    if (self.clickBlock) {
        self.clickBlock(0);
    }
    [self hiddenError];
}

-(void)showError {
    [self.parentView addSubview:self];
}
-(void)hiddenError {
    [self removeFromSuperview];
}
-(void)dealloc {
    DDLogDebug(@"调用析构函数！");
}
@end
