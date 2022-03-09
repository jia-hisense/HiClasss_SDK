//
//  HsLogReportManager.h
//  HsPushMsgSDK
//
//  Created by Mzd on 2018/11/14.
//  Copyright © 2018 Hisense. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HsEnum.h"
#define JHKPushSDKVersion @"1.0.0.0"
@interface HsLogReportManager : NSObject

+ (HsLogReportManager *)logManager;

- (void)initHsLogReportManagerWithDeviceId:(NSString *)deviceId KeyOfApp:(NSString *)appKey typeOfUrl:(NSString *) urlType;
- (void)reportLogWithDict:(NSDictionary *)dict;
- (NSDictionary *)getLogEventDictWithLogType:(HsPushMsgLogEventCode)type specailDic:(NSDictionary *)dic;
- (NSDictionary *)logReportWithAllInfo:(HsPushMsgLogEventCode)type specailDic:(NSDictionary *)aDic vendorType:(JHKPushVendor)vt;
@end
