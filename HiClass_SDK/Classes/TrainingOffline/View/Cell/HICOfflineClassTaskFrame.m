//
//  HICOfflineClassTaskFrame.m
//  HiClass
//
//  Created by hisense on 2020/4/26.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import "HICOfflineClassTaskFrame.h"
#import "NSString+String.h"
#import "NSString+HICUtilities.h"

@implementation HICOfflineTextAttribute


@end

@implementation HICOfflineClassTaskFrame
+ (instancetype)initWithTask:(HICSubTask *)task isSeparatorHidden:(BOOL)isSeparatorHidden  alpha:(CGFloat)alpha {

    HICOfflineClassTaskFrame *data = [[HICOfflineClassTaskFrame alloc] init];
    data.alpha = alpha;
    data.isSeparatorHidden = isSeparatorHidden;
    data.task = task;
    return data;

}

- (void)setTask:(HICSubTask *)task {
    _task = task;

    HICOfflineTextAttribute *typeLblAtt = [[HICOfflineTextAttribute alloc] init];
    HICOfflineTextAttribute *titleLblAtt = [[HICOfflineTextAttribute alloc] init];
    HICOfflineTextAttribute *operateBtnAtt = [[HICOfflineTextAttribute alloc] init];
    HICOfflineTextAttribute *timeLblAtt = [[HICOfflineTextAttribute alloc] init];
    HICOfflineTextAttribute *locationLblAtt = [[HICOfflineTextAttribute alloc] init];
    HICOfflineTextAttribute *bottomMapBtnAtt = [[HICOfflineTextAttribute alloc] init];
    HICOfflineTextAttribute *bottomTimeBtnAtt = [[HICOfflineTextAttribute alloc] init];

    operateBtnAtt.isBtnEnable = NO;
    bottomMapBtnAtt.isBtnEnable = NO;
    bottomTimeBtnAtt.isBtnEnable = NO;


    switch (_task.taskType) {

        case Homework:
            typeLblAtt.textColor = [UIColor colorWithHexString:@"#4A90E2"];
            typeLblAtt.textFont = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
            typeLblAtt.value = NSLocalizableString(@"homework", nil);



            titleLblAtt.textColor = [UIColor colorWithHexString:@"#333333"];
            titleLblAtt.textFont = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
            titleLblAtt.value = [NSString realString:_task.taskName];



            switch (_task.workStatus) {
                case NotStart:
                    operateBtnAtt.textColor = [UIColor colorWithHexString:@"#999999"];
                    operateBtnAtt.textFont = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
                    operateBtnAtt.value = NSLocalizableString(@"notStarted", nil);
                    operateBtnAtt.isBtnEnable = YES;


                    timeLblAtt.textColor = [UIColor colorWithHexString:@"#858585"];
                    timeLblAtt.textFont = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
                    timeLblAtt.value = [NSString stringWithFormat:@"%@：%@", NSLocalizableString(@"dendline", nil),[NSString getMonthDateWithTime:_task.endTime]];


                    locationLblAtt = nil;
                    bottomMapBtnAtt = nil;
                    bottomTimeBtnAtt = nil;

                    break;
                case Ongoing:
                    operateBtnAtt.textColor = [UIColor colorWithHexString:@"#FF8500"];
                    operateBtnAtt.textFont = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
                    operateBtnAtt.value = NSLocalizableString(@"pending", nil);
                    operateBtnAtt.isBtnEnable = YES;


                    timeLblAtt.textColor = [UIColor colorWithHexString:@"#858585"];
                    timeLblAtt.textFont = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
                    timeLblAtt.value = [NSString stringWithFormat:@"%@：%@", NSLocalizableString(@"dendline", nil),[NSString getMonthDateWithTime:_task.endTime]];


                    // 判断是否超时
                    if (_task.curTime > _task.endTime && _task.endTime > 0) {
                        locationLblAtt.textColor = [UIColor colorWithHexString:@"#FF8500"];
                        locationLblAtt.textFont = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
                        locationLblAtt.value = [NSString stringWithFormat:@"%@！",NSLocalizableString(@"timeoutWarning", nil)];
                    } else {
                        locationLblAtt = nil;
                    }


                    bottomMapBtnAtt = nil;
                    bottomTimeBtnAtt = nil;


                    break;
                case Unapproved:
                    operateBtnAtt.textColor = [UIColor colorWithHexString:@"#4A90E2"];
                    operateBtnAtt.textFont = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
                    operateBtnAtt.value = NSLocalizableString(@"waitExamines", nil);
                    operateBtnAtt.isBtnEnable = YES;


                    timeLblAtt.textColor = [UIColor colorWithHexString:@"#858585"];
                    timeLblAtt.textFont = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
                    timeLblAtt.value = [NSString stringWithFormat:@"%@：%@", NSLocalizableString(@"submitTime", nil),[NSString getMonthDateWithTime:_task.workJobCommitTime]];


                    locationLblAtt = nil;
                    bottomMapBtnAtt = nil;
                    bottomTimeBtnAtt = nil;


                    break;
                case Approving:
                    operateBtnAtt.textColor = [UIColor colorWithHexString:@"#4A90E2"];
                    operateBtnAtt.textFont = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
                    operateBtnAtt.value = NSLocalizableString(@"reviewing", nil);
                    operateBtnAtt.isBtnEnable = YES;


                    timeLblAtt.textColor = [UIColor colorWithHexString:@"#858585"];
                    timeLblAtt.textFont = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
                    timeLblAtt.value = [NSString stringWithFormat:@"%@：%@", NSLocalizableString(@"submitTime", nil),[NSString getMonthDateWithTime:_task.workJobCommitTime]];


                    locationLblAtt = nil;
                    bottomMapBtnAtt = nil;
                    bottomTimeBtnAtt = nil;

                    break;
                case Done:
                    operateBtnAtt.textColor = [UIColor colorWithHexString:@"#14BE6E"];
                    operateBtnAtt.textFont = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
                    operateBtnAtt.value = NSLocalizableString(@"hasBeenCompleted", nil);
                    operateBtnAtt.isBtnEnable = YES;


                    timeLblAtt.textColor = [UIColor colorWithHexString:@"#858585"];
                    timeLblAtt.textFont = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
                    timeLblAtt.value = [NSString stringWithFormat:@"%@：%@", NSLocalizableString(@"submitTime", nil),[NSString getMonthDateWithTime:_task.workJobCommitTime]];


                    locationLblAtt = nil;
                    bottomMapBtnAtt = nil;
                    bottomTimeBtnAtt = nil;

                    break;
            }

            break;
        case Questionnaire:
            typeLblAtt.textColor = [UIColor colorWithHexString:@"#4A90E2"];
            typeLblAtt.textFont = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
            typeLblAtt.value = NSLocalizableString(@"questionnaire", nil);

            titleLblAtt.textColor = [UIColor colorWithHexString:@"#333333"];
            titleLblAtt.textFont = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
            titleLblAtt.value = [NSString realString:_task.taskName];

            timeLblAtt.textColor = [UIColor colorWithHexString:@"#858585"];
            timeLblAtt.textFont = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
            timeLblAtt.value = [NSString stringWithFormat:@"%@：%@",NSLocalizableString(@"theQuestionnaireOfTime", nil), [NSString getTimeFormate:_task.startTime andEndTime:_task.endTime]];


            if (_task.questionCommitTime <= 0) {
                if (_task.startTime > _task.curTime) {
                    // 未开始
                    operateBtnAtt.textColor = [UIColor colorWithHexString:@"#858585"];
                    operateBtnAtt.textFont = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
                    operateBtnAtt.value = NSLocalizableString(@"notStarted", nil);
                    operateBtnAtt.isBtnEnable = NO;

                    locationLblAtt = nil;
                    bottomMapBtnAtt = nil;
                    bottomTimeBtnAtt = nil;

                    self.alpha = 0.5;

                } else if (_task.endTime > 0 && _task.endTime < _task.curTime) {
                    // 过期
                    operateBtnAtt.textColor = [UIColor colorWithHexString:@"#858585"];
                    operateBtnAtt.textFont = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
                    operateBtnAtt.value = NSLocalizableString(@"overdue", nil);
                    operateBtnAtt.isBtnEnable = NO;

                    locationLblAtt = nil;
                    bottomMapBtnAtt = nil;
                    bottomTimeBtnAtt = nil;

                    self.alpha = 0.5;

                } else if (_task.startTime < _task.curTime || _task.endTime <= 0) {
                    // 立即参与
                    operateBtnAtt.textColor = [UIColor colorWithHexString:@"#00BED7"];
                    operateBtnAtt.textFont = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
                    operateBtnAtt.value = NSLocalizableString(@"immediatelyParticipateIn", nil);
                    operateBtnAtt.isBtnEnable = YES;

                    locationLblAtt = nil;
                    bottomMapBtnAtt = nil;
                    bottomTimeBtnAtt = nil;
                }
            } else {
                // 已完成
                operateBtnAtt.textColor = [UIColor colorWithHexString:@"#858585"];
                operateBtnAtt.textFont = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
                operateBtnAtt.value = NSLocalizableString(@"hasBeenCompleted", nil);
                operateBtnAtt.isBtnEnable = NO;

                self.alpha = 0.5;


                locationLblAtt = nil;
                bottomMapBtnAtt = nil;
                bottomTimeBtnAtt = nil;
            }

            break;
        case Evaluate:
            typeLblAtt.textColor = [UIColor colorWithHexString:@"#4A90E2"];
            typeLblAtt.textFont = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
            typeLblAtt.value = NSLocalizableString(@"evaluation", nil);



            titleLblAtt.textColor = [UIColor colorWithHexString:@"#333333"];
            titleLblAtt.textFont = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
            titleLblAtt.value = [NSString realString:_task.taskName];

            timeLblAtt.textColor = [UIColor colorWithHexString:@"#858585"];
            timeLblAtt.textFont = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
            timeLblAtt.value = [NSString stringWithFormat:@"%@：%@", NSLocalizableString(@"evaluationTime", nil),[NSString getTimeFormate:_task.startTime andEndTime:_task.endTime]];


            if (_task.questionCommitTime <= 0) {
                if (_task.startTime > _task.curTime) {
                    // 未开始
                    operateBtnAtt.textColor = [UIColor colorWithHexString:@"#858585"];
                    operateBtnAtt.textFont = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
                    operateBtnAtt.value = NSLocalizableString(@"notStarted", nil);
                    operateBtnAtt.isBtnEnable = NO;


                    locationLblAtt = nil;
                    bottomMapBtnAtt = nil;
                    bottomTimeBtnAtt = nil;

                    self.alpha = 0.5;

                } else if (_task.endTime > 0 && _task.endTime < _task.curTime) {
                    // 过期
                    operateBtnAtt.textColor = [UIColor colorWithHexString:@"#858585"];
                    operateBtnAtt.textFont = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
                    operateBtnAtt.value = NSLocalizableString(@"overdue", nil);
                    operateBtnAtt.isBtnEnable = NO;

                    locationLblAtt = nil;
                    bottomMapBtnAtt = nil;
                    bottomTimeBtnAtt = nil;

                    self.alpha = 0.5;

                } else if (_task.startTime < _task.curTime || _task.endTime <= 0) {
                    // 立即参与
                    operateBtnAtt.textColor = [UIColor colorWithHexString:@"#00BED7"];
                    operateBtnAtt.textFont = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
                    operateBtnAtt.value = NSLocalizableString(@"immediatelyParticipateIn", nil);
                    operateBtnAtt.isBtnEnable = YES;

                    locationLblAtt = nil;
                    bottomMapBtnAtt = nil;
                    bottomTimeBtnAtt = nil;
                }
            } else {
                // 已完成
                operateBtnAtt.textColor = [UIColor colorWithHexString:@"#858585"];
                operateBtnAtt.textFont = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
                operateBtnAtt.value = NSLocalizableString(@"hasBeenCompleted", nil);
                operateBtnAtt.isBtnEnable = NO;

                locationLblAtt = nil;
                bottomMapBtnAtt = nil;
                bottomTimeBtnAtt = nil;

                self.alpha = 0.5;

            }

            break;
        case SignIn:

            typeLblAtt.textColor = [UIColor colorWithHexString:@"#4A90E2"];
            typeLblAtt.textFont = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
            typeLblAtt.value = NSLocalizableString(@"signIn", nil);


            titleLblAtt.textColor = [UIColor colorWithHexString:@"#333333"];
            titleLblAtt.textFont = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
            titleLblAtt.value = [NSString realString:_task.taskName];

            timeLblAtt.textColor = [UIColor colorWithHexString:@"#858585"];
            timeLblAtt.textFont = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
            timeLblAtt.value = [NSString stringWithFormat:@"%@：%@", NSLocalizableString(@"checkInTime", nil),[NSString getTimeFormate:_task.attendanceRequires.startTime andEndTime:_task.attendanceRequires.endTime]];

            BOOL isEnableSignNow = NO;

            if (_task.attendanceExeTime <= 0 && (_task.curTime <= _task.attendanceRequires.endTime+_task.attendanceRequires.lateArrivalThreshold || _task.attendanceRequires.endTime <= 0)) {
                isEnableSignNow = YES;

                operateBtnAtt.textColor = [UIColor colorWithHexString:@"#00BED7"];
                operateBtnAtt.textFont = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
                operateBtnAtt.value = NSLocalizableString(@"signInImmediately", nil);
                operateBtnAtt.isBtnEnable = YES;

                bottomTimeBtnAtt = nil;

            } else if (_task.attendanceExeTime <= 0 && (_task.curTime > _task.attendanceRequires.endTime+_task.attendanceRequires.lateArrivalThreshold && _task.attendanceRequires.endTime > 0)) {
                // 没有签到时间 同时 已过签到范围的

                operateBtnAtt.textColor = [UIColor colorWithHexString:@"#FF4B4B"];
                operateBtnAtt.textFont = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
                operateBtnAtt.value = NSLocalizableString(@"absenteeism", nil);
                operateBtnAtt.isBtnEnable = NO;

                bottomTimeBtnAtt = nil;

            } else if (_task.attendanceExeTime > 0) {
                // 已经有签到时间的
                if (_task.attendanceExeTime <= _task.attendanceRequires.endTime || _task.attendanceRequires.endTime <= 0) {
                    // 正常签到
                    operateBtnAtt.textColor = [UIColor colorWithHexString:@"#999999"];
                    operateBtnAtt.textFont = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
                    operateBtnAtt.value = NSLocalizableString(@"alreadySignedIn", nil);
                    operateBtnAtt.isBtnEnable = NO;

                    bottomTimeBtnAtt.textColor = [UIColor colorWithHexString:@"#999999"];
                    bottomTimeBtnAtt.textFont = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
                    bottomTimeBtnAtt.value = [NSString getHoserWithTime:_task.attendanceExeTime];
                    bottomTimeBtnAtt.isBtnEnable = NO;
                } else if (_task.attendanceExeTime < _task.attendanceRequires.endTime+_task.attendanceRequires.lateArrivalThreshold && _task.attendanceExeTime > _task.attendanceRequires.endTime && _task.attendanceRequires.endTime > 0) {
                    // 迟到
                    operateBtnAtt.textColor = [UIColor colorWithHexString:@"#FF8500"];
                    operateBtnAtt.textFont = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
                    operateBtnAtt.value = NSLocalizableString(@"late", nil);
                    operateBtnAtt.isBtnEnable = NO;

                    bottomTimeBtnAtt.textColor = [UIColor colorWithHexString:@"#FF8500"];
                    bottomTimeBtnAtt.textFont = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
                    bottomTimeBtnAtt.value = [NSString getHoserWithTime:_task.attendanceExeTime];
                    bottomTimeBtnAtt.isBtnEnable = NO;
                }
            }

            if (_task.attendanceRequires.latitude >0 && _task.attendanceRequires.longitude >0 && _task.attendanceRequires.radius > 0) {
                if (isEnableSignNow) {
                    locationLblAtt.textColor = [UIColor colorWithHexString:@"#858585"];
                    locationLblAtt.textFont = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
                    locationLblAtt.value = [NSString stringWithFormat:@"%@：",NSLocalizableString(@"checkInPlace", nil)];

                    bottomMapBtnAtt.textColor = [UIColor colorWithHexString:@"#00BED7"];
                    bottomMapBtnAtt.textFont = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
                    bottomMapBtnAtt.value = [NSString stringWithFormat:@"%@>",NSLocalizableString(@"checkRange", nil)];
                    bottomMapBtnAtt.isBtnEnable = YES;
                } else {
                    locationLblAtt = nil;
                    bottomMapBtnAtt = nil;
                }
            } else {
                locationLblAtt = nil;
                bottomMapBtnAtt = nil;
            }


            break;
        case SignBack:

            typeLblAtt.textColor = [UIColor colorWithHexString:@"#4A90E2"];
            typeLblAtt.textFont = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
            typeLblAtt.value = NSLocalizableString(@"signBack", nil);

            titleLblAtt.textColor = [UIColor colorWithHexString:@"#333333"];
            titleLblAtt.textFont = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
            titleLblAtt.value = [NSString realString:_task.taskName];

            timeLblAtt.textColor = [UIColor colorWithHexString:@"#858585"];
            timeLblAtt.textFont = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
            timeLblAtt.value = [NSString stringWithFormat:@"%@：%@",NSLocalizableString(@"signBackTime", nil),[NSString getTimeFormate:_task.attendanceRequires.startTime andEndTime:_task.attendanceRequires.endTime]];

            BOOL isEnableSignBack = NO;

            if (_task.attendanceExeTime <= 0 && (_task.curTime <= _task.attendanceRequires.endTime+_task.attendanceRequires.lateArrivalThreshold || _task.attendanceRequires.endTime <= 0)) {
                // 没有签退时间 并且可以签退
                isEnableSignBack = YES;

                operateBtnAtt.textColor = [UIColor colorWithHexString:@"#00BED7"];
                operateBtnAtt.textFont = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
                operateBtnAtt.value = NSLocalizableString(@"signBackImmediately", nil);
                operateBtnAtt.isBtnEnable = YES;

                bottomTimeBtnAtt = nil;
            } else if (_task.attendanceExeTime <= 0 && _task.curTime > _task.attendanceRequires.endTime+_task.attendanceRequires.lateArrivalThreshold && _task.attendanceRequires.endTime > 0) {
                // 没有签到时间 同时 已过签到范围的
                operateBtnAtt.textColor = [UIColor colorWithHexString:@"#FF4B4B"];
                operateBtnAtt.textFont = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
                operateBtnAtt.value = NSLocalizableString(@"absenteeism", nil);
                operateBtnAtt.isBtnEnable = NO;

                bottomTimeBtnAtt = nil;
            } else if (_task.attendanceExeTime > 0) {
                // 已经提交签退
                if ((_task.attendanceExeTime <= _task.attendanceRequires.endTime + _task.attendanceRequires.lateArrivalThreshold || _task.attendanceRequires.endTime <= 0) && _task.attendanceExeTime >= _task.attendanceRequires.startTime) {
                    // 正常签退
                    operateBtnAtt.textColor = [UIColor colorWithHexString:@"#999999"];
                    operateBtnAtt.textFont = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
                    operateBtnAtt.value = NSLocalizableString(@"hasSignedBack", nil);
                    operateBtnAtt.isBtnEnable = NO;

                    bottomTimeBtnAtt.textColor = [UIColor colorWithHexString:@"#999999"];
                    bottomTimeBtnAtt.textFont = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
                    bottomTimeBtnAtt.value = [NSString getHoserWithTime:_task.attendanceExeTime];
                    bottomTimeBtnAtt.isBtnEnable = NO;
                } else if (_task.attendanceExeTime < _task.attendanceRequires.startTime && _task.attendanceRequires.startTime > 0) {
                    // 早退
                    isEnableSignBack = YES;

                    operateBtnAtt.textColor = [UIColor colorWithHexString:@"#FF8500"];
                    operateBtnAtt.textFont = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
                    operateBtnAtt.value = NSLocalizableString(@"leaveEarly", nil);
                    operateBtnAtt.isBtnEnable = NO;

                    bottomTimeBtnAtt.textColor = [UIColor colorWithHexString:@"#FF8500"];
                    bottomTimeBtnAtt.textFont = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
                    bottomTimeBtnAtt.value = [NSString stringWithFormat:@"%@ %@", [NSString getHoserWithTime:_task.attendanceExeTime],NSLocalizableString(@"refresh", nil)];
                    bottomTimeBtnAtt.isBtnEnable = YES;
                    
                    // 是否超过了最后的签到时间
                    if (_task.attendanceRequires.endTime > 0 && _task.attendanceRequires.endTime + _task.attendanceRequires.lateArrivalThreshold < _task.curTime) {
                        // 早退的签到，但是 - 当前的时间已经大于最后的签退时间
                        bottomTimeBtnAtt.value = [NSString getHoserWithTime:_task.attendanceExeTime];
                        bottomTimeBtnAtt.isBtnEnable = NO;
                    }
                } else if (_task.attendanceExeTime > _task.attendanceRequires.endTime+_task.attendanceRequires.lateArrivalThreshold) {
                    operateBtnAtt.textColor = [UIColor colorWithHexString:@"#FF4B4B"];
                    operateBtnAtt.textFont = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
                    operateBtnAtt.value = NSLocalizableString(@"absenteeism", nil);
                    operateBtnAtt.isBtnEnable = NO;

                    bottomTimeBtnAtt = nil;
                } else {
                    operateBtnAtt = nil;
                    bottomTimeBtnAtt = nil;
                }
            }

            if (_task.attendanceRequires.latitude >0 && _task.attendanceRequires.longitude >0 && _task.attendanceRequires.radius > 0) {
                if (isEnableSignBack) {
                    locationLblAtt.textColor = [UIColor colorWithHexString:@"#858585"];
                    locationLblAtt.textFont = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
                    locationLblAtt.value = [NSString stringWithFormat:@"%@：",NSLocalizableString(@"signBackPlace", nil)];

                    bottomMapBtnAtt.textColor = [UIColor colorWithHexString:@"#00BED7"];
                    bottomMapBtnAtt.textFont = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
                    bottomMapBtnAtt.value = [NSString stringWithFormat:@"%@>",NSLocalizableString(@"checkRange", nil)];
                    bottomMapBtnAtt.isBtnEnable = YES;
                } else {
                    locationLblAtt = nil;
                    bottomMapBtnAtt = nil;
                }

            } else {
                locationLblAtt = nil;
                bottomMapBtnAtt = nil;
            }

            break;
        default:

            break;
    }


    self.typeLblAtt = typeLblAtt;
    self.titleLblAtt = titleLblAtt;
    self.operateBtnAtt = operateBtnAtt;
    self.timeLblAtt = timeLblAtt;
    self.locationLblAtt = locationLblAtt;
    self.bottomTimeBtnAtt = bottomTimeBtnAtt;
    self.bottomMapBtnAtt = bottomMapBtnAtt;


//    if (_typeLblAtt && _titleLblAtt && _operateBtnAtt && _timeLblAtt) {
//
//
//    }

    CGFloat leftPadding = 16;
    CGFloat rightPadding = 16;
    CGFloat topPadding = 16;
    CGFloat bottomPadding = 16;
    CGFloat cellW = HIC_ScreenWidth;



    _typeLblF = CGRectMake(leftPadding, topPadding, 32, 21);
    _operateBtnF = CGRectMake(cellW-(rightPadding+70), CGRectGetMinX(_typeLblF), 70, CGRectGetHeight(_typeLblF));
    _titleLblF = CGRectMake(CGRectGetMaxX(_typeLblF)+3, CGRectGetMinY(_typeLblF), CGRectGetMinX(_operateBtnF)-CGRectGetMaxX(_typeLblF), CGRectGetHeight(_typeLblF));

    CGFloat rightX = cellW-rightPadding;
    CGFloat topY = CGRectGetMaxY(_titleLblF);
    CGFloat timeLblFW = rightX- 2-leftPadding;
    if (_bottomTimeBtnAtt) {
        CGSize size = [_bottomTimeBtnAtt.value sizeWithFont:_bottomTimeBtnAtt.textFont maxSize:CGSizeMake(MAXFLOAT, 20)];
        _bottomTimeBtnF = CGRectMake(cellW-rightPadding-size.width, topY+8, size.width, 20);
        rightX = CGRectGetMinX(_bottomTimeBtnF);

        timeLblFW = CGRectGetMinX(_bottomTimeBtnF) - leftPadding;
    }


    timeLblFW = MIN(timeLblFW, rightX- 2-leftPadding);
    _timeLblF = CGRectMake(CGRectGetMinX(_typeLblF), topY+8, timeLblFW, 20);

    _cellHeight = CGRectGetMaxY(_timeLblF) + bottomPadding;



    if (_bottomMapBtnAtt) {
        CGFloat bottomMapBtnFH = 40;
        CGSize sizeMap = [_bottomMapBtnAtt.value sizeWithFont:_bottomMapBtnAtt.textFont maxSize:CGSizeMake(MAXFLOAT, 20)];
        CGSize sizeLocation = [_locationLblAtt.value sizeWithFont:_locationLblAtt.textFont maxSize:CGSizeMake(MAXFLOAT, 20)];

        if ((sizeMap.width+sizeLocation.width+1) > (cellW-rightPadding-leftPadding)) {
            _bottomMapBtnF = CGRectMake(cellW-sizeMap.width- rightPadding, CGRectGetMaxY(_timeLblF)+2-20, sizeMap.width, bottomMapBtnFH);
            _locationLblF = CGRectMake(leftPadding, CGRectGetMinY(_bottomMapBtnF), CGRectGetMinX(_bottomMapBtnF)-leftPadding-1, 20);

        } else {
            _locationLblF = CGRectMake(leftPadding, CGRectGetMaxY(_timeLblF)+2, sizeLocation.width, 20);
            _bottomMapBtnF = CGRectMake(CGRectGetMaxX(_locationLblF)+1, CGRectGetMaxY(_locationLblF)-bottomMapBtnFH, sizeMap.width, bottomMapBtnFH);
        }
        _cellHeight = CGRectGetMaxY(_locationLblF)+bottomPadding;
    } else if (_locationLblAtt) {
        _locationLblF = CGRectMake(leftPadding, CGRectGetMaxY(_timeLblF)+2, rightX-leftPadding, 20);
        _cellHeight = CGRectGetMaxY(_locationLblF)+bottomPadding;
    }

    _separatorLineViewF = CGRectMake(leftPadding, _cellHeight-0.5, cellW-leftPadding, 0.5);

}




@end
