//
//  HICNavgationBar.m
//  HiClass
//
//  Created by hisense on 2020/4/14.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import "HICNavgationBar.h"
#import "UIColor+OtherCreateColor.h"
#import "NSString+HICUtilities.h"

@interface  HICNavgationBar()

@property (nonatomic, weak) UIButton *leftBtn;
@property (nonatomic, weak) UILabel *titleLbl;
@property (nonatomic, weak) UIButton *rightBtn;

@property (nonatomic, weak) UIImageView *bgImgView;

@end

@implementation HICNavgationBar

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLbl.text = title;
}

- (instancetype)initWithTitle:(NSString *)title bgImage:(NSString *)bgImg leftBtnImage:(NSString *)leftImg rightBtnImg:(nullable NSString *)rightImg
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, HIC_ScreenWidth, HIC_NavBarAndStatusBarHeight);
        self.clipsToBounds = YES;

        UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:self.bounds];
        bgImgView.image = [UIImage imageNamed:bgImg];
        bgImgView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:bgImgView];
        self.bgImgView = bgImgView;

        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftBtn setImage:[UIImage imageNamed:leftImg] forState:UIControlStateNormal];
        [leftBtn setContentMode:UIViewContentModeScaleToFill];
        [self addSubview:leftBtn];
        self.leftBtn = leftBtn;
        [leftBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        leftBtn.tag = 101;

        UIEdgeInsets btnContentEdgeInsets = UIEdgeInsetsMake(11, 19, 11, 19);
        [leftBtn setImageEdgeInsets:btnContentEdgeInsets];

        if (rightImg) {
            UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [rightBtn setImage:[UIImage imageNamed:rightImg] forState:UIControlStateNormal];
            [rightBtn setContentMode:UIViewContentModeScaleToFill];
            [self addSubview:rightBtn];
            [rightBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
            rightBtn.tag = 102;
            self.rightBtn = rightBtn;
            [rightBtn setImageEdgeInsets:btnContentEdgeInsets];
        }

        UILabel *titleLabel = [[UILabel alloc] init];
        [self addSubview:titleLabel];
        titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:18];
        titleLabel.numberOfLines = 1;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        self.titleLbl = titleLabel;

        self.title = title;
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title bgColor:(UIColor *)bgColor leftBtnImage:(NSString *)leftImg rightBtnImg:(nullable NSString *)rightImg {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, HIC_ScreenWidth, HIC_NavBarAndStatusBarHeight);
        self.clipsToBounds = YES;
        self.backgroundColor = bgColor;

        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftBtn setImage:[UIImage imageNamed:leftImg] forState:UIControlStateNormal];
        [leftBtn setContentMode:UIViewContentModeScaleToFill];
        [self addSubview:leftBtn];
        self.leftBtn = leftBtn;
        [leftBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        leftBtn.tag = 101;

        UIEdgeInsets btnContentEdgeInsets = UIEdgeInsetsMake(11, 19, 11, 19);
        [leftBtn setImageEdgeInsets:btnContentEdgeInsets];

        if (rightImg) {
            UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [rightBtn setImage:[UIImage imageNamed:rightImg] forState:UIControlStateNormal];
            [rightBtn setContentMode:UIViewContentModeScaleToFill];
            [self addSubview:rightBtn];
            [rightBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
            rightBtn.tag = 102;
            self.rightBtn = rightBtn;
            [rightBtn setImageEdgeInsets:btnContentEdgeInsets];
        }

        UILabel *titleLabel = [[UILabel alloc] init];
        [self addSubview:titleLabel];
        titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:18];
        titleLabel.numberOfLines = 1;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        self.titleLbl = titleLabel;

        self.title = title;
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];

    _leftBtn.frame = CGRectMake(0, HIC_StatusBar_Height, 50, HIC_NavBarHeight);
    _rightBtn.frame = CGRectMake(HIC_ScreenWidth-50, CGRectGetMinY(_leftBtn.frame), 50, HIC_NavBarHeight);
    CGFloat titleX = CGRectGetMaxX(_leftBtn.frame);
    CGFloat titleY = CGRectGetMinY(_leftBtn.frame);
    CGFloat titleW = HIC_ScreenWidth-CGRectGetWidth(_leftBtn.frame)*2;
    CGFloat titleH = HIC_NavBarHeight;
    _titleLbl.frame = CGRectMake(titleX, titleY, titleW, titleH);


}


- (void)btnClicked:(UIButton *)button {
    if (button.tag == 101) {
        self.itemClicked(LeftTap);
    } else if (button.tag == 102) {
        self.itemClicked(RightTap);
    }

}

- (void)updateBgImageHeight:(CGFloat)height {

    self.bgImgView.height = height;

    [self.bgImgView layoutIfNeeded];
}


@end
