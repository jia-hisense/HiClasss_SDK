//
//  HICSystemManager.h
//  HiClass
//
//  Created by Eddie Ma on 2020/1/15.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HICSystemManager : NSObject

+ (instancetype)shared;

@property (nonatomic, strong) NSString *deviceID;
@property (nonatomic, strong) NSString *randomStr;
/// 获取app 版本，例：1.0.0.0
@property (nonatomic, strong) NSString *appVersion;
/// 获取app build版本，例：1.0.0.1
@property (nonatomic, strong) NSString *appBuild;
@property (nonatomic, strong) NSString *appName;
@property (nonatomic, strong) NSString *appBundle;
@property (nonatomic, strong) NSString *appKey;
@property (nonatomic, strong) NSString *appSecret;
@property (nonatomic, copy) NSString *macAddress;
@property (nonatomic, strong) NSString *downloadUrl;
@property (nonatomic, strong) NSString *loginInfo;
@property (nonatomic, assign) BOOL isShowToast;
@property (nonatomic, strong) NSNumber *updateFlag;
@property (nonatomic, assign) BOOL allowRotation;
- (void)setDomainsFromSystem;
- (void)checkAppUpdate;
- (NSString *)getAESStringWithStr:(NSString *)str;
- (NSString *)getMD5AndBase64StringWithStrgetAESStringWithStr:(NSString *)str;
@end

NS_ASSUME_NONNULL_END
