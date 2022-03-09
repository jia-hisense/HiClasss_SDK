//
//  HICLoginManager.h
//  HiClass
//
//  Created by 铁柱， on 2020/1/9.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface HICLoginManager : NSObject
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

+ (instancetype)shared;

- (void)ifTokenExpired:(NSString *)token;

/// 是否已登录
- (BOOL)isLoggedIn;

/// 刷新token
- (void)refreshToken;

/// 保存用户信息
/// @param dic 用户信息
- (void)saveUserInfo:(NSDictionary *)dic;

/// 登出
- (void)logout;
///修改密码后登出
- (void)logoutWithModify;
/// 清除用户信息
- (void)clearUserInfo;

@property (nonatomic, assign)BOOL isPhoneNumLogin;
@end

NS_ASSUME_NONNULL_END
