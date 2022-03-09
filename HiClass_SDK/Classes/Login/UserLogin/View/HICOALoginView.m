//
//  HICOALoginView.m
//  HiClass
//
//  Created by 铁柱， on 2020/1/2.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICOALoginView.h"
#import <objc/runtime.h>
@interface HICOALoginView ()<UITextFieldDelegate>
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *accountTF;
@property (nonatomic, strong) UITextField *passwordTF;
@property (nonatomic, strong) UIButton *cleanBut;
@property (nonatomic, strong) UIButton *passShowBtn;
@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, strong) UIView *devidedLine1;
@property (nonatomic, strong) UIView *devidedLine2;
@property (nonatomic, strong) UILabel *noAccountLabel;
@property (nonatomic, strong) UIButton *telLogin;
@end
@implementation HICOALoginView
- (instancetype)init {
    if (self = [super init]) {
        [self creatUI];
    }
    return self;
}
- (void)creatUI {
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = OALOGIN_TITLE;
    self.titleLabel.font = FONT_MEDIUM_23;
    self.titleLabel.textColor = MODIFY_PASS_TITLE_COLOR;
    [self addSubview:self.titleLabel];

    self.accountTF = [[UITextField alloc] init];
    self.accountTF.placeholder = NSLocalizableString(@"enterXinhongAccountOrEmailPrefix", nil);
//    self.accountTF.secureTextEntry = YES;
    Ivar accountIvar = class_getInstanceVariable([UITextField class], "_placeholderLabel");
    UILabel *accountPlaceholderLabel = object_getIvar(self.accountTF, accountIvar);
    accountPlaceholderLabel.textColor = PLACEHOLDER_COLOR;
    self.accountTF.font = FONT_REGULAR_17;
    self.accountTF.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    self.accountTF.delegate = self;
    [self addSubview:self.accountTF];
    // 3. 清空按钮
    self.cleanBut = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.cleanBut setBackgroundImage:[UIImage imageNamed:@"bt-清空"] forState:UIControlStateNormal];
    [self.cleanBut addTarget:self action:@selector(clickCleanBut:) forControlEvents:UIControlEventTouchUpInside];
    self.cleanBut.hidden = YES; // 默认隐藏
    [self addSubview:self.cleanBut];
    self.devidedLine1 = [[UIView alloc] init];
    self.devidedLine1.backgroundColor = PLACEHOLDER_COLOR;
    [self addSubview:self.devidedLine1];

    self.passwordTF = [[UITextField alloc] init];
    self.passwordTF.placeholder = NSLocalizableString(@"enterPassword", nil);
    self.passwordTF.secureTextEntry = YES;
    Ivar passwordIvar = class_getInstanceVariable([UITextField class], "_placeholderLabel");
    UILabel *confirmPassPlaceholderLabel = object_getIvar(self.passwordTF, passwordIvar);
    confirmPassPlaceholderLabel.textColor = PLACEHOLDER_COLOR;
    self.passwordTF.font = FONT_REGULAR_17;
    self.passwordTF.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    [self addSubview:self.passwordTF];
    
    self.passShowBtn = [[UIButton alloc] init];
    self.passShowBtn.tag = 11000;
    [self.passShowBtn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.passShowBtn setImage:[UIImage imageNamed:@"bt-密码不可见"] forState:UIControlStateNormal];
    [self addSubview:self.passShowBtn];

    self.devidedLine2 = [[UIView alloc] init];
    self.devidedLine2.backgroundColor = PLACEHOLDER_COLOR;
    [self addSubview:self.devidedLine2];
    
    self.confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.confirmBtn setTitle:NSLocalizableString(@"login", nil) forState: UIControlStateNormal];
    self.confirmBtn.titleLabel.font = FONT_MEDIUM_18;
    [self.confirmBtn setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    self.confirmBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.confirmBtn.layer.masksToBounds = YES;
    self.confirmBtn.layer.cornerRadius = 4;
    self.confirmBtn.tag = 11002;
    [self.confirmBtn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.confirmBtn];
    
    self.noAccountLabel = [[UILabel alloc] init];
    self.noAccountLabel.text = OABOTTOM_NOACCOUNT;
    self.noAccountLabel.font = FONT_REGULAR_14;
    if ([self.noAccountLabel.text isEqualToString:@"OAアカウントを持っていない？"]) {
        self.noAccountLabel.font = FONT_REGULAR_13;
    }
    self.noAccountLabel.textColor = BOTTOM_NOACCOUNTLABEL_COLOR;
    self.noAccountLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.noAccountLabel];

    self.telLogin = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.telLogin setTitle:OATEL_LOGIN forState:UIControlStateNormal];
     self.telLogin.titleLabel.font = FONT_REGULAR_14;
    [self.telLogin setBackgroundColor:[UIColor clearColor]];
    self.telLogin.tag = 11003;
    if ([self.noAccountLabel.text isEqualToString:@"OAアカウントを持っていない？"]) {
        self.telLogin.titleLabel.font = FONT_REGULAR_13;
    }
    [self.telLogin setTitleColor:BOTTOM_TELLOGIN_COLOR forState:UIControlStateNormal];
    [self.telLogin addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self  addSubview:self.telLogin];
}

