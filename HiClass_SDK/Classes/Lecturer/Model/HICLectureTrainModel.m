//
//  HICLectureTrainModel.m
//  HiClass
//
//  Created by hisense on 2020/5/15.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import "HICLectureTrainModel.h"
#import "NSString+String.h"

@implementation HICLectureTrainModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list" : @"HICLectureTrainSubModel"};
}
@end


@implementation HICLectureTrainSubModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"classes" : @"HICLectureTrainSubCourseModel"};
}

@end


@implementation HICLectureTrainSubCourseModel

- (NSString *)getCourseHourStr {
    NSMutableString *hour = [NSMutableString stringWithString:@"--"];
    if (_classStartTime.integerValue*_classEndTime.integerValue < 0 || (_classEndTime.integerValue - _classStartTime.integerValue) < 0) {
        return hour;
    }

    NSInteger startTime = _classStartTime.integerValue;
    if ([NSString stringWithFormat:@"%ld",(long)_classStartTime.integerValue].length > 10)  {
        startTime = startTime/1000;
    }
    NSInteger endTime = _classEndTime.integerValue;
    if ([NSString stringWithFormat:@"%ld",(long)_classEndTime.integerValue].length > 10)  {
        endTime = endTime/1000;
    }

    NSInteger hours = (endTime-startTime)/3600;
    NSInteger mins = ((endTime-startTime)/60)%60;

    hour = [[NSMutableString alloc] initWithString:@""];

    if (hours > 0) {
        [hour appendFormat:@"%ld%@", (long)hours,NSLocalizableString(@"hours", nil)];
    }
    if (mins > 0) {
        [hour appendFormat:@"%ld%@", (long)mins,NSLocalizableString(@"minutes", nil)];
    }
    if (hours <= 0 && mins <= 0) {
        [hour appendFormat:@"0%@",NSLocalizableString(@"minutes", nil)];
    }
    
    return hour;
}

- (NSString *)classPlace {
    if (![NSString isValidString:_classPlace]) {
        return @"--";
    }
    return _classPlace;
}


@end
