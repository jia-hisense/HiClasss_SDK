//
//  JLogSDKStrtegyManager.h
//  AFNetworking
//
//  Created by keep on 2018/1/29.
//

#import "JLogSDKEnum.h"
#import "JLogSDKSingleton.h"
#import <Foundation/Foundation.h>

@interface JLogSDKStrtegyManager : NSObject

singleton_interface(JLogSDKStrtegyManager)

/** 打点日志上报地址 */
@property (nonatomic, copy) NSString *dotAddress;
/** 异常日志上报地址 */
@property (nonatomic, copy) NSString *excAddress;
/** 业务日志上报地址 */
@property (nonatomic, copy) NSString *serAddress;

/** 打点日志上报开关 */
@property (nonatomic, copy) NSString *dotStatus;
/** 异常日志上报开关 */
@property (nonatomic, copy) NSString *excStatus;
/** 业务日志上报开关 */
@property (nonatomic, copy) NSString *serStatus;

/** 打点日志上报定时时间 单位：s */
@property (nonatomic, copy) NSString *dotDuration;
/** 异常日志上报定时时间 单位：s */
@property (nonatomic, copy) NSString *excDuration;
/** 业务日志上报定时时间 单位：s */
@property (nonatomic, copy) NSString *serDuration;

/** 打点日志上报定量长度 单位：条 */
@property (nonatomic, copy) NSString *dotFileSize;
/** 异常日志上报定量长度 单位：条 */
@property (nonatomic, copy) NSString *excFileSize;
/** 业务日志上报定量长度 单位：条 */
@property (nonatomic, copy) NSString *serFileSize;

/** 加密开关（1-开，0关），默认为：1 */
@property (nonatomic, copy) NSString *encrypt;
/** 压缩开关（1-开，0关），默认为：1 */
@property (nonatomic, copy) NSString *compress;

/** 策略开关字典 */
@property (nonatomic, strong) NSMutableDictionary *eventDict;

/** 存储策略参数字段 */
- (void)packStrategyDataWithDict:(NSDictionary *)dict;

/** 获取日志上报类型 */
- (JLogSDKLogEventType)getLogTypeWithCode:(NSString *)code;

@end
