//
//  HICViewController.m
//  HiClass_SDK
//
//  Created by zhangkaixiang.ex on 12/09/2021.
//  Copyright (c) 2021 zhangkaixiang.ex. All rights reserved.
//

#import "HICViewController.h"
#import "HICSDKManager.h"

@interface HICViewController ()

@end

@implementation HICViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"首页";
    self.view.backgroundColor = UIColor.whiteColor;
    
//    [self tokenLogin];
//    [self accountLogin];
//    [self phoneLogin]; 
}

// 信天翁Token登录，请替换方法中token和UserID
- (void)tokenLogin {
    HICSDKManager *manager = [HICSDKManager shared];
    manager.type = 2;
    manager.logBlock = ^{
        NSLog(@"token失效处理");
    };
    manager.backBlock = ^{
        NSLog(@"返回APP");
        UIWindow *window = [[UIApplication sharedApplication].delegate window];
        window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[HICViewController alloc] init]];;
    };
    
    [manager loginWithToken:@"6FEF4F42EDA90EE93CA7F3432FD5F4782A9A2CD63E72C56B" andUserId:@7388629 success:^(BOOL issuccess) {
        NSLog(@"登录成功处理");
    } failure:^(NSInteger code, NSString * _Nonnull errorStr) {
        NSLog(@"登录失败返回处理");
    }];
}

- (void)accountLogin {
    NSLog(@"账号登录。。。");
    HICSDKManager *manager = [HICSDKManager shared];
    manager.type = 2;
    manager.logBlock = ^{
        NSLog(@"token失效处理");
    };
    manager.backBlock = ^{
        NSLog(@"返回APP");
        UIWindow *window = [[UIApplication sharedApplication].delegate window];
        window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[HICViewController alloc] init]];;
    };
    [manager loginWithAccount:@"738862916" password:@"hisense2020" success:^(BOOL issuccess) {
        NSLog(@"登录成功处理");
    } failure:^(NSInteger code, NSString * _Nonnull errorStr) {
        NSLog(@"登录失败返回处理");
    }];
}

-(void)phoneLogin{
    NSLog(@"手机号登录。。。");
    HICSDKManager *manager = [HICSDKManager shared];
    manager.type = 2;
    manager.logBlock = ^{
        NSLog(@"token失效处理");
    };
    manager.backBlock = ^{
        NSLog(@"返回APP");
        UIWindow *window = [[UIApplication sharedApplication].delegate window];
        window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[HICViewController alloc] init]];;
    };
    [manager loginWithPhone:@"17854271653" password:@"123456" success:^(BOOL issuccess) {
        NSLog(@"登录成功处理");
    } failure:^(NSInteger code, NSString * _Nonnull errorStr) {
        NSLog(@"登录失败返回处理");
    }];
}
@end
