//
//  HICUserLoginVC.m
//  HiClass
//
//  Created by wangggang on 2019/12/31.
//  Copyright © 2019 jingxianglong. All rights reserved.
//

#import "HICUserLoginVC.h"
#import "HICModifyPassVC.h"
#import "HICOALoginView.h"
#import "HICLoginBottomImageView.h"
#import "HICPhoneNumLoginView.h"
#import "VCHPermissionAlertView.h"
#import "HICForgetPassworVC.h"
#import "HICNetModel.h"
#import "HICLoginManager.h"
#import "HICLogManager.h"
#import "HICPhotoPickerVC.h"
#import "HICBaseNavigationViewController.h"
#import "MainTabBarVC.h"
#import "HICModifyPassVC.h"
#import "HICTaskCneterVC.h"
#import "HICModifyPassVC.h"
#import <HIClassSwift_SDK/HIClassSwift_SDK.h>
#import "HICCommentPopupView.h"
#import "HICHomeStudyVC.h"
#import "HICMyBaseInfoModel.h"
static NSString *userDefalutsKey = @"protocol";
static NSString *userDefalutsValue = @"agreeProtocol";
@interface HICUserLoginVC ()<HICOALoginViewDelegate,VCHPermissionAlertViewDelegate,HICPhoneNumLoginViewDelegate> {
    HICSDKHelper *_helper;
}
@property (nonatomic, strong) HICOALoginView *oaLoginView;
@property (nonatomic, strong) HICLoginBottomImageView *bottomImageView;
@property (nonatomic, strong) HICPhoneNumLoginView *phoneNumLoginView;
@property (nonatomic, strong) VCHPermissionAlertView *vchAlertView;
@property (nonatomic, strong) HICForgetPassworVC *forgetPasswordVC;
@property (nonatomic, strong) NSMutableDictionary *loginModel;
@property (nonatomic, strong) HICNetModel *netModel;
@property (nonatomic, strong) HICModifyPassVC *modifyVC;
@property (nonatomic, assign) NSUInteger registerType;
@property (nonatomic, assign) BOOL isAgree;
@property (nonatomic, weak) NSTimer *timer;

@end

@implementation HICUserLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _helper = [[HICSDKHelper alloc] init];
    [self addUI];
    
    [self updateViewConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.phoneNumLoginView clearPassField];
}

- (void)addUI {
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = UIColor.whiteColor;
    DDLogDebug(@"--- %f -- %d -- %f", HIC_StatusBar_Height, HIC_isIPhoneX, HIC_BottomHeight);
    switch ([HICCommonUtils appBundleIden]) {
        case HICAppBundleIdenHiClass:
            [self addPhoneNumAndOALoginView];
            break;
        case HICAppBundleIdenZhiYu:
            [self addPhoneUmLoginView];
            break;
        default:
            break;
    }
}

- (void)addPhoneNumAndOALoginView {
    [self.view addSubview:self.bottomImageView];
    [self.view addSubview:self.phoneNumLoginView];
    self.phoneNumLoginView.hidden = YES;
    [self.view addSubview:self.oaLoginView];
    [self getPWDSystem];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *protocolAgree = [userDefaults objectForKey:userDefalutsKey];
    if([protocolAgree isEqualToString:userDefalutsValue]){
        self.isAgree = true;
    }else{
        self.isAgree = false;
        [self requestAgreement];
    }
}
- (void)addPhoneUmLoginView {
    [self.view addSubview:self.bottomImageView];
    [self.view addSubview:self.phoneNumLoginView];
    [self getPWDSystem];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *protocolAgree = [userDefaults objectForKey:userDefalutsKey];
    if([protocolAgree isEqualToString:userDefalutsValue]){
        self.isAgree = true;
    }else{
        self.isAgree = false;
        [self requestAgreement];
    }
}
#pragma mark -布局
- (void)updateViewConstraints {
    [super updateViewConstraints];
    if ([HICCommonUtils appBundleIden] == HICAppBundleIdenHiClass) {
        [self.oaLoginView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(HIC_NavBarAndStatusBarHeight);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.bottom.equalTo(self.view);
        }];
    }
    
    [self.phoneNumLoginView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(HIC_NavBarAndStatusBarHeight);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    [self.bottomImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-(59 + HIC_BottomHeight));
    }];
    if(!self.isAgree){
        [self.vchAlertView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.bottom.equalTo(self.view);
        }];
    }
}