- (void)updateConstraints {
    [super updateConstraints];

    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(36);
        make.left.equalTo(self).offset(40);
    }];

    [self.accountTF mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(40);
        make.left.equalTo(self).offset(40);
        make.right.equalTo(self).offset(-49.5);
        make.height.offset(51.5);
    }];

    [self.cleanBut mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-42.5);
        make.centerY.equalTo(self.accountTF);
        make.height.offset(20);
        make.width.offset(20);
    }];

    [self.devidedLine1 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.accountTF.mas_bottom);
        make.left.equalTo(self).offset(40);
        make.right.equalTo(self).offset(-40);
        make.height.offset(0.5);
    }];

    [self.passwordTF mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.devidedLine1.mas_bottom).offset(12);
        make.left.equalTo(self).offset(40);
        make.right.equalTo(self).offset(-49.5);
        make.height.offset(51.5);
    }];

    [self.passShowBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-42.5);
        make.centerY.equalTo(self.passwordTF);
        make.height.offset(20);
        make.width.offset(20);
    }];

    [self.devidedLine2 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordTF.mas_bottom);
        make.left.equalTo(self).offset(40);
        make.right.equalTo(self).offset(-40);
        make.height.offset(0.5);
    }];

    [self.confirmBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.devidedLine2.mas_bottom).offset(36);
        make.left.equalTo(self).offset(40);
        make.right.equalTo(self).offset(-40);
        make.height.offset(48.15);
    }];
    [self.noAccountLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.confirmBtn.mas_bottom).offset(16);
        make.left.equalTo(self).offset(HIC_ScreenWidth / 2 - 300);
        make.height.offset(20);
        make.width.offset(300);
        if ([self.noAccountLabel.text isEqualToString:@"OAアカウントを持っていない？"]) {
            make.left.equalTo(self).offset(HIC_ScreenWidth / 2 - 285);
        }
    }];
    [self.telLogin mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.confirmBtn.mas_bottom).offset(16);
        make.left.equalTo(self.noAccountLabel.mas_right);
        make.height.offset(20);
        make.width.offset(80);
        if ([self.noAccountLabel.text isEqualToString:@"OAアカウントを持っていない？"]) {
            make.width.offset(160);
        }
    }];

    [self layoutIfNeeded];
    [self updateUI];
}

- (void)updateUI {
    [HICCommonUtils createGradientLayerWithBtn:self.confirmBtn fromColor:[UIColor colorWithHexString:@"00E2D8" alpha:1.0f] toColor:[UIColor colorWithHexString:@"00C5E0" alpha:1.0f]];
}
#pragma mark - 点击事件
//账号输入框清空事件
-(void)clickCleanBut:(UIButton *)btn {
    self.accountTF.text = @"";
    // 判断当前phoneField是否为第一响应者
    if (!self.accountTF.isFirstResponder) {
        btn.hidden = YES;
    }
}
//按钮点击事件
- (void)clickButton:(UIButton *)btn {
    if (btn.tag == 11000) {
        btn.selected = !btn.selected;
        if (btn.selected) { // 按下去了就是明文
            NSString *tempPwdStr = self.passwordTF.text;
            self.passwordTF.text = @""; // 防止切换的时候光标偏移
            self.passwordTF.secureTextEntry = NO;
            self.passwordTF.text = tempPwdStr;
            [btn setImage:[UIImage imageNamed:@"bt-密码可见"] forState:UIControlStateNormal];
        } else { // 暗文
            NSString *tempPwdStr = self.passwordTF.text;
            self.passwordTF.text = @"";
            self.passwordTF.secureTextEntry = YES;
            self.passwordTF.text = tempPwdStr;
            [btn setImage:[UIImage imageNamed:@"bt-密码不可见"] forState:UIControlStateNormal];
        }
    } else if (btn.tag == 11002) {
        btn.selected = !btn.selected;

       if (self.delegate && [self.delegate respondsToSelector:@selector(confirmBtnClickedWithAccount:password:)]) {
           if([self.accountTF.text isEqualToString:@""] || [self.passwordTF.text isEqualToString:@""]){
               [HICToast showWithText:NSLocalizableString(@"enterCorrectAccountOrPassword", nil) topOffset:HIC_ScreenHeight /2 duration:2.0];

           }else{
               [self.delegate confirmBtnClickedWithAccount:self.accountTF.text password:self.passwordTF.text];
           }

       }
    } else {
        //手机号登录
        if (self.delegate && [self.delegate respondsToSelector:@selector(phoneNumLogin)]) {
            [self.delegate phoneNumLogin];
        }
    }
}
#pragma mark - TextField的协议方法
// 将要开始编辑
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if (textField == self.accountTF) {
    
        if(self.accountTF.text.length > 0){
            self.cleanBut.hidden = NO;
        }

    }
    
    return YES;
    
}

// 开始编辑的内容
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.accountTF) {
           if(self.accountTF.text.length > 0){
               self.cleanBut.hidden = NO;
           }

       }
    
    return YES;
    
}

// 将要结束编辑
-(void)textFieldDidEndEditing:(UITextField *)textField {

    // 将要结束编辑
    if(textField == self.accountTF) {
        if (textField.text.length <= 0) {
            // 此时没有输入任何信息
            self.cleanBut.hidden = YES;
        }
    }
    
}


@end
