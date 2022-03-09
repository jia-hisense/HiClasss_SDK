//
//  HICModifyPassVC.m
//  HiClass
//
//  Created by Eddie Ma on 2019/12/31.
//  Copyright © 2019 jingxianglong. All rights reserved.
//

#import <HIClassSwift_SDK/HIClassSwift_SDK.h>
#import "HICNetModel.h"
#import "HICModifyPassVC.h"
#import "HICModifyPassView.h"
#import "HICLoginBottomImageView.h"

static NSString *logName = @"[HIC][MPVC]";

@interface HICModifyPassVC ()<HICModifyPassViewDelegate> {
    HICSDKHelper * _helper;
}
@property (nonatomic, strong) HICModifyPassView *mpView;
@property (nonatomic, strong) HICLoginBottomImageView *btmView;
@property (nonatomic, strong) UIButton *backBtn;
@end


@implementation HICModifyPassVC

#pragma mark - - - mpView getter
- (HICModifyPassView *)mpView {
    if (!_mpView) {
        _mpView = [[HICModifyPassView alloc] init];
        _mpView.delegate = self;
    }
    return _mpView;
}

#pragma mark - - - backBtn getter
- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [[UIButton alloc] init];
        [_backBtn addTarget:self action:@selector(clickButton) forControlEvents:UIControlEventTouchUpInside];
        [_backBtn setImage:[UIImage imageNamed:@"bt-back"] forState:UIControlStateNormal];
    }
    return _backBtn;
}

#pragma mark - - - btnView getter
- (HICLoginBottomImageView *)btmView {
    if (!_btmView) {
        _btmView = [[HICLoginBottomImageView alloc] init];
    }
    return _btmView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self createUI];
    [self updateViewConstraints];
}

- (void)initData {
    _helper = [[HICSDKHelper alloc] init];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    if (!self.isFirstTimeLogin) {
        [self.backBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            CGFloat backBtnTopMargin = 11 + HIC_StatusBar_Height;
            CGFloat backBtnLeftMargin = 16;
            CGFloat backBtnW = 12;
            CGFloat backBtnH = 22;
            make.edges.mas_equalTo(UIEdgeInsetsMake(backBtnTopMargin, backBtnLeftMargin, HIC_ScreenHeight - backBtnTopMargin - backBtnH, HIC_ScreenWidth - backBtnLeftMargin * 2 - backBtnW)); // 增大按钮点击区域
        }];
    }

    [self.mpView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(HIC_NavBarAndStatusBarHeight);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];

    [self.btmView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-(59 + HIC_BottomHeight));
    }];

}

- (void)createUI {
    self.view.backgroundColor = [UIColor whiteColor];
    if (!self.isFirstTimeLogin) {
        [self.view addSubview:self.backBtn];
    }
    [self.view addSubview:self.mpView];
    [self.view addSubview:self.btmView];
}

- (void)clickButton {
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark HICModifyPassViewDelegate
- (void)confirmBtnClickedWithPass:(NSString *)pass confirmPass:(NSString *)confirmPass {
    if (![pass isEqualToString:confirmPass]) {
        DDLogDebug(@"%@ Passwords NOT equal", logName);
        [HICToast showWithText:NSLocalizableString(@"twoNewPasswordsAreInconsistent", nil)];
    } else {
        DDLogDebug(@"%@ Password is: %@", logName, pass);
        if ([NSString isValidStr:pass] && [NSString isValidPass:pass]) { // TODO: 判断是否是合法的password
            if (![NSString isValidStr:self.authCode] && ![NSString isValidStr:self.oldPass]) {
                DDLogDebug(@"%@ Old password & Auth code are NULL", logName);
                return;
            }

            if (![HICCommonUtils checkPassword:pass from:@"6" to:@"16"]) {
                DDLogDebug(@"%@ Passwords is NOT valid pattern", logName);
                [HICToast showWithText:NSLocalizableString(@"passwordRequired", nil)];
                return;
            }

            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            if (self.customerId) {
                [dic setValue:self.customerId forKey:@"customerId"];
            }
            if ([NSString isValidStr:self.loginName]) {
                [dic setValue:self.loginName forKey:@"loginName"];
            }
            if ([NSString isValidStr: self.authCode]) {
                [dic setValue:self.authCode forKey:@"authCode"];
            }
            if ([NSString isValidStr:self.oldPass]) {
                [dic setValue:[_helper getMD5AndBase64StringWithStr:self.oldPass] forKey:@"oldPassword"];
            }
            [dic setValue:[_helper getMD5AndBase64StringWithStr:pass] forKey:@"newPassword"];
            [HICAPI changePwd:dic success:^(NSDictionary * _Nonnull responseObject) {
                [HICToast showWithText:NSLocalizableString(@"changePwdSuccess", nil)];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }];
        } else {
            [HICToast showWithText:NSLocalizableString(@"passwordCannotEmpty", nil)];
        }
    }
}

@end
