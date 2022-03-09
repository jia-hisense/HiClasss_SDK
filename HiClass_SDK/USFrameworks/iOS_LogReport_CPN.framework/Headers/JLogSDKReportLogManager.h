//
//  JLogSDKReportLogManager.h
//  AFNetworking
//
//  Created by keep on 2018/2/5.
//

#import "JLogSDKSingleton.h"
#import <Foundation/Foundation.h>

@interface JLogSDKReportLogManager : NSObject

singleton_interface(JLogSDKReportLogManager)

/// 上报日志
/// @param logType JLogSDKLogEventType
- (void)reportLogByType:(JLogSDKLogEventType)logType;

@end
