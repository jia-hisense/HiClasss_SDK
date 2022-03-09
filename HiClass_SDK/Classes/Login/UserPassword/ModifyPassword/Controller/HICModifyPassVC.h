//
//  HICModifyPassVC.h
//  HiClass
//
//  Created by Eddie Ma on 2019/12/31.
//  Copyright © 2019 jingxianglong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HICModifyPassVC : UIViewController

/// Old password
@property (nonatomic, strong) NSString *oldPass;
/// 验证码
@property (nonatomic, strong) NSString *authCode;
/// 用户id
@property (nonatomic, strong) NSNumber *customerId;
/// 用户名 （手机号）
@property (nonatomic, strong) NSString *loginName;
/// 是否是第一次登录
@property (nonatomic, assign) BOOL isFirstTimeLogin;

@end

NS_ASSUME_NONNULL_END
