//
//  HICForgetInputView.m
//  HiClass
//
//  Created by wangggang on 2019/12/31.
//  Copyright © 2019 jingxianglong. All rights reserved.
//

#import "HICForgetInputView.h"

#import <objc/runtime.h>

@interface HICForgetInputView()<UITextFieldDelegate>

// 1. 视图属性
// 手机号输入框
@property (nonatomic, strong) UITextField *phoneField;
// 密码输入框
@property (nonatomic, strong) UITextField *passwordField;

// 清空的按钮
@property (nonatomic, strong) UIButton *cleanBut;
// 发送短信按钮
@property (nonatomic, strong) UIButton *sendMsgBut;

// 2. 功能标识性属性
// 计时
@property (nonatomic, assign) NSInteger timeCount;
// 是否发送成功过短信验证码,主要是为了避免没有发送短信验证码随便输入信息就进入下一步的问题
@property (nonatomic, assign) BOOL isSendMsg;
// 保存赋值的block
@property (nonatomic, copy) ClickNextButBlock block;

@property (nonatomic, strong) UITextField *passTF;
@property (nonatomic, strong) UITextField *passConfirmTF;
@property (nonatomic, strong) UIButton *passShowBtn;
@property (nonatomic, strong) UIButton *passConfirmShowBtn;
@property (nonatomic, strong) UILabel *hintLabel;
@property (nonatomic, strong) UIView *devidedLine1;
@property (nonatomic, strong) UIView *devidedLine2;


@end

@implementation HICForgetInputView

// 构造方法
-(instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        // 创建页面
        [self createView];

        // 初始化数据
        self.isSendMsg = NO;
    }
    return self;
}

