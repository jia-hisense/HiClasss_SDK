//
//  HICLoginManager.m
//  HiClass
//
//  Created by 铁柱， on 2020/1/9.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICNetModel.h"
#import "HICLoginManager.h"
#import <JHKPushSDK/JHKPush.h>

static NSString *logName = @"[HIC][LM]";

@implementation HICLoginManager

+ (instancetype)shared {
   static HICLoginManager * manager = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (void)ifTokenExpired:(NSString *)token {

}

- (BOOL)isLoggedIn {
    if ([NSString isValidStr:USER_TOKEN] && [NSString isValidStr:USER_TOKEN_CREATE_TIME] && [NSString isValidStr:USER_TOKEN_EXPIRED_TIME]) {
        NSInteger currentTime = [[NSDate date] timeIntervalSince1970];
        if (currentTime >= [USER_TOKEN_CREATE_TIME integerValue] && ([USER_TOKEN_CREATE_TIME integerValue] + [USER_TOKEN_EXPIRED_TIME integerValue]) >= currentTime) {
            return YES;
        }
        return NO;
    }
    return NO;
}

- (void)refreshToken {
    NSInteger currentTime = [[NSDate date] timeIntervalSince1970];
    if ([NSString isValidStr:USER_REFRESH_TOKEN] && (currentTime <= [USER_REFRESH_TOKEN_EXPIRED_TIME integerValue])) {
        [HICAPI refreshToken:^(NSDictionary * _Nonnull responseObject) {
            // 刷新token成功
            [self saveUserInfo:responseObject];
        } failure:^(NSError * _Nonnull error) {
            // 刷新token失败
            if ([NSString isValidStr:USER_TOKEN_CREATE_TIME] && [NSString isValidStr:USER_TOKEN_EXPIRED_TIME]) {
                NSInteger totalTime = [USER_TOKEN_CREATE_TIME integerValue] + [USER_TOKEN_EXPIRED_TIME integerValue];
                NSInteger interval = [USER_TOKEN_EXPIRED_TIME integerValue] / 3;
                if ((totalTime - currentTime) < interval) {
                    DDLogDebug(@"%@ Token is less than 1/3, logout", logName);
                    [self clearUserInfo];
                    [HICCommonUtils setRootViewToLoginVC];
                }
            } else {
                DDLogDebug(@"%@ Token create or expired time is NOT valid, logout", logName);
                [self clearUserInfo];
                [HICCommonUtils setRootViewToLoginVC];
            }
        }];
    } else {
        DDLogDebug(@"%@ Refresh Token NOT found, logout", logName);
        [self clearUserInfo];
        [HICCommonUtils setRootViewToLoginVC];
    }
}

- (void)saveUserInfo:(NSDictionary *)dic {
    NSString *customerId = [dic valueForKey:@"customerId"];
    NSString *token = [dic valueForKey:@"token"];
    NSString *tokenCreateTime = [dic valueForKey:@"tokenCreateTime"];
    NSString *tokenExpiredTime = [dic valueForKey:@"tokenExpiredTime"];
    NSString *refreshToken = [dic valueForKey:@"refreshToken"];
    NSString *refreshTokenExpiredTime = [dic valueForKey:@"refreshTokenExpiredTime"];
    NSInteger currentTime = [[NSDate date] timeIntervalSince1970];
    refreshTokenExpiredTime = [NSString stringWithFormat:@"%ld", (long)[refreshTokenExpiredTime integerValue] + currentTime];

    if (![NSString isValidStr:customerId]) {
        customerId = @"";
        DDLogDebug(@"%@ User customer ID is NOT valid", logName);
    }
    if (![NSString isValidStr:token]) {
        token = @"";
        DDLogDebug(@"%@ User token is NOT valid", logName);
    }
    if (![NSString isValidStr:tokenCreateTime]) {
        tokenCreateTime = @"";
        DDLogDebug(@"%@ User tokenCreateTime is NOT valid", logName);
    }
    if (![NSString isValidStr:tokenExpiredTime]) {
        tokenExpiredTime = @"";
        DDLogDebug(@"%@ User tokenExpiredTime is NOT valid", logName);
    }
    if (![NSString isValidStr:refreshToken]) {
        refreshToken = @"";
        DDLogDebug(@"%@ User refreshToken is NOT valid", logName);
    }
    if (![NSString isValidStr:refreshTokenExpiredTime]) {
        refreshTokenExpiredTime = @"";
        DDLogDebug(@"%@ User refreshTokenExpiredTime is NOT valid", logName);
    }
    if (![NSString isValidStr:token]) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setValue:customerId forKey:@"userCID"];
    [[NSUserDefaults standardUserDefaults] setValue:token forKey:@"userToken"];
    [[NSUserDefaults standardUserDefaults] setValue:tokenCreateTime forKey:@"userTokenCreateTime"];
    [[NSUserDefaults standardUserDefaults] setValue:tokenExpiredTime forKey:@"userTokenExpiredTime"];
    [[NSUserDefaults standardUserDefaults] setValue:refreshToken forKey:@"userRefreshToken"];
    [[NSUserDefaults standardUserDefaults] setValue:refreshTokenExpiredTime forKey:@"userRefreshTokenExpiredTime"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    DDLogDebug(@"%@ customerId: %@ saved", logName, customerId);
    DDLogDebug(@"%@ token: %@ saved", logName, token);
    DDLogDebug(@"%@ tokenCreateTime: %@ saved", logName, tokenCreateTime);
    DDLogDebug(@"%@ tokenExpiredTime: %@ saved", logName, tokenExpiredTime);
    DDLogDebug(@"%@ refreshToken: %@ saved", logName, refreshToken);
    DDLogDebug(@"%@ refreshTokenExpiredTime: %@ saved", logName, refreshTokenExpiredTime);

    // 登录状态下 阿里推送绑定账号
    if ([LoginManager isLoggedIn]) {
        [[JHKPush shared] account:USER_CID isBind:YES vendorType:JHK_PUSH_VENDOR_ALI];
    }
}

- (void)logout {
    [HICCommonUtils setRootViewToLoginVC];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [HICAPI logout:^(NSDictionary * _Nonnull responseObject) {
            [HICToast showWithText:NSLocalizableString(@"exitSuccess", nil)];
            // 清空信息
            [LoginManager clearUserInfo];
        } failure:^(NSError * _Nonnull error) {
            [HICToast showWithText:NSLocalizableString(@"exitFailed", nil)];
            // 清空信息
            [LoginManager clearUserInfo];
        }];
    });
}
- (void)logoutWithModify {
    [HICCommonUtils setRootViewToLoginVC];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [HICAPI logout:^(NSDictionary * _Nonnull responseObject) {
            [HICToast showWithText:NSLocalizableString(@"changePwdSuccess", nil)];
            // 阿里推送账号解绑
            [[JHKPush shared] account:USER_CID isBind:NO vendorType:JHK_PUSH_VENDOR_ALI];
            // 清空信息
            [LoginManager clearUserInfo];
        } failure:^(NSError * _Nonnull error) {
            // 清空信息
            [LoginManager clearUserInfo];
        }];
    });
}
- (void)clearUserInfo {
    // 阿里推送账号解绑
    [[JHKPush shared] account:USER_CID isBind:NO vendorType:JHK_PUSH_VENDOR_ALI];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userCID"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userToken"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userTokenCreateTime"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userTokenExpiredTime"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userRefreshToken"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userRefreshTokenExpiredTime"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"HadShowTrainSyncProgressToastKey"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"HadShowPostSyncProgressToastKey"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"hadShowMixTrainyncProgressToastKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
