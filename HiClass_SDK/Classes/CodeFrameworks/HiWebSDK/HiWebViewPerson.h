//
//  HiWebViewPerson.h
//  HiClass
//
//  Created by WorkOffice on 2020/1/17.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    WebGetUserInfoCustomerId,
    WebGetUserInfoCustomerName,
    WebGetUserInfoToken,
    WebGetUserInfoAppName,
    WebGetUserInfoAppVersion,
    WebGetUserInfoAppVersionCode,
    WebGetUserInfoAppPackName,
    WebGetUserInfoDeviceId,
    WebScanUrlJumpToOhterVC,
} WebGetUserInfoType;

typedef void(^OpenNewWebViewBlock)(NSString * _Nullable urlStr);

typedef NSDictionary*_Nullable(^GetPublicValueBlock)(WebGetUserInfoType type, NSDictionary *_Nonnull param);

typedef void(^H5ExameBackGroundBlock)(void);
typedef void(^H5ExameTimeBackGroundBlock)(BOOL isBackGround);

NS_ASSUME_NONNULL_BEGIN

/// 统一接口实现类 -- 用于WebView和主工程进行公共方法
@interface HiWebViewPerson : NSObject

+(instancetype)sharePerson;

/// 打开一个新的接口
@property (nonatomic, copy) OpenNewWebViewBlock openNewWebViewBlock;

/// 获取公共参数
@property (nonatomic, copy) GetPublicValueBlock getPublicValueBlock;
/// 考试进入后台是告知H5，可以控制退到后台次数
@property (nonatomic, copy, nullable) H5ExameBackGroundBlock backgroundBlock;
/// 考试进入后台告知H5，用来控制考试定时器的开启和暂停
@property (nonatomic, copy, nullable) H5ExameTimeBackGroundBlock timeBackgroundBlock;

@end

NS_ASSUME_NONNULL_END