- (void)getPWDSystem {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [HICAPI getPWDSystem:^(NSDictionary * _Nonnull responseObject) {
            if ([responseObject valueForKey:@"paramList"] && [[responseObject valueForKey:@"paramList"] isKindOfClass:[NSArray class]]) {
                NSArray *arr = [responseObject valueForKey:@"paramList"];
                if (arr.count > 0) {
                    NSDictionary *dic = arr[0];
                    /* "code": "string,参数名称：PWD_RULE 密码强度规则（1 强，2 中， 3弱），PWD_GEN_RULE 密码生成规则（1 身份证后四位， 2 固定值）",
                     "value": "string,参数值",
                     "extra": "string,额外参数值,例如当code=PWD_GEN_RULE, value=2时，此extra为初始固定密码"*/
                    if ([[dic valueForKey:@"code"] isEqualToString:@"PWD_GEN_RULE"]) {
                        _phoneNumLoginView.loginInfo = (NSString *)[dic valueForKey:@"extra"];
                        if ([[dic valueForKey:@"value"] integerValue] == 1) {
                            _phoneNumLoginView.loginInfo = PHONELOGIN_INFO;
                        }else{
                            _phoneNumLoginView.loginInfo = (NSString *)[dic valueForKey:@"extra"];
                        }
                    }else{
                        _phoneNumLoginView.loginInfo = PHONELOGIN_INFO;
                    }
                }
            }
        } failure:^(NSError * _Nonnull error) {
            _phoneNumLoginView.loginInfo = PHONELOGIN_INFO;
        }];
    });
}
- (void)requestAgreement {
    [HICAPI requestAgreement:^(NSDictionary * _Nonnull responseObject) {
        NSString *content = responseObject[@"data"][@"content"];
        if ([NSString isValidStr:content]) {
            self.vchAlertView = [[VCHPermissionAlertView alloc]initWithFrame:CGRectMake(0, 0, HIC_ScreenWidth, HIC_ScreenHeight) Title:NSLocalizableString(@"userPrivacyAgreement", nil) startBtnTitle:NSLocalizableString(@"garee", nil) cancelBtnTitle:NSLocalizableString(@"cancel", nil) andStr:content];
            [self.view addSubview:self.vchAlertView];
            self.vchAlertView.delegate = self;
        }
    }];
}
- (void)initBaseInfo {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [HICAPI homePageDataQuery:^(NSDictionary * _Nonnull responseObject) {
            if (responseObject[@"data"] ) {
                HICMyBaseInfoModel *baseInfoModel = [HICMyBaseInfoModel mj_objectWithKeyValues:responseObject[@"data"][@"baseInfo"]];
                [[NSUserDefaults standardUserDefaults] setValue:baseInfoModel.name forKey:@"USER_NAME"];
            }
        } failure:^(NSError * _Nonnull error) {
            DDLogDebug(@"initBaseInfo: 获取首页信息失败");
        }];
    });
}
#pragma mark -HICOALoginViewDelegate
-(void)confirmBtnClickedWithAccount:(NSString *)account password:(NSString *)password{
    DDLogDebug(@"登录请求");
    self.loginModel[@"loginName"] = account;
    password = [_helper getAESStringWithStr:password];
    self.loginModel[@"password"] = password;
    self.loginModel[@"registType"] = @"2";
    [HICAPI confirmBtnClickedWithAccount:self.loginModel success:^(NSDictionary * _Nonnull responseObject) {
        [LoginManager saveUserInfo:responseObject];
        
        [self initBaseInfo];
        if ([LoginManager isLoggedIn]) {
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isNumLogin"];
            [HICCommonUtils setRootViewToMainVC];
            [RoleManager getSecurityInfoBlock:^(BOOL isSuccess) {
                if (isSuccess) {
                    [HICCommonUtils handleSecurityScreen];
                }
            }];
        }
    } failure:^(NSError * _Nonnull error) {
        [HICToast showWithText:[error.userInfo valueForKey:@"error_desc"] ? [error.userInfo valueForKey:@"error_desc"] : @"Net error!"];
    }];
}

