//
//  NSString+JLogSDKExtension.h
//  AFNetworking
//
//  Created by keep on 2018/1/29.
//

#import <Foundation/Foundation.h>

@interface NSString (JLogSDKExtension)

/** 字符串是否为空 */
+ (BOOL)isEmptyTo:(NSString *)data;

/** 16进制转换为NSData */
+ (NSData *)convertHexStrToData:(NSString *)str;

/** NSData转换为16进制 */
+ (NSString *)convertDataToHexStr:(NSData *)data;

/** NSDictionary转NSString */
+ (NSString *)dictionaryToJson:(NSDictionary *)dic;

/** NSString转NSDictionary */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

@end
