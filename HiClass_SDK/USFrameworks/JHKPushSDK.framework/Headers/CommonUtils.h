//
//  CommonUtils.h
//  HsPushMsgSDK
//
//  Created by Mzd on 2018/11/29.
//

#import <Foundation/Foundation.h>
#define LogReportManager    [HsLogReportManager logManager]
@interface CommonUtils : NSObject
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
+ (NSString *)createCUID:(NSString *)prefix;
+ (NSString *)currentDateTransformToTimeString;
+ (NSString *)currentDateTransformToTimeStamp;
+ (NSString *)encode:(NSString *)string;
+ (NSString *)dencode:(NSString *)base64String;
+ (NSString *)validValueFromDic:(NSDictionary *)dic key:(NSString *)key;
@end
