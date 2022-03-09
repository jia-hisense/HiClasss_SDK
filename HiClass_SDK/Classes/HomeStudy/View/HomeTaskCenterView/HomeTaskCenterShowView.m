//
//  HomeTaskCenterShowView.m
//  iTest
//
//  Created by Sir_Jing on 2020/3/16.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import "HomeTaskCenterShowView.h"

@implementation HomeTaskCenterShowView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}

-(void)createView {

    CGFloat statuBarHeight = UIApplication.sharedApplication.statusBarFrame.size.height;
    CGFloat screenWidth = HIC_ScreenWidth;

    CGFloat titleTop = statuBarHeight + 35;
    CGFloat titleHeight = 30;

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, titleTop, screenWidth - 100*2, titleHeight)];
    titleLabel.text = NSLocalizableString(@"taskCenter", nil);
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:21];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = UIColor.blackColor;

    titleTop += (titleHeight + 4);
    CGFloat chileTitleHeight = 21;
    UILabel *chileTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, titleTop, screenWidth-40*2, chileTitleHeight)];
    chileTitleLabel.text = NSLocalizableString(@"quickAccess", nil);
    chileTitleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    chileTitleLabel.textAlignment = NSTextAlignmentCenter;
    chileTitleLabel.textColor = [UIColor colorWithRed:133/255.0 green:133/255.0 blue:133/255.0 alpha:1];

    [self addSubview:titleLabel];
    [self addSubview:chileTitleLabel];

    CGFloat backBottom = statuBarHeight > 20? 30:0;
    CGFloat rateImage = 750/379.0;
    CGFloat backImageHeight = screenWidth/rateImage;
    UIImageView *butBackView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-backBottom-backImageHeight, screenWidth, backImageHeight)];
    [butBackView setImage:[UIImage imageNamed:@"初始页底部装饰"]];
    [self addSubview:butBackView];

    titleTop += (chileTitleHeight + 20);
    CGFloat viewHeight = 60.f;
    CGFloat spaceHeight = 10.f;

    NSArray *titleArray = @[NSLocalizableString(@"testCenter", nil), NSLocalizableString(@"trainingManagement", nil), NSLocalizableString(@"signUp", nil), NSLocalizableString(@"questionnaire", nil),
        NSLocalizableString(@"live", nil)];
    NSArray *imageArray = @[@"考试中心",@"培训管理",@"报名", @"问卷",
        @"直播大图标"];
    
    NSArray *contentArray = @[NSLocalizableString(@"managementTest", nil), NSLocalizableString(@"referTrainingTasks", nil), NSLocalizableString(@"allItemsAreHere", nil), NSLocalizableString(@"completeQuestionnaire", nil),
        NSLocalizableString(@"goodShare", nil)];
    for (NSInteger i = 0; i < 5; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, titleTop+(viewHeight+20+spaceHeight)*i, screenWidth, viewHeight+20)];
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(40, 10, viewHeight, viewHeight)];
        iconImageView.image = [UIImage imageNamed:imageArray[i]];

        UILabel *iconTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40+viewHeight+20, 10, screenWidth - (40+viewHeight+20) - 40, viewHeight/2.f-10)];
        
        iconTitleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:18];
        iconTitleLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        iconTitleLabel.text = titleArray[i];
        
        UILabel *contentTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40+viewHeight+20, viewHeight/2.0, screenWidth - (40+viewHeight+20) - 40, viewHeight/2.f+20)];
        contentTitleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        contentTitleLabel.textColor = [UIColor colorWithRed:133/255.0 green:133/255.0 blue:133/255.0 alpha:1];
        contentTitleLabel.numberOfLines = 0;
        contentTitleLabel.text = contentArray[i];
        if (i != 1) {
            //1.获取frame值
            CGRect originFrame = iconTitleLabel.frame;
            originFrame.origin.y += 8;
            iconTitleLabel.frame = originFrame;
            originFrame = contentTitleLabel.frame;
            originFrame.origin.y += 10;
            contentTitleLabel.frame = originFrame;
            
            contentTitleLabel.height = 25;
        }

        [view addSubview:iconImageView];
        [view addSubview:iconTitleLabel];
        [view addSubview:contentTitleLabel];

        [self addSubview:view];
    }

    CGFloat bottom = statuBarHeight > 20? 30+36.4:36.4;
    CGFloat butHeight = 50;
    CGFloat butY = self.frame.size.height - bottom - butHeight;

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(46.2, butY, screenWidth-46.2*2, butHeight)];
    [self addColorsWith:button colors:@[(__bridge id)[UIColor colorWithRed:0.0 green:226/255.0 blue:216/255.0 alpha:1].CGColor,
                                        (__bridge id)[UIColor colorWithRed:0.0 green:197/255.0 blue:224/255.0 alpha:1].CGColor]];
    [self addSubview:button];
    [button addTarget:self action:@selector(clickJoinBut:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:NSLocalizableString(@"enterMissionCenter", nil) forState:UIControlStateNormal];
    button.layer.cornerRadius = 4;
    button.layer.masksToBounds = YES;
    button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:17];

    self.backgroundColor = [UIColor whiteColor];
}

-(void)addColorsWith:(UIView *)view colors:(NSArray *)colors  {

    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = view.bounds;
    [view.layer insertSublayer:gradientLayer atIndex:0];
    gradientLayer.startPoint = CGPointMake(0, 1);
    gradientLayer.endPoint = CGPointMake(1, 1);
    gradientLayer.colors = colors;
    gradientLayer.locations = @[@(0.0f), @(1.0f)];
}

-(void)clickJoinBut:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(enter)]) {
        [self.delegate enter];
    }
    // 点击进入
    self.hidden = YES;
    [self removeFromSuperview];
}

@end
