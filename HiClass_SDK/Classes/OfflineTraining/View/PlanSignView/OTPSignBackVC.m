//
//  OTPSignBackVC.m
//  HiClass
//
//  Created by 铁柱， on 2020/4/17.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "OTPSignBackVC.h"

#define SignBackVC_WidthRate(x) (x/375.0 * HIC_ScreenWidth)
#define SignBackVC_HeightRate(y) (y/587.0 * HIC_ScreenHeight)

@interface OTPSignBackVC ()

@end

@implementation OTPSignBackVC
#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = UIColor.whiteColor;
    // 创建导航条
    [self createNav];
    // 创建签到页面
    [self createSignView];
}

#pragma mark - 创建页面
-(void)createNav {

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, HIC_StatusBar_Height, HIC_ScreenWidth, 44)];
    [self.view addSubview:view];
    UIButton *but = [[UIButton alloc] initWithFrame:CGRectMake(5, 0, 44, 44)];
    [but setImage:[UIImage imageNamed:@"关闭弹窗"] forState:UIControlStateNormal];
    [but addTarget:self action:@selector(clickCloseView:) forControlEvents:UIControlEventTouchUpInside];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(54, 0, HIC_ScreenWidth-54*2, 44)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor colorWithHexString:@"#181818"];
    titleLabel.font = FONT_MEDIUM_18;
    titleLabel.text = NSLocalizableString(@"attendance", nil);

    [view addSubview:but];
    [view addSubview:titleLabel];
}

