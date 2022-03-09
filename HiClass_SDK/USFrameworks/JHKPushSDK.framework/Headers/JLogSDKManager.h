//
//  JLogSDKManager.h
//  AFNetworking
//
//  Created by keep on 2018/1/9.
//

#import "JLogSDKEnum.h"
#import <Foundation/Foundation.h>

@interface JLogSDKManager : NSObject

/**
 * 初始化方法
 * 无策略类型URL，默认为国内
 * @param deviceId : 设备ID
 * @param appKey   : 应用日志上报key
 */
- (instancetype)initWithDeviceId:(NSString *)deviceId appKey:(NSString *)appKey;

/**
 * 初始化方法
 * @param deviceId   : 设备ID
 * @param appKey     : 应用日志上报key
 * @param strUrlType : 策略URL类型
 */
- (instancetype)initWithDeviceId:(NSString *)deviceId appKey:(NSString *)appKey strUrlType:(JLogSDKStrUrlType)strUrlType;

/**
 * 上报日志
 * @param dict : 上报日志字典，注意：需含有time当前时间戳参数，具体见README文档
 */
+ (void)reportLogWithDict:(NSDictionary *)dict;

@end
