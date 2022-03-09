//
//  JLogSDKSettingManager.h
//  AFNetworking
//
//  Created by keep on 2018/1/9.
//

#import "JLogSDKEnum.h"
#import "JLogSDKSingleton.h"
#import <Foundation/Foundation.h>

@interface JLogSDKSettingManager : NSObject

singleton_interface(JLogSDKSettingManager)

/** 日志上报 RES加密 key */
@property (nonatomic, copy) NSString *REP_D_A_K;

/** 日志上报 RES加密 偏移量 */
@property (nonatomic, copy) NSString *REP_D_A_V;

/** 解析策略 RES加密 key */
@property (nonatomic, copy) NSString *STR_D_A_K;
/** 解析策略 RES加密 偏移量 */
@property (nonatomic, copy) NSString *STR_D_A_V;

/** appkey */
@property (nonatomic, copy) NSString *APPKEY;

/// 自定义上传策略URL
@property (nonatomic, copy) NSString *customUrl;

/** strUrlType */
@property (nonatomic, assign) JLogSDKStrUrlType STR_URL_TYPE;

@end
