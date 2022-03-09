//
//  HICModifyPassView.m
//  HiClass
//
//  Created by Eddie Ma on 2019/12/31.
//  Copyright © 2019 jingxianglong. All rights reserved.
//

#import <objc/runtime.h>
#import "HICModifyPassView.h"

@interface HICModifyPassView()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *hintLabel;
@property (nonatomic, strong) UITextField *passTF;
@property (nonatomic, strong) UITextField *passConfirmTF;
@property (nonatomic, strong) UIButton *passShowBtn;
@property (nonatomic, strong) UIButton *passConfirmShowBtn;
@property (nonatomic, strong) UIButton *confirmBtn;

@property (nonatomic, strong) UIView *devidedLine1;
@property (nonatomic, strong) UIView *devidedLine2;

@end

@implementation HICModifyPassView

- (instancetype)init {
    if (self = [super init]) {
        [self creatUI];
    }
    return self;
}

- (void)creatUI {
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = MODIFY_PASS_TITLE;
    self.titleLabel.font = FONT_MEDIUM_23
    self.titleLabel.textColor = MODIFY_PASS_TITLE_COLOR;
    [self addSubview:self.titleLabel];

    self.passTF = [[UITextField alloc] init];
    self.passTF.placeholder = NSLocalizableString(@"enterTheNewPassword", nil);
    self.passTF.secureTextEntry = YES;
    Ivar passIvar = class_getInstanceVariable([UITextField class], "_placeholderLabel");
    UILabel *passPlaceholderLabel = object_getIvar(self.passTF, passIvar);
    passPlaceholderLabel.textColor = PLACEHOLDER_COLOR;
    self.passTF.font = FONT_REGULAR_17;
    self.passTF.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    [self addSubview:self.passTF];

    self.passShowBtn = [[UIButton alloc] init];
    self.passShowBtn.tag = 10000;
    [self.passShowBtn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.passShowBtn setImage:[UIImage imageNamed:@"bt-密码不可见"] forState:UIControlStateNormal];
    [self addSubview:self.passShowBtn];

    self.devidedLine1 = [[UIView alloc] init];
    self.devidedLine1.backgroundColor = PLACEHOLDER_COLOR;
    [self addSubview:self.devidedLine1];

    self.passConfirmTF = [[UITextField alloc] init];
    self.passConfirmTF.placeholder = NSLocalizableString(@"confirmTheNewPassword", nil);
    self.passConfirmTF.secureTextEntry = YES;
    Ivar confirmPassIvar = class_getInstanceVariable([UITextField class], "_placeholderLabel");
    UILabel *confirmPassPlaceholderLabel = object_getIvar(self.passConfirmTF, confirmPassIvar);
    confirmPassPlaceholderLabel.textColor = PLACEHOLDER_COLOR;
    self.passConfirmTF.font = FONT_REGULAR_17;
    self.passConfirmTF.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    [self addSubview:self.passConfirmTF];

    self.passConfirmShowBtn = [[UIButton alloc] init];
    self.passConfirmShowBtn.tag = 10001;
    [self.passConfirmShowBtn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.passConfirmShowBtn setImage:[UIImage imageNamed:@"bt-密码不可见"] forState:UIControlStateNormal];
    [self addSubview:self.passConfirmShowBtn];

    self.devidedLine2 = [[UIView alloc] init];
    self.devidedLine2.backgroundColor = PLACEHOLDER_COLOR;
    [self addSubview:self.devidedLine2];

    self.hintLabel = [[UILabel alloc] init];
    self.hintLabel.text = MODIFY_PASS_HINT;
    self.hintLabel.font = FONT_REGULAR_14;
    self.hintLabel.textColor = PLACEHOLDER_COLOR;
    [self addSubview:self.hintLabel];

    self.confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.confirmBtn setTitle:NSLocalizableString(@"save", nil) forState: UIControlStateNormal];
    self.confirmBtn.titleLabel.font = FONT_MEDIUM_18;
    [self.confirmBtn setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    self.confirmBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.confirmBtn.layer.masksToBounds = YES;
    self.confirmBtn.layer.cornerRadius = 4;
    self.confirmBtn.tag = 10002;
    [self.confirmBtn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.confirmBtn];

}

