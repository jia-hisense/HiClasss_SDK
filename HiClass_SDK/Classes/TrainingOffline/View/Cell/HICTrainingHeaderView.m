//
//  HICTrainingHeaderView.m
//  HiClass
//
//  Created by hisense on 2020/4/16.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import "HICTrainingHeaderView.h"
#import "NSString+String.h"

@interface HICTrainingHeaderView()

@property (nonatomic, weak) UIImageView *bgImgView;

@property (nonatomic, weak) UILabel *titleLbl;

@property (nonatomic, weak) UILabel *timeLbl;

@property (nonatomic, weak) UILabel *trainingModeLbl;

@property (nonatomic, weak) UILabel *trainingLevelLbl;

@property (nonatomic, weak) UILabel *chargePersonLbl;

@property (nonatomic, weak) UILabel *gradesLbl;

@property (nonatomic, weak) UIView *splitLineView;

@end


@implementation HICTrainingHeaderView


- (instancetype)initWithHeaderFrame:(HICTrainingHeaderFrame *)headerframe
{
    self = [super init];
    if (self) {

        [self createSubviews];

        self.headerFrame = headerframe;
    }
    return self;
}


- (void)createSubviews
{
    UIImageView *bgImgView = [[UIImageView alloc] init];
    self.bgImgView = bgImgView;
    [self addSubview:bgImgView];
    [bgImgView setImage:[UIImage imageNamed:@"详情背景"]];
    [bgImgView setContentMode:UIViewContentModeScaleToFill];



    UILabel *titleLbl = [[UILabel alloc] init];
    [self addSubview:titleLbl];
    self.titleLbl = titleLbl;
    titleLbl.font = [UIFont fontWithName:@"PingFangSC-Regular" size:18];
    titleLbl.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    titleLbl.numberOfLines = 0;


    UILabel *timeLbl = [[UILabel alloc] init];
    [self addSubview:timeLbl];
    self.timeLbl = timeLbl;
    timeLbl.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    timeLbl.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
//    timeLbl.adjustsFontSizeToFitWidth = YES;


    UILabel *trainingModeLbl = [[UILabel alloc] init];
    [self addSubview:trainingModeLbl];
    self.trainingModeLbl = trainingModeLbl;
    trainingModeLbl.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    trainingModeLbl.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
//    trainingModeLbl.adjustsFontSizeToFitWidth = YES;

    UILabel *trainingLevelLbl = [[UILabel alloc] init];
    [self addSubview:trainingLevelLbl];
    self.trainingLevelLbl = trainingLevelLbl;
    trainingLevelLbl.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    trainingLevelLbl.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
//    trainingLevelLbl.adjustsFontSizeToFitWidth = YES;
    trainingLevelLbl.textAlignment = NSTextAlignmentLeft;

    UILabel *chargePersonLbl = [[UILabel alloc] init];
    [self addSubview:chargePersonLbl];
    self.chargePersonLbl = chargePersonLbl;
    chargePersonLbl.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    chargePersonLbl.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
//    chargePersonLbl.adjustsFontSizeToFitWidth = YES;

    UILabel *gradesLbl = [[UILabel alloc] init];
    [self addSubview:gradesLbl];
    self.gradesLbl = gradesLbl;
    gradesLbl.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    gradesLbl.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
//    gradesLbl.adjustsFontSizeToFitWidth = YES;
    gradesLbl.textAlignment = NSTextAlignmentLeft;

    UIView *splitLineView = [[UIView alloc] init];
    splitLineView.backgroundColor = [UIColor colorWithHexString:@"#50FFFFFF"];
    self.splitLineView = splitLineView;
    [self addSubview:splitLineView];
}

- (void)setHeaderFrame:(HICTrainingHeaderFrame *)headerFrame {
    _headerFrame = headerFrame;

    [self settingData];

    [self settingFrame];

}

- (void)settingData {

     HICTrainingInfoModel *trainingInfo = _headerFrame.trainingInfo;

    _titleLbl.text = [NSString realString:trainingInfo.trainName];
    _timeLbl.text = [NSString stringWithFormat:@"%@：%@", NSLocalizableString(@"trainingTime", nil),[HICCommonUtils returnReadableTimeZoneWithStartTime:[NSNumber numberWithInteger:trainingInfo.startTime] andEndTime:[NSNumber numberWithInteger:trainingInfo.endTime]]];
    NSString * methodStr;
    if (trainingInfo.trainType == 1) {
        methodStr = NSLocalizableString(@"onlineTraining", nil);
    }else if (trainingInfo.trainType == 2){
        methodStr = NSLocalizableString(@"offlineTraining", nil);
    }else if (trainingInfo.trainType == 3){
        methodStr = NSLocalizableString(@"online+offline", nil);
    }else{
        methodStr = NSLocalizableString(@"jobsMap", nil);
    }
    _trainingModeLbl.text = [NSString stringWithFormat:@"%@：%@", NSLocalizableString(@"trainingMethods", nil),[NSString realString:methodStr]];
    _trainingLevelLbl.text = [NSString stringWithFormat:@"%@：%@", NSLocalizableString(@"trainingLevel", nil),[NSString realString:trainingInfo.levelStr]];
    _chargePersonLbl.text = [NSString stringWithFormat:@"%@：%@",NSLocalizableString(@"leadingCadre", nil),[NSString realString:trainingInfo.trainManager]];
    
    _gradesLbl.text = [NSString stringWithFormat:@"%@：%@", NSLocalizableString(@"projectPerformance", nil),[NSString realString:trainingInfo.teacherEvalScoreStr]];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self settingFrame];
}


- (void)settingFrame {
    self.bgImgView.frame = _headerFrame.bgImgViewF;
    self.titleLbl.frame = _headerFrame.titleLblF;
    self.timeLbl.frame = _headerFrame.timeLblF;
    self.trainingModeLbl.frame = _headerFrame.trainingModeLblF;
    self.trainingLevelLbl.frame = _headerFrame.trainingLevelLblF;
    self.chargePersonLbl.frame = _headerFrame.chargePersonLblF;
    self.gradesLbl.frame = _headerFrame.gradesLblF;
    self.splitLineView.frame = _headerFrame.splitLineViewF;
    
}

@end
