//
//  HICSDKManager.h
//  HIClass_SDK
//
//  Created by 铁柱， on 2020/8/26.
//  Copyright © 2020 铁柱，. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HICSDKManagerDelegate <NSObject>
@optional
- (void)loggedAgain;
- (void)backToApp;
@end

typedef void(^BackAppBlock)(void);
typedef void(^LoggedAgain)(void);

/// HISDK管理类
@interface HICSDKManager : NSObject

@property (nonatomic, assign)NSInteger type;
@property (nonatomic, weak)id<HICSDKManagerDelegate>HICDelegate;
@property (nonatomic, strong)UIViewController *controller;
@property (nonatomic, copy)BackAppBlock backBlock;
@property (nonatomic, copy)LoggedAgain logBlock;

/// SDK单例
+ (instancetype)shared;

/// 使用第三方Token登录（如信天翁调用SDK）
/// @param token 第三方应用Token
/// @param userId 第三方用户ID
/// @param success 成功回调
/// @param failure 失败回调
- (void)loginWithToken:(NSString *)token andUserId:(NSNumber *)userId success:(void(^)(BOOL issuccess))success failure:(void(^)(NSInteger code, NSString * errorStr))failure;

/// OA账号密码登录
/// @param account OA账号
/// @param password OA账号密码
/// @param success 成功回调
/// @param failure 失败回调
- (void)loginWithAccount:(NSString *)account password:(NSString *)password success:(void(^)(BOOL issuccess))success failure:(void(^)(NSInteger code, NSString * errorStr))failure;

/// 手机号密码登录
/// @param phone 手机号码
/// @param password 密码
/// @param success 成功回调
/// @param failure 失败回调
- (void)loginWithPhone:(NSString *)phone password:(NSString *)password success:(void(^)(BOOL issuccess))success failure:(void(^)(NSInteger code, NSString * errorStr))failure;

- (void)applicationDidEnterBackground;
- (void)applicationWillEnterForeground;
- (void)needSignAgain;
- (void)backApp;

@end

NS_ASSUME_NONNULL_END
