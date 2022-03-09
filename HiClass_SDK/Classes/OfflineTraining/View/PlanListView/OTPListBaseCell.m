//
//  OTPListBaseCell.m
//  HiClass
//
//  Created by 铁柱， on 2020/4/16.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "OTPListBaseCell.h"

@interface OTPListBaseCell ()

@property (nonatomic, strong) UILabel *topLine;

@end

@implementation OTPListBaseCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#f8f8f8"];
        _circleColors = @[[UIColor colorWithHexString:@"#F59900"], [UIColor colorWithHexString:@"#979797"]];
        _allTimeLabelColors = @[[UIColor colorWithHexString:@"#F59900"], [UIColor colorWithHexString:@"#999999"]];
        // 创建一个时间控件和线
        [self createTimeView];
    }
    return self;
}

-(void)createTimeView {
    // 增加圆圈
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    circleLayer.strokeColor = [UIColor colorWithHexString:@"#F59900"].CGColor;
    circleLayer.fillColor = [UIColor clearColor].CGColor;
    circleLayer.lineWidth = 1.5;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(12, 21, 10, 10) cornerRadius:5];
    circleLayer.path = path.CGPath;
    _circleLayer = circleLayer;
    [self.contentView.layer addSublayer:circleLayer];

    // 增加timeLabel
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 16, 200, 20)];
    timeLabel.font = FONT_MEDIUM_14;
    timeLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    [self.contentView addSubview:timeLabel];

    // 增加线
    // 1. 圆顶部的线
    UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(17, 0, 0.5, 21)];
    topLabel.backgroundColor = [UIColor colorWithHexString:@"#D8D8D8"];
    [self.contentView addSubview:topLabel];
    _topLine = topLabel;

    // 2. 创建一个底部的线
    UILabel *bottomLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    bottomLabel.backgroundColor = [UIColor colorWithHexString:@"#D8D8D8"];
    [self.contentView addSubview:bottomLabel];
    [bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(31);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.width.offset(0.5);
        make.left.equalTo(self.contentView.mas_left).offset(17);
    }];

    // 增加背景
    UIView *backView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(30);
        make.right.equalTo(self.contentView.mas_right).offset(-16);
        make.top.equalTo(self.contentView.mas_top).offset(48);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-4);
    }];
    _contentBackView = backView;

    // 赋值
    _timeCellLabel = timeLabel;
}

-(void)setCellIndexPath:(NSIndexPath *)cellIndexPath {
    _cellIndexPath = cellIndexPath;
    if (cellIndexPath.row == 0) {
        self.topLine.hidden = YES;
    }else {
        self.topLine.hidden = NO;
    }
}

-(NSString *)getTimeFormate:(NSInteger)startTime andEndTime:(NSInteger)endTime {

    if (startTime <= 0 && endTime <= 0) {
        return NSLocalizableString(@"unlimited", nil);
    }else if (startTime <= 0 && endTime > 0) {
        return [NSString stringWithFormat:@"%@%@%@", [self getTimeStringWith:startTime], NSLocalizableString(@"to", nil),[self getTimeStringWith:endTime]];
    }else if (startTime > 0 && endTime > 0) {
        BOOL isSame = [self isSameSatrtTime:startTime endTime:endTime];
        if (!isSame) {
            // 不是同一天
            return [NSString stringWithFormat:@"%@%@%@", [self getTimeStringWith:startTime],NSLocalizableString(@"to", nil) ,[self getTimeStringWith:endTime]];
        }else if (isSame && endTime-startTime >=0) {
            return [NSString stringWithFormat:@"%@%@%@", [self getTimeStringWith:startTime], NSLocalizableString(@"to", nil),[self getHoserTimeStringWith:endTime]];
        }
    }else if (startTime > 0 && endTime <= 0) {
        return [NSString stringWithFormat:@"%@%@%@", [self getTimeStringWith:startTime],NSLocalizableString(@"to", nil),NSLocalizableString(@"unlimited", nil)];
    }
    return NSLocalizableString(@"timeError", nil);
}

-(NSString *)getTimeStringWith:(NSInteger)time {

    if (time <= 0) {
        return NSLocalizableString(@"unlimited", nil);
    }
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"MM-dd HH:mm"];

    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:time];

    NSString *startStr = [dateFormat stringFromDate:startDate];

    return startStr;
}

