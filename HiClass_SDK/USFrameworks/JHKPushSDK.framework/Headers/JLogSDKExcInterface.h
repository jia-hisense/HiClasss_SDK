//
//  JLogSDKExcInterface.h
//  AFNetworking
//
//  Created by keep on 2018/1/9.
//

#import "JLogSDKInterfaceBase.h"

@interface JLogSDKExcInterface : JLogSDKInterfaceBase

/** 日志上报参数字典 */
@property (nonatomic, copy) NSDictionary *dict;

/** 日志上报参数 */
@property (nonatomic, strong) NSArray *logArr;

@end
