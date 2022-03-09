//
//  HICMyModiftPasswordVC.m
//  HiClass
//
//  Created by WorkOffice on 2020/3/25.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICMyModiftPasswordVC.h"
#import "HICLoginBottomImageView.h"
#import <HIClassSwift_SDK/HIClassSwift_SDK.h>
#import "HICNetModel.h"
#import "HICMyModifyPasswordView.h"
@interface HICMyModiftPasswordVC ()<HICMyModifyPasswordViewDelegate>{
    HICSDKHelper * _helper;
}
@property (nonatomic, strong) HICMyModifyPasswordView *mpView;
@property (nonatomic, strong) HICLoginBottomImageView *btmView;
@property (nonatomic, strong) UIButton *backBtn;
@end

@implementation HICMyModiftPasswordVC
#pragma mark - - - mpView getter
- (HICMyModifyPasswordView *)mpView {
    if (!_mpView) {
        _mpView = [[HICMyModifyPasswordView alloc] init];
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
    
//    if (!self.isFirstTimeLogin) {
        [self.backBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            CGFloat backBtnTopMargin = 11 + HIC_StatusBar_Height;
            CGFloat backBtnLeftMargin = 16;
            CGFloat backBtnW = 12;
            CGFloat backBtnH = 22;
            make.edges.mas_equalTo(UIEdgeInsetsMake(backBtnTopMargin, backBtnLeftMargin, HIC_ScreenHeight - backBtnTopMargin - backBtnH, HIC_ScreenWidth - backBtnLeftMargin * 2 - backBtnW)); // 增大按钮点击区域
        }];
//    }

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
    [self.view addSubview:self.backBtn];
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
- (void)confirmBtnClickedWithPass:(NSString *)pass oldPass:(nonnull NSString *)oldPass confirmPass:(nonnull NSString *)confirmPass{
    
    if ([NSString isValidStr:pass] && [NSString isValidStr:pass] && [NSString isValidStr:confirmPass]) { // TODO: 判断是否是合法的password
        if (![pass isEqualToString:confirmPass]) {
            [HICToast showWithText:NSLocalizableString(@"twoNewPasswordsAreInconsistent", nil)];
            return;
        }
        if ([pass isEqualToString:oldPass]) {
            [HICToast showWithText:NSLocalizableString(@"newPasswordCannotSameAsOldPassword", nil)];
            return;
        }
        if (![HICCommonUtils checkPassword:pass from:@"6" to:@"16"]) {
            [HICToast showWithText:NSLocalizableString(@"passwordRequired", nil)];
            return;
        }
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setValue:[_helper getMD5AndBase64StringWithStr:oldPass] forKey:@"oldPassword"];
        [dic setValue:[_helper getMD5AndBase64StringWithStr:pass] forKey:@"newPassword"];
        [dic setValue:USER_TOKEN forKey:@"accessToken"];
        [HICAPI confirmBtnClickedWithPass:dic success:^(NSDictionary * _Nonnull responseObject) {
            [LoginManager logoutWithModify];
        } failure:^(NSError * _Nonnull error) {
            if (error.code == 202012) {
                [HICToast showWithText:NSLocalizableString(@"oldPasswordIncorrect", nil)];
            }else{
                [HICToast showWithText:[error.userInfo valueForKey:@"error_desc"] ? [error.userInfo valueForKey:@"error_desc"] : @"Net error!"];
            }
        }];
    } else {
        [HICToast showWithText:NSLocalizableString(@"passwordCannotEmpty", nil)];
    }
}


@end
