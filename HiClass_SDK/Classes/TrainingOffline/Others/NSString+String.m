//
//  NSString+String.m
//  HiClass
//
//  Created by hisense on 2020/4/22.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import "NSString+String.h"



@implementation NSString (String)


+ (NSString *)getFullOrSimpleDateWithStartTime:(NSInteger)startTime endTime:(NSInteger)endTime {
    if (startTime <= 0 && endTime <= 0) {
        return NSLocalizableString(@"unlimited", nil);
    }else if (startTime <= 0 && endTime > 0) {
        return [NSString stringWithFormat:@"%@%@%@", [NSString getMonthDateWithTime:startTime], NSLocalizableString(@"to", nil),[NSString getYearDateWithTime:endTime]];
    }else if (startTime > 0 && endTime > 0) {
        if (startTime < endTime) {
             NSString *startYear = [NSString getYearWithTime:startTime];
             NSString *endYear = [NSString getYearWithTime:endTime];
             if (![startYear isEqualToString:endYear]) {
                 return [NSString stringWithFormat:@"%@%@%@", [NSString getMonthDateWithTime:startTime], NSLocalizableString(@"to", nil),[NSString getYearDateWithTime:endTime]];
             } else {
                 NSString *startMonthDay = [NSString getMonthDayWithTime:startTime];
                 NSString *endMonthDay = [NSString getMonthDayWithTime:endTime];
                 if (![startMonthDay isEqualToString:endMonthDay]) {
                     // 不是同一天
                     return [NSString stringWithFormat:@"%@%@%@", [NSString getYearDateWithTime:startTime], NSLocalizableString(@"to", nil),[NSString getMonthDateWithTime:endTime]];
                 } else {
                     return [NSString stringWithFormat:@"%@%@%@", [NSString getYearDateWithTime:startTime], NSLocalizableString(@"to", nil),[NSString getHoserWithTime:endTime]];
                 }
             }
        }
    } else if (startTime > 0 && endTime <= 0) {
        return [NSString stringWithFormat:@"%@%@%@", [NSString getYearDateWithTime:startTime],NSLocalizableString(@"to", nil),NSLocalizableString(@"unlimited", nil)];
    }
    return NSLocalizableString(@"timeError", nil);
}

+ (NSString *)getFullDateWithStartTime:(NSInteger)startTime endTime:(NSInteger)endTime {
    if (startTime <= 0 && endTime <= 0) {
        return NSLocalizableString(@"unlimited", nil);
    }else if (startTime <= 0 && endTime > 0) {
        return [NSString stringWithFormat:@"%@ %@ %@", [NSString getYearDateWithTime:startTime], NSLocalizableString(@"to", nil),[NSString getYearDateWithTime:endTime]];
    }else if (startTime > 0 && endTime > 0) {
        if (startTime < endTime) {
             return [NSString stringWithFormat:@"%@ %@ %@", [NSString getYearDateWithTime:startTime], NSLocalizableString(@"to", nil),[NSString getYearDateWithTime:endTime]];
        }
    } else if (startTime > 0 && endTime <= 0) {
        return [NSString stringWithFormat:@"%@ %@ %@", [NSString getYearDateWithTime:startTime],NSLocalizableString(@"to", nil),NSLocalizableString(@"unlimited", nil)];
    }
    return NSLocalizableString(@"timeError", nil);
}


+ (BOOL)isValidString:(NSString *)str {
    return ![NSString isBlankString:str];
}

+  (BOOL)isBlankString:(NSString *)string {
    if ([[string class] isSubclassOfClass:[NSNull class]]) { return YES; } if (string == nil || string == NULL || [string isEqualToString:@"(null)"] || [string isEqualToString:@"null"] ||[string isEqualToString:@""]) {
        return YES;
    }

    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }

    if ([string isKindOfClass:[NSString class]] && [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}


+ (NSString *)formatFloat:(float)f{
    if (fmodf(f, 1)==0) { //无有效小数位
        return [NSString stringWithFormat:@"%.0f",f];
    } else if (fmodf(f*10, 1)==0) {//如果有一位小数点
        return [NSString stringWithFormat:@"%.1f",f];
    }
    else {//如果有两位或以上小数点
        //        return [NSString stringWithFormat:@"%.2f",f];
        return [NSString stringWithFormat:@"%.1f",f];
    }
}

+ (NSString *)realString:(NSString *)data {

    NSString *realStr = @"";

    if ([NSString isValidString:data]) {
        realStr = data;
    }
    return realStr;
}


+(NSString *)getTimeFormate:(NSInteger)startTime andEndTime:(NSInteger)endTime {

    if (startTime <= 0 && endTime <= 0) {
        return NSLocalizableString(@"unlimited", nil);
    }else if (startTime <= 0 && endTime > 0) {
        return [NSString stringWithFormat:@"%@%@%@", [NSString getMonthDateWithTime:startTime], NSLocalizableString(@"to", nil),[NSString getMonthDateWithTime:endTime]];
    }else if (startTime > 0 && endTime > 0) {
        if (startTime < endTime) {
             if ([NSString getMonthDayWithTime:startTime] != [NSString getMonthDayWithTime:endTime]) {
                 // 不是同一天
                 return [NSString stringWithFormat:@"%@%@%@", [NSString getMonthDateWithTime:startTime], NSLocalizableString(@"to", nil),[NSString getMonthDateWithTime:endTime]];
             } else {
                 return [NSString stringWithFormat:@"%@%@%@", [NSString getMonthDateWithTime:startTime], NSLocalizableString(@"to", nil),[NSString getHoserWithTime:endTime]];
             }
        }
    } else if (startTime > 0 && endTime <= 0) {
        return [NSString stringWithFormat:@"%@%@%@", [NSString getMonthDateWithTime:startTime],NSLocalizableString(@"to", nil),NSLocalizableString(@"unlimited", nil)];
    }
    return NSLocalizableString(@"timeError", nil);
}

+(NSString *)getMonthDateWithTime:(NSInteger)time {

    if (time <= 0) {
        return NSLocalizableString(@"unlimited", nil);
    }
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"MM-dd HH:mm"];

    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:time];

    NSString *startStr = [dateFormat stringFromDate:startDate];

    return startStr;
}

+(NSString *)getHoserWithTime:(NSInteger)time {
    if (time <= 0) {
        return NSLocalizableString(@"unlimited", nil);
    }
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"HH:mm"];

    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:time];

    NSString *startStr = [dateFormat stringFromDate:startDate];

    return startStr;
}


+(NSString *)getMonthDayWithTime:(NSInteger)time {
    if (time <= 0) {
        return NSLocalizableString(@"unlimited", nil);
    }
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];

    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:time];

    NSString *startStr = [dateFormat stringFromDate:startDate];

    return startStr;
}

+(NSString *)getYearWithTime:(NSInteger)time {
    if (time <= 0) {
        return NSLocalizableString(@"unlimited", nil);
    }
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy"];

    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:time];

    NSString *startStr = [dateFormat stringFromDate:startDate];

    return startStr;
}



+(NSString *)getYearDateWithTime:(NSInteger)time {

    if (time <= 0) {
        return NSLocalizableString(@"unlimited", nil);
    }
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];

    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:time];

    NSString *startStr = [dateFormat stringFromDate:startDate];

    return startStr;
}



@end