- (void)updateConstraints {
    [super updateConstraints];

    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(36);
        make.left.equalTo(self).offset(40);
    }];

    [self.passTF mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(40);
        make.left.equalTo(self).offset(40);
        make.right.equalTo(self).offset(-49.5);
        make.height.offset(51.5);
    }];

    [self.passShowBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-42.5);
        make.centerY.equalTo(self.passTF);
        make.height.offset(20);
        make.width.offset(20);
    }];

    [self.devidedLine1 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passTF.mas_bottom);
        make.left.equalTo(self).offset(40);
        make.right.equalTo(self).offset(-40);
        make.height.offset(0.5);
    }];

    [self.passConfirmTF mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.devidedLine1.mas_bottom).offset(12);
        make.left.equalTo(self).offset(40);
        make.right.equalTo(self).offset(-49.5);
        make.height.offset(51.5);
    }];

    [self.passConfirmShowBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-42.5);
        make.centerY.equalTo(self.passConfirmTF);
        make.height.offset(20);
        make.width.offset(20);
    }];

    [self.devidedLine2 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passConfirmTF.mas_bottom);
        make.left.equalTo(self).offset(40);
        make.right.equalTo(self).offset(-40);
        make.height.offset(0.5);
    }];

    [self.hintLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.devidedLine2.mas_bottom).offset(8);
        make.left.equalTo(self).offset(40);
        make.right.equalTo(self).offset(-40);
        make.height.offset(20);
    }];

    [self.confirmBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.hintLabel.mas_bottom).offset(36);
        make.left.equalTo(self).offset(40);
        make.right.equalTo(self).offset(-40);
        make.height.offset(48.15);
    }];

    [self layoutIfNeeded];
    [self updateUI];
}

- (void)updateUI {
    [HICCommonUtils createGradientLayerWithBtn:self.confirmBtn fromColor:[UIColor colorWithHexString:@"00E2D8" alpha:1.0f] toColor:[UIColor colorWithHexString:@"00C5E0" alpha:1.0f]];
}

- (void)clickButton:(UIButton *)btn {
    if (btn.tag == 10000) {
        btn.selected = !btn.selected;
        if (btn.selected) { // 按下去了就是明文
            NSString *tempPwdStr = self.passTF.text;
            self.passTF.text = @""; // 防止切换的时候光标偏移
            self.passTF.secureTextEntry = NO;
            self.passTF.text = tempPwdStr;
            [btn setImage:[UIImage imageNamed:@"bt-密码可见"] forState:UIControlStateNormal];
        } else { // 暗文
            NSString *tempPwdStr = self.passTF.text;
            self.passTF.text = @"";
            self.passTF.secureTextEntry = YES;
            self.passTF.text = tempPwdStr;
            [btn setImage:[UIImage imageNamed:@"bt-密码不可见"] forState:UIControlStateNormal];
        }
    } else if (btn.tag == 10001) {
        btn.selected = !btn.selected;
        if (btn.selected) { // 按下去了就是明文
            NSString *tempPwdStr = self.passConfirmTF.text;
            self.passConfirmTF.text = @""; // 防止切换的时候光标偏移
            self.passConfirmTF.secureTextEntry = NO;
            self.passConfirmTF.text = tempPwdStr;
            [btn setImage:[UIImage imageNamed:@"bt-密码可见"] forState:UIControlStateNormal];
        } else { // 暗文
            NSString *tempPwdStr = self.passConfirmTF.text;
            self.passConfirmTF.text = @"";
            self.passConfirmTF.secureTextEntry = YES;
            self.passConfirmTF.text = tempPwdStr;
            [btn setImage:[UIImage imageNamed:@"bt-密码不可见"] forState:UIControlStateNormal];
        }
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(confirmBtnClickedWithPass:confirmPass:)]) {
            [self.delegate confirmBtnClickedWithPass:self.passTF.text confirmPass:self.passConfirmTF.text];
        }
    }
}

@end