// 创建view
-(void)createView{
    
    // 1. 两个输入框
    self.phoneField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.phoneField.placeholder = NSLocalizableString(@"enterMobilePhoneNumber", nil);
    self.phoneField.font = FONT_REGULAR_17;
    self.phoneField.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneField.delegate = self;
    Ivar phoneIvar = class_getInstanceVariable([UITextField class], "_placeholderLabel");
    UILabel *confirmPhonePlaceholderLabel = object_getIvar(self.phoneField, phoneIvar);
    confirmPhonePlaceholderLabel.textColor = PLACEHOLDER_COLOR;
    self.phoneField.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];

    self.passwordField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.passwordField.placeholder = NSLocalizableString(@"inputVerificationCode", nil);
    self.passwordField.font = FONT_REGULAR_17;
    self.passwordField.keyboardType = UIKeyboardTypeNumberPad;
    self.passwordField.delegate = self;
    Ivar passwordIvar = class_getInstanceVariable([UITextField class], "_placeholderLabel");
    UILabel *confirmPassPlaceholderLabel = object_getIvar(self.passwordField, passwordIvar);
    confirmPassPlaceholderLabel.textColor = PLACEHOLDER_COLOR;
    self.passwordField.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];

    [self addSubview:self.phoneField];
    [self addSubview:self.passwordField];
    
    // 2. 两条线
    UILabel *phoneLine = [[UILabel alloc] initWithFrame:CGRectZero];
    phoneLine.backgroundColor = PLACEHOLDER_COLOR;
    UILabel *passwordLine = [[UILabel alloc] initWithFrame:CGRectZero];
    passwordLine.backgroundColor = PLACEHOLDER_COLOR;
    
    [self addSubview:phoneLine];
    [self addSubview:passwordLine];
    
    // 3. 清空按钮
    UIButton *cleanBut = [[UIButton alloc] initWithFrame:CGRectZero];
    self.cleanBut = cleanBut;
    [cleanBut setBackgroundImage:[UIImage imageNamed:@"bt-清空"] forState:UIControlStateNormal];
    [cleanBut addTarget:self action:@selector(clickCleanBut:) forControlEvents:UIControlEventTouchUpInside];
    cleanBut.hidden = YES; // 默认隐藏
    
    [self addSubview:cleanBut];
    
    // 4. 发送验证码按钮
    UIButton *sendMsgBut = [[UIButton alloc] initWithFrame:CGRectZero];
    self.sendMsgBut = sendMsgBut;
    [sendMsgBut setTitle:NSLocalizableString(@"obtainingVerificationCode", nil) forState:UIControlStateNormal];
    [sendMsgBut setTitleColor:[UIColor colorWithHexString:@"00BED7"] forState:UIControlStateNormal];
    [sendMsgBut setTitleColor:[UIColor red:161 green:230 blue:238 alpha:1] forState:UIControlStateDisabled];
    sendMsgBut.titleLabel.font = FONT_REGULAR_17;
    sendMsgBut.enabled = NO;
    [sendMsgBut addTarget:self action:@selector(clickSendMsgBut:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:sendMsgBut];

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
    UILabel *confirmPassPL = object_getIvar(self.passConfirmTF, confirmPassIvar);
    confirmPassPL.textColor = PLACEHOLDER_COLOR;
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
    
    // 5. 下一步的按钮
    UIButton *nextBut = [[UIButton alloc] initWithFrame:CGRectZero];
    [nextBut setTitle:NSLocalizableString(@"save", nil) forState:UIControlStateNormal];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"#00E2D8"].CGColor, (__bridge id)[UIColor colorWithHexString:@"#00C5E0"].CGColor];
    gradientLayer.locations = @[@0.0, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1.0, 0);
    gradientLayer.frame = CGRectMake(0, 0, HIC_ScreenWidth-80, 49);
    [nextBut.layer addSublayer:gradientLayer];
    nextBut.titleLabel.font = FONT_MEDIUM_18;
    nextBut.layer.cornerRadius = 4;
    nextBut.layer.masksToBounds = YES;
    [nextBut addTarget:self action:@selector(clickNextBut:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:nextBut];
    
    [self.phoneField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(40);
        make.right.equalTo(self.mas_right).offset(-59);
        make.height.offset(51);
        make.top.equalTo(self.mas_top).offset(0);
    }];
    
    [phoneLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneField.mas_bottom).offset(0.5);
        make.left.equalTo(self.mas_left).offset(40);
        make.right.equalTo(self.mas_right).offset(-40);
        make.height.offset(0.5);
    }];
    
    [self.passwordField  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(40);
        make.right.equalTo(self.mas_right).offset(-100-40-5);
        make.height.offset(51);
        make.top.equalTo(phoneLine.mas_top).offset(12);
    }];
    
    [passwordLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordField.mas_bottom);
        make.left.equalTo(self.mas_left).offset(40);
        make.right.equalTo(self.mas_right).offset(-40);
        make.height.offset(0.5);
    }];
    
    [cleanBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.phoneField.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-43);
        make.width.offset(16);
        make.height.offset(16);
    }];
    
    [sendMsgBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.passwordField.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-40);
        make.width.offset(100);
    }];

    [self.passTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(40);
        make.right.equalTo(self.mas_right).offset(-40);
        make.height.offset(51);
        make.top.equalTo(passwordLine.mas_top).offset(12);
    }];

    [self.passShowBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-42.5);
        make.centerY.equalTo(self.passTF);
        make.height.offset(20);
        make.width.offset(20);
    }];

    [self.devidedLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passTF.mas_bottom);
        make.left.equalTo(self.mas_left).offset(40);
        make.right.equalTo(self.mas_right).offset(-40);
        make.height.offset(0.5);
    }];

    [self.passConfirmTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(40);
        make.right.equalTo(self.mas_right).offset(-40);
        make.height.offset(51);
        make.top.equalTo(self.devidedLine1.mas_top).offset(12);
    }];

    [self.passConfirmShowBtn mas_updateConstraints:^(MASConstraintMaker *make) {
           make.right.equalTo(self).offset(-42.5);
           make.centerY.equalTo(self.passConfirmTF);
           make.height.offset(20);
           make.width.offset(20);
       }];


    [self.devidedLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passConfirmTF.mas_bottom);
        make.left.equalTo(self.mas_left).offset(40);
        make.right.equalTo(self.mas_right).offset(-40);
        make.height.offset(0.5);
    }];

    [self.hintLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.devidedLine2.mas_bottom).offset(8);
        make.left.equalTo(self).offset(40);
        make.right.equalTo(self).offset(-40);
        make.height.offset(20);
    }];
    
    [nextBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.hintLabel.mas_bottom).offset(36);
        make.left.equalTo(self.mas_left).offset(40);
        make.right.equalTo(self.mas_right).offset(-40);
        make.height.offset(49);
    }];
}

#pragma mark - 页面点击事件方法
-(void)clickCleanBut:(UIButton *)btn {
    
    self.phoneField.text = @"";
    // 判断当前phoneField是否为第一响应者
    if (!self.phoneField.isFirstResponder) {
        btn.hidden = YES;
        self.sendMsgBut.enabled = NO;
    }
    
}

