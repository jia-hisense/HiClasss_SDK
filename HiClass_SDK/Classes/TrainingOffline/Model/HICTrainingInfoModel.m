//
//  HICTrainingInfoModel.m
//  HiClass
//
//  Created by hisense on 2020/4/14.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import "HICTrainingInfoModel.h"
#import "NSString+String.h"
#import "HICCommonUtils.h"

@implementation HICOfflineCertificate


@end

@implementation HICTrainingInfoModel


+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"trainingId":@"id"};
}
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"certificateList" : @"HICOfflineCertificate"};
}


- (NSString *)trainGoal {
    if ([NSString isValidString:_trainGoal]) {
        return _trainGoal;
    }
    return NSLocalizableString(@"noNow", nil);
}

- (NSString *)trainAudience {
    if ([NSString isValidString:_trainAudience]) {
        return _trainAudience;
    }
    return NSLocalizableString(@"noNow", nil);
}


- (NSString *)mode {
    if ([NSString isValidString:_mode]) {
        return _mode;
    }
    _mode = NSLocalizableString(@"offlineTraining", nil);
    return _mode;
}

- (NSString *)trainComment {
    if ([NSString isValidString:_trainComment]) {
        return _trainComment;
    }
    return NSLocalizableString(@"noIntroduction", nil);
}

- (NSString *)getLevelStr {
    NSString *levelStr = @"--";
    if (_trainLevel == 1) {
        levelStr = NSLocalizableString(@"groupLevel", nil);
    } else if (_trainLevel == 2) {
        levelStr = NSLocalizableString(@"corporateLevel", nil);
    } else if (_trainLevel == 3) {
        levelStr = NSLocalizableString(@"departmentalLevel", nil);
    }

    return levelStr;
}


- (NSString *)getTeacherEvalScoreStr {
    if (_trainResult == nil || _trainResult.floatValue <= 0) {
        return @"--";
    }
    if (_trainConclusion == HICTrainGradeUndergraduate) {
        return NSLocalizableString(@"studyInSchoolstudy", nil);
    }
    return [NSString stringWithFormat:@"%@%@", [NSString formatFloat:_trainResult.floatValue],NSLocalizableString(@"points", nil)];
}

- (NSString *)getRewardPointsStr {
    if (_rewardCredits == nil || _rewardCredits.doubleValue < 0) {
        return @"--";
    }
    return [NSString formatFloat:_rewardCredits.doubleValue];
}

- (NSString *)getRewardCreditMinsStr {
    if (_rewardCreditHours == nil || _rewardCreditHours.integerValue < 0) {
        return  @"--";
    }

    NSInteger rewardCreditMin = _rewardCreditHours.integerValue;

    return [NSString stringWithFormat:@"%@%@", [NSString stringWithFormat:@"%ld", (long)rewardCreditMin],NSLocalizableString(@"minutes", nil)];
}

- (NSString *)getTrainManagerStr {
    if ([NSString isValidString:_trainManager]) {
        NSArray *managers = [_trainManager componentsSeparatedByString:@","];
        NSMutableString *managerStr = [[NSMutableString alloc] init];
        for (int i = 0; i < managers.count; i++) {
            NSString *manager = managers[i];
            if ([NSString isValidString:manager]) {
                [managerStr appendString:manager];
            }
        }
        if (managers.count > 0 && [NSString isValidString:managerStr]) {
            return managerStr;
        }
    }

    return @"--";
}

- (NSString *)getCertificateListStr {
    NSMutableString *result = [[NSMutableString alloc] init];
    if (_certificateList.count > 0) {
        for (int i = 0; i < _certificateList.count; i++) {
            NSString *certName = _certificateList[i].certName;
            if ([NSString isValidString:certName]) {
                [result appendString:certName];
                [result appendString:@" "];
            }
        }
        if (result.length > 1) {
            return [result substringToIndex:result.length-1];
        }
    }

    [result appendString:@"--"];

    return result;
}

@end
