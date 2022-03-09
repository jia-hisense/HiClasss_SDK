//
//  HICForgetPassworVC.m
//  HiClass
//
//  Created by wangggang on 2019/12/31.
//  Copyright © 2019 jingxianglong. All rights reserved.
//

#import "HICForgetPassworVC.h"
#import <HIClassSwift_SDK/HIClassSwift_SDK.h>
#import "HICForgetInputView.h"
#import "HICLoginBottomImageView.h"
// 重置密码页面
#import "HICModifyPassVC.h"

static NSString *logName = @"[HIC][FPVC]";

@interface HICForgetPassworVC () {
    HICSDKHelper * _helper;
}

@property (nonatomic, strong) HICForgetInputView *inputView;

@end

@implementation HICForgetPassworVC

#pragma mark - 控制器生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor; // 设置背景颜色
    self.navigationController.navigationBarHidden = YES;
    [self initData];
    // 1. 添加视图
    [self createNavgationBarBack];
    [self createTitleLabel];
    [self createBottomView];

    // 2. 增加手势方法
    [self createTap];

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 2. 反复的添加inputView
    if (self.inputView) {
        [self.inputView removeFromSuperview];
        self.inputView = nil;
    }
    [self createInputView];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    // 1. 有定时器存在首先去掉定时器
    if (self.inputView.timer) {
        [self.inputView.timer invalidate];
        self.inputView.timer = nil; // 置空
    }
    // 2. 清空缓存数据
    [self.inputView cleanDataInput];
    // 3. 结束整个页面的编辑状态
    [self.view endEditing:YES];
}

- (void)initData {
    _helper = [[HICSDKHelper alloc] init];
}

#pragma mark - 创建view
-(void)createNavgationBarBack {

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.view addSubview:button];
    
//    [button setBackgroundImage:[UIImage imageNamed:@"bt-back"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"bt-back"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickNavBack:) forControlEvents:UIControlEventTouchUpInside];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(11);
        } else {
            // Fallback on earlier versions
            make.top.equalTo(self.view.mas_top).offset(31);
        }
        make.left.equalTo(self.view.mas_left).offset(16);
        make.width.offset(30);
        make.height.offset(30);
    }];
    
}

// 创建标题
-(void)createTitleLabel {
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, HIC_StatusBar_Height + 60, 200, 32.5)];
    titleLabel.text = NSLocalizableString(@"changePwd", nil);
    titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:23];
    
    [self.view addSubview:titleLabel];
    
}

// 创建输入框
-(void)createInputView {
    
    HICForgetInputView *inputView = [[HICForgetInputView alloc] initWithFrame:CGRectMake(0, HIC_StatusBar_Height+112.5, HIC_ScreenWidth, HIC_ScreenHeight - (HIC_StatusBar_Height+112.5))];
    self.inputView = inputView;
    [self.view addSubview:inputView];

    // 避免引用循环
    __weak typeof(self) weakSelf = self;
    [inputView clickNextButBlock:^(NSString * _Nonnull phone, NSString * _Nonnull authCode, NSString *_Nonnull pass, NSString *_Nonnull confirmPass) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (![pass isEqualToString:confirmPass]) {
            DDLogDebug(@"%@ Passwords NOT equal", logName);
            [HICToast showWithText:NSLocalizableString(@"twoNewPasswordsAreInconsistent", nil)];
        } else {
            DDLogDebug(@"%@ Password is: %@", logName, pass);
            if ([NSString isValidStr:pass] && [NSString isValidPass:pass]) { // TODO: 判断是否是合法的password
                if (![NSString isValidStr:authCode]) {
                    DDLogDebug(@"%@ Auth code is NULL", logName);
                    return;
                }

                if (![HICCommonUtils checkPassword:pass from:@"6" to:@"16"]) {
                    DDLogDebug(@"%@ Passwords is NOT valid pattern", logName);
                    [HICToast showWithText:NSLocalizableString(@"passwordRequired", nil)];
                    return;
                }

                NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                if ([NSString isValidStr:phone]) {
                    [dic setValue:phone forKey:@"loginName"];
                }
                if ([NSString isValidStr: authCode]) {
                    [dic setValue:authCode forKey:@"authCode"];
                }

                [dic setValue:[self->_helper getMD5AndBase64StringWithStr:pass] forKey:@"newPassword"];
                [HICAPI changePwd:dic success:^(NSDictionary * _Nonnull responseObject) {
                    [strongSelf.navigationController popToRootViewControllerAnimated:YES];
                }];
            } else {
                [HICToast showWithText:NSLocalizableString(@"passwordCannotEmpty", nil)];
            }
        }
    }];
}

// 创建底部Image视图
-(void)createBottomView {
    
    HICLoginBottomImageView *bottomView = [[HICLoginBottomImageView alloc] init];
    [self.view addSubview:bottomView];

    [bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-(59 + HIC_BottomHeight));
    }];
}

// 创建手势方法
-(void)createTap {

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickBackView:)];
    [self.view addGestureRecognizer:tap];

}
#pragma mark - 页面点击事件处理
-(void)clickNavBack:(UIButton*)btn {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)clickBackView:(UITapGestureRecognizer *)tap {

    [self.view endEditing:YES];

}


@end
