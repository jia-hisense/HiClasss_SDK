//
//  NSString+String.h
//  HiClass
//
//  Created by hisense on 2020/4/22.
//  Copyright © 2020 haoqian. All rights reserved.
//



#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (String)
+ (BOOL)isValidString:(NSString *)str;
+ (NSString *)realString:(NSString *)data;
+ (NSString *)formatFloat:(float)f;

/// 跨年：后面显示年份   同年：前面显示年份
/// @param startTime 开始时间
/// @param endTime 结束时间
+ (NSString *)getFullOrSimpleDateWithStartTime:(NSInteger)startTime endTime:(NSInteger)endTime;

/// 显示完整年月日时分
/// @param startTime 开始时间
/// @param endTime 结束时间
+ (NSString *)getFullDateWithStartTime:(NSInteger)startTime endTime:(NSInteger)endTime;


+(NSString *)getTimeFormate:(NSInteger)startTime andEndTime:(NSInteger)endTime;
+(NSString *)getMonthDateWithTime:(NSInteger)time;
+(NSString *)getHoserWithTime:(NSInteger)time;

@end

NS_ASSUME_NONNULL_END
