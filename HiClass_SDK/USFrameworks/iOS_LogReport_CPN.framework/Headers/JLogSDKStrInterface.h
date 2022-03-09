//
//  JLogSDKStrInterface.h
//  AFNetworking
//
//  Created by keep on 2018/1/9.
//

#import "JLogSDKInterfaceBase.h"

@interface JLogSDKStrInterface : JLogSDKInterfaceBase

/** 应用key */
@property (nonatomic, copy) NSString *appKey;

/** 通道标识，默认为：1 */
@property (nonatomic, copy) NSString *version;

/** 设备id */
@property (nonatomic, copy) NSString *deviceId;

/** 时间戳 */
@property (nonatomic, copy) NSString *policySeq;

/**
 * 日志上报方式 默认：json
 * 0:json
 * 1:binary
 * 2:xml
 */
@property (nonatomic, copy) NSString *reportTag;

/**
 * 获取日志策略方 默认：xml
 * 0:xml
 * 1:binary
 */
@property (nonatomic, copy) NSString *receiveTag;

@end