-(NSString *)getHoserTimeStringWith:(NSInteger)time {
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"HH:mm"];

    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:time];

    NSString *startStr = [dateFormat stringFromDate:startDate];

    return startStr;
}
// 是否为同一天
-(BOOL)isSameSatrtTime:(NSInteger)startTime endTime:(NSInteger)endTime {
    BOOL isSame = YES;

    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];

    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:startTime];
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:endTime];
    NSString *starStr = [dateFormat stringFromDate:startDate];
    NSString *endStr = [dateFormat stringFromDate:endDate];

    if (![starStr isEqualToString:endStr]) {
        isSame = NO;
    }
    return isSame;
}
// 统一设置，这样可以做到修改一个地方其他地方都能得到修改
-(void)setValueWith:(UILabel *)iconLabel timeLabel:(UILabel *)timeLabel but:(UIButton *)but titleLabel:(UILabel *)titleLabel commitLabel:(UILabel *)commitLabel signTypeLabel:(UILabel *)signTypeLabel againSignBut:(UIButton *)againSignBut backBut:(UIButton *)backBut model:(OfflineTrainingListModel *)model {
    // 赋值
    if (model.taskType == 3 ) {
        iconLabel.text = NSLocalizableString(@"exam", nil);
        commitLabel.hidden = NO;
        NSString *examCount = model.examAllowNum == 0 ? NSLocalizableString(@"notLimit", nil):[NSString stringWithFormat:@"%ld", (long)model.examAvaiNum];
        commitLabel.text = [NSString stringWithFormat:@"%@：%@", NSLocalizableString(@"numberOfTestsAvailable", nil),examCount];
        NSString *timeStr = [NSString stringWithFormat:@"%@：%@", NSLocalizableString(@"testTime", nil),[self getTimeFormate:model.startTime andEndTime:model.endTime]];
        timeLabel.text = timeStr;
        if (model.examStatus == 0) {
            [but setTitle:NSLocalizableString(@"notStarted", nil) forState:UIControlStateNormal];
//            but.enabled = NO; 类似于线上培训，未开始的考试也可以点击进入考试详情页
            [but setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        }else if (model.examStatus == 1) {
            [but setTitle:NSLocalizableString(@"immediatelyTest", nil) forState:UIControlStateNormal];
            [but setTitleColor:[UIColor colorWithHexString:@"#00BED7"] forState:UIControlStateNormal];
        }else if (model.examStatus == 2) {
            [but setTitle:NSLocalizableString(@"reviewing", nil) forState:UIControlStateNormal];
            [but setTitleColor:[UIColor colorWithHexString:@"#4A90E2"] forState:UIControlStateNormal];
        }else if (model.examStatus == 4) {
            [but setTitle:NSLocalizableString(@"lackOfTest", nil) forState:UIControlStateNormal];
            [but setTitleColor:[UIColor colorWithHexString:@"#FF4B4B"] forState:UIControlStateNormal];
        }else if (model.examStatus == 3) {
            [but setTitle:NSLocalizableString(@"hasBeenCompleted", nil) forState:UIControlStateNormal];
            [but setTitleColor:[UIColor colorWithHexString:@"#14BE6E"] forState:UIControlStateNormal];
            if (model.examPassScore > model.examScore) {
                // 如果通过成绩大于了得到成绩，即为不通过
                [but setTitle:NSLocalizableString(@"noPass", nil) forState:UIControlStateNormal];
                [but setTitleColor:[UIColor colorWithHexString:@"#FF4B4B"] forState:UIControlStateNormal];
            }else if (model.examPassScore <= model.examScore) {
                // 得到成绩不小于通过成绩
                [but setTitle:NSLocalizableString(@"pass", nil) forState:UIControlStateNormal];
                [but setTitleColor:[UIColor colorWithHexString:@"#14BE6E"] forState:UIControlStateNormal];
            }
        }else {
            but.hidden = YES;
            but.enabled = NO;
            backBut.enabled = NO;
        }
    }else if (model.taskType == 4) {
        iconLabel.text = NSLocalizableString(@"homework", nil);
        if (model.curTime > model.endTime && model.endTime > 0 && model.workStatus == 1) {
            // 进行中的作业 当前时间大于截止时间时显示提示
            commitLabel.hidden = NO;
            commitLabel.text = NSLocalizableString(@"timeoutWarning", nil);
            commitLabel.textColor = [UIColor colorWithHexString:@"#FF8500"];
        }
        if (model.workStatus == 0) {
            [but setTitle:NSLocalizableString(@"notStarted", nil) forState:UIControlStateNormal];
//            but.enabled = NO; 可点击
//            backBut.enabled = NO;
            [but setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
            if (model.endTime <= 0) {
                timeLabel.text = [NSString stringWithFormat:@"%@：%@",NSLocalizableString(@"dendline", nil),NSLocalizableString(@"unlimited", nil)];
            }else {
                timeLabel.text = [NSString stringWithFormat:@"%@：%@", NSLocalizableString(@"dendline", nil),[HICCommonUtils timeStampToReadableDate:[NSNumber numberWithInteger:model.endTime] isSecs:YES format:@"MM-dd HH:mm"]];
            }
        }else if (model.workStatus == 1) {
            [but setTitle:NSLocalizableString(@"pending", nil) forState:UIControlStateNormal];
            [but setTitleColor:[UIColor colorWithHexString:@"#FF8500"] forState:UIControlStateNormal];
            if (model.endTime <= 0) {
                timeLabel.text = [NSString stringWithFormat:@"%@：%@",NSLocalizableString(@"dendline", nil),NSLocalizableString(@"unlimited", nil)];
            }else {
                timeLabel.text = [NSString stringWithFormat:@"%@：%@", NSLocalizableString(@"dendline", nil),[HICCommonUtils timeStampToReadableDate:[NSNumber numberWithInteger:model.endTime] isSecs:YES format:@"MM-dd HH:mm"]];
            }
        }else if (model.workStatus == 3) {
            [but setTitle:NSLocalizableString(@"waitExamines", nil) forState:UIControlStateNormal];
            [but setTitleColor:[UIColor colorWithHexString:@"#4A90E2"] forState:UIControlStateNormal];
            timeLabel.text = [NSString stringWithFormat:@"%@：%@", NSLocalizableString(@"submitTime", nil),[HICCommonUtils timeStampToReadableDate:[NSNumber numberWithInteger:model.commitTime] isSecs:YES format:@"MM-dd HH:mm"]];
        }else if (model.workStatus == 4) {
            [but setTitle:NSLocalizableString(@"reviewing", nil) forState:UIControlStateNormal];
            [but setTitleColor:[UIColor colorWithHexString:@"#4A90E2"] forState:UIControlStateNormal];
            timeLabel.text = [NSString stringWithFormat:@"%@：%@", NSLocalizableString(@"submitTime", nil),[HICCommonUtils timeStampToReadableDate:[NSNumber numberWithInteger:model.commitTime] isSecs:YES format:@"MM-dd HH:mm"]];
        }else if (model.workStatus == 5) {
            [but setTitle:NSLocalizableString(@"hasBeenCompleted", nil) forState:UIControlStateNormal];
            [but setTitleColor:[UIColor colorWithHexString:@"#B9B9B9"] forState:UIControlStateNormal];
            timeLabel.text = [NSString stringWithFormat:@"%@：%@", NSLocalizableString(@"submitTime", nil),[HICCommonUtils timeStampToReadableDate:[NSNumber numberWithInteger:model.commitTime] isSecs:YES format:@"MM-dd HH:mm"]];
        }else {
            but.hidden = YES;
            but.enabled = NO;
            backBut.enabled = NO;
            timeLabel.text = [NSString stringWithFormat:@"%@：%@", NSLocalizableString(@"submitTime", nil),[HICCommonUtils timeStampToReadableDate:[NSNumber numberWithInteger:model.commitTime] isSecs:YES format:@"MM-dd HH:mm"]];
        }
    } else if (model.taskType == 6 || model.taskType == 7) {
        if (model.commitTime <= 0) {
            if (model.startTime > model.curTime) {
                // 评价未开始的
                [but setTitle:NSLocalizableString(@"notStarted", nil) forState:UIControlStateNormal];
                but.enabled = NO;
                backBut.enabled = NO;
                [but setTitleColor:[UIColor colorWithHexString:@"#B9B9B9"] forState:UIControlStateNormal];
            }else if (model.endTime > 0 && model.endTime < model.curTime) {
                // 评价过期
                [but setTitle:NSLocalizableString(@"expired", nil) forState:UIControlStateNormal];
                but.enabled = NO;
                backBut.enabled = NO;
                [but setTitleColor:[UIColor colorWithHexString:@"#858585"] forState:UIControlStateNormal];
                titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
                timeLabel.textColor = [UIColor colorWithHexString:@"#858585"];
                // 增加透明度
                but.alpha = 0.5;
                titleLabel.alpha = 0.5;
                timeLabel.alpha = 0.5;
            }else if (model.startTime < model.curTime || model.endTime <= 0) {
                [but setTitle:NSLocalizableString(@"immediatelyParticipateIn", nil) forState:UIControlStateNormal];
                [but setTitleColor:[UIColor colorWithHexString:@"#00BED7"] forState:UIControlStateNormal];
            }
        } else {
            [but setTitle:NSLocalizableString(@"hasBeenCompleted", nil) forState:UIControlStateNormal];
            but.enabled = NO;
            backBut.enabled = NO;
            [but setTitleColor:[UIColor colorWithHexString:@"#B9B9B9"] forState:UIControlStateNormal];
        }
        NSString *timeStr = [NSString stringWithFormat:@"%@：%@", NSLocalizableString(@"theQuestionnaireOfTime", nil),[self getTimeFormate:model.startTime andEndTime:model.endTime]];
        iconLabel.text = NSLocalizableString(@"questionnaire", nil);
        if (model.taskType == 7) {
            timeStr = [NSString stringWithFormat:@"%@：%@", NSLocalizableString(@"evaluationTime", nil),[self getTimeFormate:model.startTime andEndTime:model.endTime]];
            iconLabel.text = NSLocalizableString(@"evaluation", nil);
        }

        timeLabel.text = timeStr;
    } else if (model.taskType == 8) {
        iconLabel.text = NSLocalizableString(@"course", nil);
        commitLabel.hidden = NO;
        commitLabel.text = [NSString stringWithFormat:@"%@：%@", NSLocalizableString(@"lecturer", nil),model.lecturer];
        NSString *timeStr = [NSString stringWithFormat:@"%@：%@", NSLocalizableString(@"classTime", nil),[self getTimeFormate:model.startTime andEndTime:model.endTime]];
        timeLabel.text = timeStr;
        if (model.offclassExcptStatus == 1 || model.offclassExcptStatus == 2) {
            NSString *title = model.offclassExcptStatus == 1 ? NSLocalizableString(@"haveAskForLeave", nil):NSLocalizableString(@"undergraduateDegree", nil);
            UIColor *titleColor = model.offclassExcptStatus == 1 ? [UIColor colorWithHexString:@"#FF8500"]:[UIColor colorWithHexString:@"#FF8500"];
            [but setTitle:title forState:UIControlStateNormal];
            [but setTitleColor:titleColor forState:UIControlStateNormal];
        }else {
            but.hidden = YES;
            but.width = 0;
        }
    }if (model.taskType == 9) {
        iconLabel.text = NSLocalizableString(@"signIn", nil);
        // 签到，
        CGFloat timeWidth = 0;
        if (model.attendanceLastExeTime <= 0 && (model.curTime <= model.attendanceRequires.endTime+model.attendanceRequires.lateArrivalThreshold || model.attendanceRequires.endTime <= 0)) {
            // 没有签到时间 并且 可以签到
            if (model.attendanceRequires.latitude.doubleValue != 0 && model.attendanceRequires.longitude.doubleValue != 0 && model.attendanceRequires.radius != 0) {
                commitLabel.hidden = NO;
                NSMutableAttributedString * attriStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@：%@ >",NSLocalizableString(@"checkInPlace", nil),NSLocalizableString(@"checkSignInRange", nil)]];
                [attriStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#858585"] range:NSMakeRange(0, 5)];
                [attriStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#00BED7"] range:NSMakeRange(5, attriStr.length-5)];
                commitLabel.attributedText = attriStr;
            }
            timeWidth = 72.f;
            [but setTitle:NSLocalizableString(@"signInImmediately", nil) forState:UIControlStateNormal];
            [but setTitleColor:[UIColor colorWithHexString:@"#00BED7"] forState:UIControlStateNormal];
        }else if (model.attendanceLastExeTime <= 0 && (model.curTime > model.attendanceRequires.endTime+model.attendanceRequires.lateArrivalThreshold && model.attendanceRequires.endTime > 0)) {
            // 没有签到时间 同时 已过签到范围的
            timeWidth = 72.f;
            [but setTitle:NSLocalizableString(@"absenteeism", nil) forState:UIControlStateNormal];
            but.enabled = NO;
            [but setTitleColor:[UIColor colorWithHexString:@"#FF4B4B"] forState:UIControlStateNormal];
        }else if (model.attendanceLastExeTime > 0){
            // 已经签到的
            if (model.attendanceLastExeTime <= model.attendanceRequires.endTime || model.attendanceRequires.endTime <= 0) {
                // 正常签到
                [but setTitle:NSLocalizableString(@"alreadySignedIn", nil) forState:UIControlStateNormal];
                but.enabled = NO;
                [but setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
                signTypeLabel.text = [self getHoserTimeStringWith:model.attendanceLastExeTime];
                signTypeLabel.hidden = NO;
                signTypeLabel.textColor = [UIColor colorWithHexString:@"#999999"];
            }else if (model.attendanceLastExeTime <= model.attendanceRequires.endTime+model.attendanceRequires.lateArrivalThreshold && model.attendanceLastExeTime > model.attendanceRequires.endTime && model.attendanceRequires.endTime > 0){
                // 迟到
                [but setTitle:NSLocalizableString(@"late", nil) forState:UIControlStateNormal];
                but.enabled = NO;
                [but setTitleColor:[UIColor colorWithHexString:@"#FF8500"] forState:UIControlStateNormal];
                signTypeLabel.text = [self getHoserTimeStringWith:model.attendanceLastExeTime];
                signTypeLabel.hidden = NO;
            }else {
                // 非正常状态的处理
                but.enabled = NO;
            }

        }
        NSString *timeStr = [NSString stringWithFormat:@"%@：%@", NSLocalizableString(@"checkInTime", nil),[self getTimeFormate:model.attendanceRequires.startTime andEndTime:model.attendanceRequires.endTime]];
        timeLabel.text = timeStr;
        timeLabel.width += timeWidth;
    }else if (model.taskType == 10) {
        // 签退，
        iconLabel.text = NSLocalizableString(@"signBack", nil);
        CGFloat timeWidth = 0;
        if (model.attendanceLastExeTime <= 0 && (model.curTime <= model.attendanceRequires.endTime+model.attendanceRequires.lateArrivalThreshold || model.attendanceRequires.endTime <= 0)) {
                // 没有签退时间 并且 可以签到
            if (model.attendanceRequires.latitude.doubleValue != 0 && model.attendanceRequires.longitude.doubleValue != 0 && model.attendanceRequires.radius != 0) {
                commitLabel.hidden = NO;
                NSMutableAttributedString * attriStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@：%@ >",NSLocalizableString(@"signBackPlace", nil),NSLocalizableString(@"viewCheckOutRange", nil)]];
                [attriStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#858585"] range:NSMakeRange(0, 5)];
                [attriStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#00BED7"] range:NSMakeRange(5, attriStr.length-5)];
                commitLabel.attributedText = attriStr;
            }
            timeWidth = 72.f;
            [but setTitle:NSLocalizableString(@"signBackImmediately", nil) forState:UIControlStateNormal];
            [but setTitleColor:[UIColor colorWithHexString:@"#00BED7"] forState:UIControlStateNormal];
        }else if (model.attendanceLastExeTime <= 0 && model.curTime > model.attendanceRequires.endTime+model.attendanceRequires.lateArrivalThreshold && model.attendanceRequires.endTime > 0) {
            // 没有签到时间 同时 已过签到范围的
            timeWidth = 72.f;
            [but setTitle:NSLocalizableString(@"absenteeism", nil) forState:UIControlStateNormal];
            but.enabled = NO;
            [but setTitleColor:[UIColor colorWithHexString:@"#FF4B4B"] forState:UIControlStateNormal];
        }else if (model.attendanceLastExeTime > 0){
            // 已经签退的
            if ((model.attendanceLastExeTime <= model.attendanceRequires.endTime + model.attendanceRequires.lateArrivalThreshold || model.attendanceRequires.endTime <= 0) && model.attendanceLastExeTime >= model.attendanceRequires.startTime) {
                // 正常签退
                [but setTitle:NSLocalizableString(@"hasSignedBack", nil) forState:UIControlStateNormal];
                but.enabled = NO;
                [but setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
                signTypeLabel.text = [self getHoserTimeStringWith:model.attendanceLastExeTime];
                signTypeLabel.hidden = NO;
                signTypeLabel.textColor = [UIColor colorWithHexString:@"#999999"];
            }else if (model.attendanceLastExeTime < model.attendanceRequires.startTime && model.attendanceRequires.startTime > 0){
                // 早退
                [but setTitle:NSLocalizableString(@"leaveEarly", nil) forState:UIControlStateNormal];
                but.enabled = NO;
                [but setTitleColor:[UIColor colorWithHexString:@"#FF8500"] forState:UIControlStateNormal];
                signTypeLabel.text = [NSString stringWithFormat:@"%@ %@", [self getHoserTimeStringWith:model.attendanceLastExeTime],NSLocalizableString(@"refresh", nil)];
                signTypeLabel.hidden = NO;
                againSignBut.enabled = YES;
                // 是否超过了最后的签到时间
                if (model.attendanceRequires.endTime > 0 && model.attendanceRequires.endTime + model.attendanceRequires.lateArrivalThreshold < model.curTime) {
                    // 早退的签到，但是 - 当前的时间已经大于最后的签退时间
                    signTypeLabel.text = [NSString stringWithFormat:@"%@", [self getHoserTimeStringWith:model.attendanceLastExeTime]];
                    againSignBut.enabled = NO;
                }
            }else if (model.attendanceLastExeTime > model.attendanceRequires.endTime + model.attendanceRequires.lateArrivalThreshold){
                // 签退时间大于最后的结束时间 -- 特殊数据
                timeWidth = 72.f;
                [but setTitle:NSLocalizableString(@"absenteeism", nil) forState:UIControlStateNormal];
                but.enabled = NO;
                [but setTitleColor:[UIColor colorWithHexString:@"#FF4B4B"] forState:UIControlStateNormal];
            }else {
                timeWidth = 72.f;
                but.enabled = NO;
            }
        }
        NSString *timeStr = [NSString stringWithFormat:@"%@：%@", NSLocalizableString(@"signBackTime", nil),[self getTimeFormate:model.attendanceRequires.startTime andEndTime:model.attendanceRequires.endTime]];
        timeLabel.text = timeStr;
        timeLabel.width += timeWidth;
    }else if (model.taskType == 11) {
        // 线下成绩
        if (iconLabel) {
            iconLabel.width += 32;
            titleLabel.X += 32;
            titleLabel.width -= 32;
        }
        iconLabel.text = NSLocalizableString(@"offlineResults", nil);
        but.enabled = NO;
        backBut.enabled = NO;
        timeLabel.text = [NSString stringWithFormat:@"%@：--",NSLocalizableString(@"results", nil)]; // 统一设置
        if (model.offResultStatus == 0) {
            // 未开始
            [but setTitle:NSLocalizableString(@"noScore", nil) forState:UIControlStateNormal];
            [but setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        }else {
            // 已评分的
            if (model.offResultEvalType == 1) {
                // 直接评分 -- 显示分数
                timeLabel.text = [NSString stringWithFormat:@"%@：%@%@", NSLocalizableString(@"results", nil),[HICCommonUtils formatFloat:model.offResultScore],NSLocalizableString(@"points", nil)];
            }
            if (model.offResultPass == 0) {
                [but setTitle:NSLocalizableString(@"unqualified", nil) forState:UIControlStateNormal];
                [but setTitleColor:[UIColor colorWithHexString:@"#FF4B4B"] forState:UIControlStateNormal];
            }else if (model.offResultPass == 1){
                [but setTitle:NSLocalizableString(@"qualified", nil) forState:UIControlStateNormal];
                [but setTitleColor:[UIColor colorWithHexString:@"#14BE6E"] forState:UIControlStateNormal];
            }
        }
    }
    titleLabel.text = model.taskName;
    // 统一的设置 but的文字偏向问题
    but.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
}

#pragma mark - 统一事件处理
// 统一的处理点击事件
-(void)clickButWith:(UIButton *)but cell:(OTPListBaseCell *)cell andModel:(OfflineTrainingListModel *)model andType:(NSInteger)type{
    if (model.taskType == 3 || model.taskType == 4 || model.taskType == 6 || model.taskType == 7 || model.taskType == 8) {
        // 考试 -- 跳转页面
        // 作业 -- 跳转到作业页面
        // 问卷 -- 跳转到问卷页面
        // 评价 -- 跳转页面
        // 课程 -- 跳转课程页面
        if ([self.delegate respondsToSelector:@selector(listBaseCell:clickOtherButWithModel:)]) {
            [self.delegate listBaseCell:cell clickOtherButWithModel:model];
        }
    } else if (model.taskType == 9) {
        // 签到
        BOOL isSuccess = NO;
        NSInteger errorCode = 0;
        NSString *errorMsg;
        NSInteger signSeverType = 1; // 默认位置签
        // 1. 判断是否在时间范围内
        if (model.attendanceRequires.startTime <= model.curTime) {
            // 表示此时时间正确
            if (model.attendanceRequires.latitude.doubleValue != 0 && model.attendanceRequires.longitude.doubleValue != 0) {
                // 1. 表示存在位置签到
                [[OTPSignManager shareInstance] updateLocationUserInfo];
                if ([[OTPSignManager shareInstance] isInClassLocationWithLat:model.attendanceRequires.latitude.doubleValue andLon:model.attendanceRequires.longitude.doubleValue radiu:model.attendanceRequires.radius]) {
                    // 位置正确
                    isSuccess = YES;
                }else if (model.attendanceRequires.password && ![model.attendanceRequires.password isEqualToString:@""]) {
                    // 存在口令签到， 进行口令签到
                    isSuccess = YES;
                    signSeverType = 2;
                }else {
                    // 位置不正确
                    errorCode = 1;
                    errorMsg = NSLocalizableString(@"noSignInRange", nil);
                }
            }else if (model.attendanceRequires.password && ![model.attendanceRequires.password isEqualToString:@""]) {
                // 存在口令签到， 进行口令签到
                isSuccess = YES;
                signSeverType = 2;
            }else {
                // 没有位置签到，同时也没有口令签到
                isSuccess = YES;
                signSeverType = 3;
            }
        }else {
            // 表示未到签到时间范围
            errorCode = 1;
            errorMsg = NSLocalizableString(@"earlySignInTime", nil);
        }
        if ([self.delegate respondsToSelector:@selector(listBaseCell:signModel:signType:signToSeverType:isSignSuccess:errorMsg:errorCode:)]) {
            [self.delegate listBaseCell:cell signModel:model signType:1 signToSeverType:signSeverType isSignSuccess:isSuccess errorMsg:errorMsg errorCode:errorCode];
        }
    }else if (model.taskType == 10){
        // 签退
        BOOL isSuccess = NO;
        NSInteger errorCode = 0;
        NSString *errorMsg;
        NSInteger signSeverType = 1; // 默认位置签
        // 1. 判断当前时间是否是签退的正常时间
        if (model.attendanceRequires.startTime < model.curTime) {
            // 表示时间正常可以签退
            if (model.attendanceRequires.latitude.doubleValue != 0 && model.attendanceRequires.longitude.doubleValue != 0) {
                // 1. 表示存在位置签退
                [[OTPSignManager shareInstance] updateLocationUserInfo];
                if ([[OTPSignManager shareInstance] isInClassLocationWithLat:model.attendanceRequires.latitude.doubleValue andLon:model.attendanceRequires.longitude.doubleValue radiu:model.attendanceRequires.radius]) {
                    // 位置正确
                    isSuccess = YES;
                }else if (model.attendanceRequires.password && ![model.attendanceRequires.password isEqualToString:@""]) {
                    // 存在口令签退， 进行口令签退
                    isSuccess = YES;
                    signSeverType = 2;
                }else {
                    // 位置不正确 - 并且不存在口令签退
                    errorCode = 1;
                    errorMsg = NSLocalizableString(@"signOffRangeNotReached", nil);
                }
            }else if (model.attendanceRequires.password && ![model.attendanceRequires.password isEqualToString:@""]) {
                // 存在口令签到， 进行口令签退
                isSuccess = YES;
                signSeverType = 2;
            }else {
                // 没有位置签到，同时也没有口令签退
                isSuccess = YES;
                signSeverType = 3;
            }
        }else {
            // 签退的时间早了 -- 早退
            errorCode = 3;
            errorMsg = NSLocalizableString(@"leaveEarly", nil);
            if (model.attendanceRequires.latitude.doubleValue != 0 && model.attendanceRequires.longitude.doubleValue != 0) {
                // 1. 表示存在位置签退
                [[OTPSignManager shareInstance] updateLocationUserInfo];
                if ([[OTPSignManager shareInstance] isInClassLocationWithLat:model.attendanceRequires.latitude.doubleValue andLon:model.attendanceRequires.longitude.doubleValue radiu:model.attendanceRequires.radius]) {
                    // 位置正确
                    isSuccess = YES;
                }else if (model.attendanceRequires.password && ![model.attendanceRequires.password isEqualToString:@""]) {
                    // 存在口令签退， 进行口令签退
                    isSuccess = YES;
                    signSeverType = 2;
                }else {
                    // 位置不正确 - 并且不存在口令签退
                    errorMsg = NSLocalizableString(@"signOffRangeNotReached", nil);
                }
            }else if (model.attendanceRequires.password && ![model.attendanceRequires.password isEqualToString:@""]) {
                // 存在口令签到， 进行口令签退
                isSuccess = YES;
                signSeverType = 2;
            }else {
                // 没有位置签到，同时也没有口令签退
                isSuccess = YES;
                signSeverType = 3;
            }
        }
        if ([self.delegate respondsToSelector:@selector(listBaseCell:signModel:signType:signToSeverType:isSignSuccess:errorMsg:errorCode:)]) {
            [self.delegate listBaseCell:cell signModel:model signType:2 signToSeverType:signSeverType isSignSuccess:isSuccess errorMsg:errorMsg errorCode:errorCode];
        }
    }
}
-(void)clickMapViewWith:(OfflineTrainingListModel *)model andCell:(OTPListBaseCell *)cell{
    DDLogDebug(@"进入地图详情页 -------");
    if ([self.delegate respondsToSelector:@selector(listBaseCell:clickMapViewWithModel:)]) {
        [self.delegate listBaseCell:cell clickMapViewWithModel:model];
    }
}

-(void)clickSignAgainWith:(OfflineTrainingListModel *)model andCell:(OTPListBaseCell *)cell {
    // 早退刷新
    if (model.curTime > model.attendanceRequires.endTime+model.attendanceRequires.lateArrivalThreshold && model.attendanceRequires.endTime > 0) {
        // 当前时间已经大于最后签退时间的 -- 签退限时
        [HICToast showWithText:NSLocalizableString(@"signOffTimeRangeIsExceeded", nil)];
    }else {
        // 可以签退 - 或者早退进行刷新
        if (model.attendanceRequires.latitude.doubleValue != 0 && model.attendanceRequires.longitude.doubleValue != 0) {
            // 1. 表示存在位置签退
            [[OTPSignManager shareInstance] updateLocationUserInfo];
            if ([[OTPSignManager shareInstance] isInClassLocationWithLat:model.attendanceRequires.latitude.doubleValue andLon:model.attendanceRequires.longitude.doubleValue radiu:model.attendanceRequires.radius]) {
                // 位置正确
                if ([self.delegate respondsToSelector:@selector(listBaseCell:signAgainModel:passWord:)]) {
                    [self.delegate listBaseCell:cell signAgainModel:model passWord:NO];
                }
            }else if (model.attendanceRequires.password && ![model.attendanceRequires.password isEqualToString:@""]) {
                // 存在口令签退， 进行口令签退
                if ([self.delegate respondsToSelector:@selector(listBaseCell:signAgainModel:passWord:)]) {
                    [self.delegate listBaseCell:cell signAgainModel:model passWord:YES];
                }
            }else {
                // 位置不正确 - 并且不存在口令签退
                [HICToast showWithText:NSLocalizableString(@"signOffRangeNotReached", nil)];
            }
        }else if (model.attendanceRequires.password && ![model.attendanceRequires.password isEqualToString:@""]) {
            // 存在口令签到， 进行口令签退
            if ([self.delegate respondsToSelector:@selector(listBaseCell:signAgainModel:passWord:)]) {
                [self.delegate listBaseCell:cell signAgainModel:model passWord:YES];
            }
        }else {
            // 没有位置签到，同时也没有口令签退
            if ([self.delegate respondsToSelector:@selector(listBaseCell:signAgainModel:passWord:)]) {
                [self.delegate listBaseCell:cell signAgainModel:model passWord:NO];
            }
        }

    }

}

@end
