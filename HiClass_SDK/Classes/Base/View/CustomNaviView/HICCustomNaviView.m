//
//  HICCustomNaviView.m
//  HiClass
//
//  Created by Eddie Ma on 2020/2/21.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICCustomNaviView.h"

@interface HICCustomNaviView()

@property (nonatomic, strong) NSString *titleStr;
@property (nonatomic, strong) NSString *rightBtnName;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, assign) BOOL showBtnLine;
@end

@implementation HICCustomNaviView

- (instancetype)initWithTitle:(NSString *)title rightBtnName:(NSString * __nullable)rightBtnName  showBtnLine:(BOOL)showBtnLine {
    if (self = [super init]) {
        self.titleStr = title;
        self.rightBtnName = rightBtnName;
        self.showBtnLine = showBtnLine;
        [self createUI];
    }
    return self;
}
- (void)setHideLeftBtn:(BOOL)hideLeftBtn{
    if (hideLeftBtn) {
        self.goBackBtn.hidden = YES;
    }else{
        self.goBackBtn.hidden = NO;
    }
}
- (void)createUI {
    self.frame = CGRectMake(0, 0, HIC_ScreenWidth, HIC_NavBarHeight + HIC_StatusBar_Height);
    self.backgroundColor = [UIColor whiteColor];

    self.goBackBtn = [[UIButton alloc] init];
    [self addSubview:_goBackBtn];
    self.goBackBtn.frame = CGRectMake(0, HIC_StatusBar_Height, 12 + 16 + 16, HIC_NavBarHeight);
    self.goBackBtn.tag = 10000;
    [self.goBackBtn addTarget:self action:@selector(BtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.goBackBtn setImage:[UIImage imageNamed:@"返回"] forState:normal];

    self.titleLabel = [[UILabel alloc] init];
    [self addSubview:_titleLabel];
    CGSize titleSize = [HICCommonUtils sizeOfString:_titleStr stringWidthBounding:HIC_ScreenWidth - 44 * 2 font:18 stringOnBtn:NO fontIsRegular:NO];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.text = _titleStr;
    _titleLabel.font = FONT_MEDIUM_18;
    _titleLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    _titleLabel.frame = CGRectMake((HIC_ScreenWidth - titleSize.width)/2, (HIC_NavBarHeight - 25)/2 + HIC_StatusBar_Height, titleSize.width, 25);

    if ([NSString isValidStr:_rightBtnName]) {
        self.rightBtn = [[UIButton alloc] init];
        [self addSubview:_rightBtn];
        _rightBtn.frame = CGRectMake(HIC_ScreenWidth - (16 + 32 + 16), HIC_StatusBar_Height, 16 + 32 + 16, HIC_NavBarHeight);
        _rightBtn.tag = 20000;
        [_rightBtn addTarget:self action:@selector(BtnClicked:) forControlEvents:UIControlEventTouchUpInside];

        self.rightLabel = [[UILabel alloc] init];
        [_rightBtn addSubview:_rightLabel];
        _rightLabel.frame = CGRectMake(16, (HIC_NavBarHeight - 22.5)/2, 32, 22.5);
        _rightLabel.text = _rightBtnName;
        _rightLabel.textColor = [UIColor colorWithRed:3/255.0 green:179/255.0 blue:204/255.0 alpha:1/1.0];
        _rightLabel.font = FONT_MEDIUM_16
    }

    if (_showBtnLine) {
        UIView *naviBtmLine = [[UIView alloc] initWithFrame:CGRectMake(0, HIC_NavBarAndStatusBarHeight - 0.5, HIC_ScreenWidth, 0.5)];
        [self addSubview:naviBtmLine];
        naviBtmLine.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1/1.0];
    }
}

- (void)BtnClicked:(UIButton *)btn {
    if (btn.tag == 10000) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(leftBtnClicked)]) {
            [self.delegate leftBtnClicked];
        }
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(rightBtnClicked:)]) {
            [self.delegate rightBtnClicked:_rightLabel.text];
        }
    }
}

- (void)setRightBtnText:(NSString * __nullable)str {
    if ([NSString isValidStr:str]) {
        _rightBtn.hidden = NO;
         _rightLabel.text = str;
    } else {
        _rightBtn.hidden = YES;
    }
}

- (void)modifyTitleLabel:(NSString *)title {
    CGSize titleSize = [HICCommonUtils sizeOfString:title stringWidthBounding:HIC_ScreenWidth - 44 * 2 font:18 stringOnBtn:NO fontIsRegular:NO];
    _titleLabel.text = title;
    _titleLabel.frame = CGRectMake((HIC_ScreenWidth - titleSize.width)/2, (HIC_NavBarHeight - 25)/2, titleSize.width, 25);
}

@end