-(void)createSignView {
    // 1. 总体背景
    UIScrollView *backView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, HIC_NavBarAndStatusBarHeight, HIC_ScreenWidth, HIC_ScreenHeight-HIC_NavBarAndStatusBarHeight-HIC_BottomHeight)];
    backView.backgroundColor = [UIColor colorWithHexString:@"#f8f8f8"];
    [self.view addSubview:backView];

    CGFloat rateWidth = 343/375.0;
    CGFloat rateHeight = 450/587.0;
    CGFloat width = rateWidth * HIC_ScreenWidth;
    CGFloat height = rateHeight * HIC_ScreenHeight;
    UIView *signBackView = [[UIView alloc] initWithFrame:CGRectMake(16, 16, width, height)];
    signBackView.layer.cornerRadius = 5.f;
    signBackView.layer.masksToBounds = YES;
    signBackView.backgroundColor = UIColor.whiteColor;

    if (height > backView.height) {
        [backView setContentSize:CGSizeMake(0, height+50)];
    }
    // 2. 顶部位置信息背景 - 时间
    CGFloat imageHeight = SignBackVC_HeightRate(180);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, imageHeight)];
    imageView.backgroundColor = UIColor.redColor;
    [signBackView addSubview:imageView];

    UILabel *signTopTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, SignBackVC_HeightRate(113), width, 31)];
    signTopTimeLabel.textColor = UIColor.whiteColor;
    signTopTimeLabel.font = FONT_MEDIUM_22;
    signTopTimeLabel.textAlignment = NSTextAlignmentCenter;
    [signBackView addSubview:signTopTimeLabel];

    // 3. 底部位置信息背景
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, imageHeight, width, SignBackVC_HeightRate(270))];
    [signBackView addSubview:bottomView];

    // 3.1 标题类型
    UILabel *iconLabel = [[UILabel alloc] initWithFrame:CGRectMake(SignBackVC_WidthRate(16), SignBackVC_HeightRate(20), 32, 22.5)];
    iconLabel.textColor = [UIColor colorWithHexString:@"#4A90E2"];
    iconLabel.font = FONT_REGULAR_16;
    iconLabel.text = NSLocalizableString(@"course", nil);
    // 3.2 标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SignBackVC_WidthRate(16)+32+SignBackVC_WidthRate(5), SignBackVC_HeightRate(20), width-(SignBackVC_WidthRate(16)+32+SignBackVC_WidthRate(5))-SignBackVC_WidthRate(16), 22.5)];
    titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    titleLabel.font = FONT_REGULAR_16;

    // 3.3 时间维度
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(SignBackVC_WidthRate(16), SignBackVC_HeightRate(62.5), width-SignBackVC_WidthRate(16)*2, 20)];
    timeLabel.textColor = [UIColor colorWithHexString:@"#858585"];
    timeLabel.font = FONT_REGULAR_14;

    // 3.4 位置维度 - 查看位置信息
    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    addressLabel.textColor = [UIColor colorWithHexString:@"#858585"];
    addressLabel.font = FONT_REGULAR_14;
    UIButton *addressBut = [[UIButton alloc] initWithFrame:CGRectZero];
    [addressBut setTitle:[NSString stringWithFormat:@"%@>",NSLocalizableString(@"checkSignInRange", nil)] forState:UIControlStateNormal];
    [addressBut setTitleColor:[UIColor colorWithHexString:@"#00E2D8"] forState:UIControlStateNormal];
    addressBut.titleLabel.font = FONT_REGULAR_14;

    [bottomView addSubview:iconLabel];
    [bottomView addSubview:titleLabel];
    [bottomView addSubview:timeLabel];
    [bottomView addSubview:addressLabel];
    [bottomView addSubview:addressBut];

    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomView.mas_left).offset(SignBackVC_WidthRate(16));
        make.top.equalTo(timeLabel.mas_bottom).offset(SignBackVC_HeightRate(5));
        make.right.lessThanOrEqualTo(bottomView.mas_right).offset(-120);
    }];
    [addressBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addressLabel.mas_right).offset(SignBackVC_WidthRate(10));
        make.top.equalTo(timeLabel.mas_bottom).offset(SignBackVC_HeightRate(5));
        make.height.offset(20);
    }];

    // 3.5 签到按钮 -- 成功展示信息
    UIView *signButView = [[UIView alloc] initWithFrame:CGRectMake(SignBackVC_WidthRate(16), SignBackVC_HeightRate(191), width - SignBackVC_WidthRate(16)*2, 48)];
    signButView.layer.cornerRadius = 5.f;
    signButView.layer.masksToBounds = YES;
    signButView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    [bottomView addSubview:signButView];

    UIButton *signBut = [[UIButton alloc]initWithFrame:signButView.bounds];
    [HICCommonUtils createGradientLayerWithBtn:signBut fromColor:[UIColor colorWithHexString:@"#00E2D8"] toColor:[UIColor colorWithHexString:@"#00C5E0"]];
    [signBut setTitle:NSLocalizableString(@"signInImmediately", nil) forState:UIControlStateNormal];
    [signBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    signBut.titleLabel.font = FONT_MEDIUM_18;
    [signBut addTarget:self action:@selector(clickSignBut:) forControlEvents:UIControlEventTouchUpInside];

    UIImageView *iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(12, 15, 18, 18)];
    [iconImage setImage:[UIImage imageNamed:@"勾选"]];
    UILabel *successLabel = [[UILabel alloc] initWithFrame:CGRectMake(iconImage.Y+iconImage.width+5, 13, 110, 22.5)];
    successLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    successLabel.font = FONT_MEDIUM_16;
    successLabel.text = NSLocalizableString(@"signInSuccessfully", nil);

    UILabel *signTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(signButView.width-50-20, 11, 60, 22.5)];
    signTimeLabel.textAlignment = NSTextAlignmentRight;
    signTimeLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    signTimeLabel.font = FONT_MEDIUM_16;

    [signButView addSubview:iconImage];
    [signButView addSubview:successLabel];
    [signButView addSubview:signTimeLabel];
    [signButView addSubview:signBut]; // 盖在最顶部

    [backView addSubview:signBackView];

    // 测试
    addressLabel.text = [NSString stringWithFormat:@"%@：%@",NSLocalizableString(@"checkInPlace", nil),NSLocalizableString(@"noLocationDetected", nil)];
    titleLabel.text = NSLocalizableString(@"projectName", nil);
    timeLabel.text = @"签到时间：209000000";
    signTimeLabel.text = @"09098";
    signTopTimeLabel.text = @"0090939900";
    [self.view updateConstraintsIfNeeded];
}

#pragma mark - 页面的点击事件
-(void)clickCloseView:(UIButton *)but {
    [self dismissViewControllerAnimated:YES completion:^{

    }];
}

-(void)clickSignBut:(UIButton *)but {
    but.hidden = YES; // 签到
}

@end