- (void)phoneNumLogin {
    self.oaLoginView.hidden = YES;
    self.phoneNumLoginView.hidden = NO;
}

#pragma mark -VCHAlertDelegate
- (void)clickPermissionAlertVieWithBtnIndex:(NSInteger)btnIndex {
    if (btnIndex == 0) {
        //协议点击取消 退出APP
        exit(0);
    } else {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:userDefalutsValue forKey:userDefalutsKey];
    }
}
#pragma mark -HICPhoneNumLoginViewDelegate
- (void)confirmBtnClickedWithPhoneNum:(NSString *)phoneNum password:(NSString *)password{
    self.loginModel[@"loginName"] = phoneNum;
    NSString *encryptPass = [_helper getMD5AndBase64StringWithStr:password];
    self.loginModel[@"password"] = encryptPass;
    self.loginModel[@"registType"] = @"1";
    [HICAPI confirmBtnClickedWithAccount:self.loginModel success:^(NSDictionary * _Nonnull responseObject) {
        [LoginManager saveUserInfo:responseObject];
        [self initBaseInfo];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isNumLogin"];
        [HICCommonUtils setRootViewToMainVC];
    } failure:^(NSError * _Nonnull error) {
        if(error.code == HICAccModifyPass){
            self.modifyVC.oldPass = password;
            self.modifyVC.loginName = phoneNum;
            self.modifyVC.isFirstTimeLogin = YES;
            [self.navigationController pushViewController:self.modifyVC animated:YES];
        }else{
            [HICToast showWithText:[error.userInfo valueForKey:@"error_desc"] ? [error.userInfo valueForKey:@"error_desc"] : @"Net error!"];
        }
    }];
}

- (void)oaLogin {
    self.oaLoginView.hidden = NO;
    self.phoneNumLoginView.hidden = YES;
}
- (void)forgetPassword {
    [self.navigationController pushViewController:self.forgetPasswordVC animated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - lazzyload
- (HICOALoginView *)oaLoginView{
    if(!_oaLoginView){
        _oaLoginView = [[HICOALoginView alloc]init];
        _oaLoginView.delegate = self;
    }
    return _oaLoginView;
}
- (HICLoginBottomImageView *)bottomImageView {
    if(!_bottomImageView){
        _bottomImageView = [[HICLoginBottomImageView alloc]init];
    }
    return _bottomImageView;
}
- (HICPhoneNumLoginView *)phoneNumLoginView {
    if(!_phoneNumLoginView){
        _phoneNumLoginView = [[HICPhoneNumLoginView alloc]init];
        _phoneNumLoginView.delegate = self;
    }
    return _phoneNumLoginView;
}

- (HICForgetPassworVC *)forgetPasswordVC {
    if(!_forgetPasswordVC){
        _forgetPasswordVC = [[HICForgetPassworVC alloc]init];
    }
    return _forgetPasswordVC;
}
- (NSMutableDictionary *)loginModel {
    if(!_loginModel){
        _loginModel  = [[NSMutableDictionary alloc]init];
    }
    return _loginModel;
}
- (HICModifyPassVC *)modifyVC {
    if (!_modifyVC) {
        _modifyVC = [[HICModifyPassVC alloc]init];
    }
    return _modifyVC;
}

@end
