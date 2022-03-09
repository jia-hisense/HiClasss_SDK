//
//  HTCTrainCell.m
//  iTest
//
//  Created by Sir_Jing on 2020/3/16.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import "HTCTrainCell.h"
#import "HICHomeTaskCenterModel.h"

@implementation HTCTrainCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.iconImageLabel.text = @"培";
        self.iconImageLabel.backgroundColor = [UIColor colorWithRed:75/255.0 green:167/255.0 blue:1.0 alpha:1];
        self.rightBottomLabel.hidden = YES;
    }
    return self;
}

- (void)setModel:(HICHomeTaskCenterModel *)model {
    if (self.model == model) {
        return;
    }
    [super setModel:model];

    self.contentTitleLabel.text = model.isImportant == 1?[NSString stringWithFormat:@"       %@", model.taskName]:model.taskName;
    NSInteger currentTimeInteval = (NSInteger)[[NSDate date] timeIntervalSince1970];
    if (currentTimeInteval > model.endTime && model.trainType == 1 && model.trainProgress < 100) {
        self.timeLabel.text = [NSString stringWithFormat:@"%@！",NSLocalizableString(@"timeoutWarning", nil)];
        self.timeLabel.textColor = [UIColor colorWithHexString:@"#FF8500"];
    } else {
        self.timeLabel.text = [NSString stringWithFormat:@"%@: %@", NSLocalizableString(@"trainingTime", nil),[HICCommonUtils returnReadableTimeZoneWithStartTime:@(model.startTime) andEndTime:@(model.endTime)]];
        self.timeLabel.textColor = [UIColor colorWithRed:133/255.0 green:133/255.0 blue:133/255.0 alpha:1];
    }
   
    NSString *trainTypeStr = @"-";
    switch (model.trainType) {
        case 1:
            trainTypeStr = NSLocalizableString(@"onlineLearning", nil);
            break;
        case 2:
            trainTypeStr = NSLocalizableString(@"offlineTraining", nil);
            break;
        case 3:
            trainTypeStr = NSLocalizableString(@"online+offline", nil);
            break;
        default:
            break;
    }
    self.rightBottomLabel.hidden = YES;
    self.progressView.hidden = YES;
    self.leftTopLabel.text = [NSString stringWithFormat:@"%@: %@", NSLocalizableString(@"trainingMethods", nil),trainTypeStr];
    if (model.registChannel == 2) {//指派
        self.leftBottomLabel.text = [NSString stringWithFormat:@"%@: %@", NSLocalizableString(@"designatedPerson", nil),[NSString isValidStr:model.assigner] ? model.assigner : @"-"];
        self.leftBottomLabel.textColor = TEXT_COLOR_LIGHTM;
    }else{
        if (model.registerId.integerValue > 0) {
            self.leftBottomLabel.text = NSLocalizableString(@"haveToSignUp", nil);
            self.leftBottomLabel.textColor = [UIColor colorWithHexString:@"#FF8500"];
        }else{
            self.leftBottomLabel.text = NSLocalizableString(@"didNotSignUp", nil);
            self.leftBottomLabel.textColor = [UIColor colorWithHexString:@"#FF8500"];
        }
    }

    self.rightTopLabel.text = [NSString stringWithFormat:@"%@: %@%@", NSLocalizableString(@"learningProcess", nil),[HICCommonUtils formatFloat:model.trainProgress], @"%"];
    if (model.trainType==1) {
        self.progressView.hidden = NO;
        self.progressView.progress = model.trainProgress/100;
    }
   
    if (model.isImportant == 1) {
        [self.contentTitleLabel addSubview:self.majorImageView];
    }else {
        [self.majorImageView removeFromSuperview];
    }
    NSString *gradeStr;
    if (model.trainConclusion == 0) {
        gradeStr = NSLocalizableString(@"studyInSchoolstudy", nil);
    }else{
        gradeStr = model.trainResult >=0 ?[HICCommonUtils formatFloat:model.trainResult]:@"--";
    }
    if (model.trainType == 2) {
        // 线下培训
        NSString *levelStr;
        switch (model.trainLevel) {
            case 1:
                levelStr = NSLocalizableString(@"groupLevel", nil);
                break;
            case 2:
                levelStr = NSLocalizableString(@"corporateLevel", nil);
                break;
            case 3:
                levelStr = NSLocalizableString(@"departmentalLevel", nil);
                break;
            default:
                break;
        }
        self.rightTopLabel.text = [NSString stringWithFormat:@"%@: %@", NSLocalizableString(@"trainingLevel", nil),levelStr];
        self.progressView.hidden = YES;
        self.rightBottomLabel.hidden = NO;
        self.rightBottomLabel.text = [NSString stringWithFormat:@"%@: %@",NSLocalizableString(@"projectPerformance", nil),gradeStr];
    }
    if (model.trainType == 3) {
        self.rightBottomLabel.hidden = YES;
        self.progressView.hidden = YES;
        self.rightTopLabel.text = [NSString stringWithFormat:@"%@: %@",NSLocalizableString(@"projectPerformance", nil),gradeStr];
    }
}

-(void)setIsWillDo:(BOOL)isWillDo {
    [super setIsWillDo:isWillDo];
    if (self.model.trainType == 2) {
        // 线下培训
        self.rightTopLabel.hidden = NO;
        self.progressView.hidden = YES;
    }else if(self.model.trainType == 1){
        if (isWillDo) {
            self.rightTopLabel.hidden = YES;
            self.progressView.hidden = YES;
        }else {
            self.rightTopLabel.hidden = NO;
            self.progressView.hidden = NO;
        }
    }else{
        self.progressView.hidden = YES;
        self.rightBottomLabel.hidden = YES;
    }
}

@end