-(void)clickSendMsgBut:(UIButton *)btn {
    
    // 当前按钮点击为发送短信验证码
    if ([NSString isPhoneNum:self.phoneField.text]) {
        // 首先是电话号码的输入框里有文字
        if(self.timer) {
            // 当前存在定时器 不能重复点击
            return;
        }
        // 1. 初始化计数、网络状态
        self.timeCount = 60;
        self.isSendMsg = NO;
        // 2. 设置重置but的title
        [btn setTitle:[NSString stringWithFormat:@"60s%@",NSLocalizableString(@"toObtain", nil)] forState:UIControlStateNormal];
        // 3. 初始化定时器
        __weak typeof(self) weakSelf = self;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.timeCount--;
            [btn setTitle:[NSString stringWithFormat:@"%lds%@", (long)strongSelf.timeCount,NSLocalizableString(@"toObtain", nil)] forState:UIControlStateNormal];
            if (strongSelf.timeCount < 0) {
                // 此时倒计时结束 -- 操作按钮
                [strongSelf.timer invalidate];
                strongSelf.timer = nil;
                [btn setTitle:NSLocalizableString(@"toObtain", nil) forState:UIControlStateNormal];
            }
        }];

        // 4. 网络请求
        [self getMsgFromSever];
    }else {
        // 此时获取验证码时手机号不正确
        [self endEditing:YES]; // 1. 结束编辑状态
        [HICToast showAtDefWithText:NSLocalizableString(@"enterCorrectPhoneNumber", nil)]; // 2. 通知用户
    }
    
}

-(void)clickNextBut:(UIButton *)btn {
    
    // 下一步的按钮点击事件 1.结束页面编辑操作
    [self textFieldEndEdit];

    // 2. 判断是否发送成功过短信验证码
    if (!self.isSendMsg) {
        // 没有正确获取短信验证码
        [HICToast showAtDefWithText:NSLocalizableString(@"obtainingVerificationCode", nil)];
        return;
    }

    NSString *phoneStr = self.phoneField.text;
    if (![NSString isValidStr: phoneStr] || ![NSString isPhoneNum: phoneStr]) {
        // 没有手机号 并且 手机号不正确
        [HICToast showAtDefWithText:NSLocalizableString(@"enterCorrectPhoneNumber", nil)];
        return;
    }

    NSString *passStr = self.passwordField.text;
    if (![NSString isValidStr:passStr]) {
        // 没有短信验证码
        [HICToast showAtDefWithText:NSLocalizableString(@"inputVerificationCode", nil)];
        return;
    }

    // 3. 给前端传值需要其进行页面跳转
    if (self.block) {
        self.block(phoneStr, passStr, self.passTF.text, self.passConfirmTF.text);
    }
}
#pragma mark - 页面功能性事件
// 结束页面编辑功能
-(void)textFieldEndEdit {
    
    [self.phoneField endEditing:YES];
    [self.passwordField endEditing:YES];
    
}

// 清空页面数据
-(void)cleanDataInput {

    [self.sendMsgBut setTitle:NSLocalizableString(@"obtainingVerificationCode", nil) forState:UIControlStateNormal];
    self.phoneField.text = @"";
    self.passwordField.text = @"";
    [self endEditing:YES];
}

// 页面点击下一步的具体操作
-(void)clickNextButBlock:(ClickNextButBlock)block {
    
    self.block = block; // 回调赋值，传递
    
}

#pragma mark - 页面的网络请求事件
-(void)getMsgFromSever {
    __weak typeof(self) weakSelf = self;
    [HICAPI getMsgFromSever:self.phoneField.text success:^(NSDictionary * _Nonnull responseObject) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        // 短信发送成功
        strongSelf.isSendMsg = YES;
    } failure:^(NSError * _Nonnull error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        // 短信发送失败 -- 是否需要停止倒计时
        strongSelf.isSendMsg = NO;
        // FIXME: 清空 sendBut的信息 -- 也可以不清楚 -- 多种情况
        if (strongSelf.timer) {
            // 防止过快转换 延时操作
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [strongSelf.timer invalidate];
                strongSelf.timer = nil;
                [strongSelf.sendMsgBut setTitle:NSLocalizableString(@"obtainingVerificationCode", nil) forState:UIControlStateNormal];
            });
        }
        if (error.code == 201019) {
            [HICToast showAtDefWithText:NSLocalizableString(@"phoneNumberDoesNotExist", nil)];
        }
    }];
}

#pragma mark - TextField的协议方法
// 将要开始编辑
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if (textField == self.phoneField) {
        self.cleanBut.hidden = NO;
        self.sendMsgBut.enabled = YES;
    }else if (textField == self.passwordField) {
        
    }
    
    return YES;
    
}

// 开始编辑的内容
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    
    
    return YES;
    
}

// 将要结束编辑
-(void)textFieldDidEndEditing:(UITextField *)textField {
    
    // 将要结束编辑
    if(textField == self.phoneField) {
        // 1. 电话号码的方法
        if (textField.text.length <= 0) {
            // 此时没有输入任何信息
            self.cleanBut.hidden = YES;
            if(!self.timer) {
                // 之前发送过验证码，因此可以不用配置不可点击
                self.sendMsgBut.enabled = NO;
            }
        }
    }
    
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
//        if (self.delegate && [self.delegate respondsToSelector:@selector(confirmBtnClickedWithPass:confirmPass:)]) {
//            [self.delegate confirmBtnClickedWithPass:self.passTF.text confirmPass:self.passConfirmTF.text];
//        }
    }
}



#pragma mark - 懒加载

@end
