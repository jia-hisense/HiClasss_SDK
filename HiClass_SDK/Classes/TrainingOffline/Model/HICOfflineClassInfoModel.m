//
//  HICOfflineClassInfoModel.m
//  HiClass
//
//  Created by hisense on 2020/4/23.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import "HICOfflineClassInfoModel.h"
#import "NSString+String.h"

@implementation HICOfflineClassInfoModel


//+(NSDictionary *)mj_replacedKeyFromPropertyName {
//    return @{@"roleMenuID":@"id"};
//}


+ (NSDictionary *)mj_objectClassInArray {
    return @{@"referenceMaterials" : @"HICReferenceMaterial", @"classPerformRating":@"HICClassPerformRating", @"subTasks":@"HICSubTask"};
}


- (NSString *)getLocationStr {
    NSString *location = @"--";
    if ([NSString isValidString:_location]) {
        location = _location;
    }

    return location;
}

- (NSString *)getCourseHourStr {

    NSMutableString *hour = [NSMutableString stringWithString:@"--"];
    if (_startTime*_endTime < 0 || (_endTime - _startTime) < 0) {
        return hour;
    }

    NSInteger startTime = self.startTime;
    if ([NSString stringWithFormat:@"%ld",(long)_startTime].length > 10)  {
        startTime = startTime/1000;
    }
    NSInteger endTime = self.endTime;
    if ([NSString stringWithFormat:@"%ld",(long)_endTime].length > 10)  {
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

- (NSString *)getClassDurationStr {

    if (!_classDuration || _classDuration.integerValue < 0) {
        return @"--";
    }

    NSInteger hours = _classDuration.integerValue/60;
    NSInteger mins = _classDuration.integerValue%60;


    NSMutableString *hour = [[NSMutableString alloc] initWithString:@""];

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

- (NSString *)getCommentStr {
    if ([NSString isValidString:self.comment]) {
        return self.comment;
    }
    return NSLocalizableString(@"noIntroduction", nil);
}


- (NSString *)getRewardStr {

//    NSString *rewardPoints = @"积分：--";
//    if (_rewardPoints) {
//        rewardPoints = [NSString stringWithFormat:@"积分：%ld", _rewardPoints.integerValue];
//    }

    NSString *rewardCredit = [NSString stringWithFormat:@"%@：--",NSLocalizableString(@"credits", nil)];
    if (_rewardCredit && _rewardCredit.floatValue >= 0) {
        rewardCredit = [NSString stringWithFormat:@"%@：%@",  NSLocalizableString(@"credits", nil),[NSString formatFloat:_rewardCredit.floatValue]];
    }

    NSString *rewardCreditHours = [NSString stringWithFormat:@"%@：--",NSLocalizableString(@"studyTime", nil)];
    if (_rewardCreditHours && _rewardCreditHours.integerValue >= 0) {
        rewardCreditHours = [NSString stringWithFormat:@"%@：%ld%@", NSLocalizableString(@"studyTime", nil),(long)_rewardCreditHours.integerValue,NSLocalizableString(@"minutes", nil)];
    }

    return [NSString stringWithFormat:@"%@\n%@", rewardCredit, rewardCreditHours];

}

- (NSString *)trainees {
    if ([NSString isValidString:_trainees]) {
        return  _trainees;
    }
    return NSLocalizableString(@"noNow", nil);
}

- (NSString *)lecturerInfo {
    if ([NSString isValidString:_lecturerInfo]) {
        return _lecturerInfo;
    }
    return NSLocalizableString(@"noIntroduction", nil);
}

@end




@implementation HICOfflineTransFile
+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"hashStr":@"hash"};
}

@end


@implementation HICReferenceMaterial

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"transFiles" : @"HICOfflineTransFile"};
}

- (NSString *)iconOfMaterial {
    if (self.type == Image) {
        return @"知识类型-图片";
    }

    if (self.type == Video) {
        return @"知识类型-视频";
    }
    if (self.type == Voice) {
        return @"知识类型-音频";
    }

    NSString *icon = @"知识课程默认图标";

    if ([NSString isValidString:self.docType]) {
        NSString *docType = self.docType.lowercaseString;

        if ([docType containsString:@"xlsx"] || [docType containsString:@"xls"]) {
            icon = @"知识类型-文档-XLS";
        }
        if ([docType containsString:@"docx"] || [docType containsString:@"doc"]) {
            icon = @"知识类型-文档-WORD";
        }
        if ([docType containsString:@"pptx"] || [docType containsString:@"ppt"]) {
            icon = @"知识类型-文档-PPT";
        }
        if ([docType containsString:@"pdf"]) {
            icon = @"知识类型-文档-PDF";
        }
        if ([docType containsString:@"pps"]) {
            icon = @"知识类型-文档-PPS";
        }
    }

    return icon;
}

@end

@implementation HICClassPerformRating


@end
