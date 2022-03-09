//
//  HICTrainingHeaderFrame.m
//  HiClass
//
//  Created by hisense on 2020/4/16.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import "HICTrainingHeaderFrame.h"
#import "NSString+String.h"


@implementation HICTrainingHeaderFrame

- (instancetype)initWithTrainingInfo:(HICTrainingInfoModel *)trainingInfo
{
    self = [super init];
    if (self) {
        self.trainingInfo = trainingInfo;
    }
    return self;
}


- (void)setTrainingInfo:(HICTrainingInfoModel *)trainingInfo {

    _trainingInfo = trainingInfo;

    CGFloat leftPadding = 16;
    CGFloat rightPadding = 16;
    CGFloat topPadding = HIC_NavBarAndStatusBarHeight+ 6;
    CGFloat bottomPadding = 16;
    CGFloat cellW = HIC_ScreenWidth;

    CGFloat contentW = cellW-leftPadding-rightPadding;
    CGSize titleSize = [[NSString realString:trainingInfo.trainName] sizeWithFont:[UIFont fontWithName:@"PingFangSC-Regular" size:18] maxSize:CGSizeMake(contentW, 52)];

    _titleLblF = CGRectMake(leftPadding, topPadding, contentW, titleSize.height);

    _timeLblF = CGRectMake(leftPadding, CGRectGetMaxY(_titleLblF)+4, CGRectGetWidth(_titleLblF), 22);

    _splitLineViewF = CGRectMake(leftPadding, CGRectGetMaxY(_timeLblF)+16, CGRectGetWidth(_timeLblF), 0.5);


    CGFloat levelH = 22;
    NSString *levelStr = [NSString stringWithFormat:@"%@：%@", NSLocalizableString(@"trainingLevel", nil),[NSString realString:trainingInfo.levelStr]];
    CGSize levelSize = [levelStr sizeWithFont:[UIFont fontWithName:@"PingFangSC-Regular" size:14] maxSize:CGSizeMake(MAXFLOAT, 22)];
    NSString *scoreStr = [NSString stringWithFormat:@"%@：%@", NSLocalizableString(@"projectPerformance", nil),[NSString realString:trainingInfo.teacherEvalScoreStr]];
    CGSize scoreSize = [scoreStr sizeWithFont:[UIFont fontWithName:@"PingFangSC-Regular" size:14] maxSize:CGSizeMake(MAXFLOAT, 22)];
    CGFloat levelW = MAX(levelSize.width, scoreSize.width);

    _trainingLevelLblF = CGRectMake(cellW-(rightPadding+levelW), CGRectGetMaxY(_splitLineViewF)+16, levelW,  levelH);
    _gradesLblF = CGRectMake(CGRectGetMinX(_trainingLevelLblF), CGRectGetMaxY(_trainingLevelLblF), levelW, levelH);


    CGFloat trainingModeLblFW = CGRectGetMinX(_trainingLevelLblF)- leftPadding;
    _trainingModeLblF = CGRectMake(leftPadding, CGRectGetMinY(_trainingLevelLblF), trainingModeLblFW, levelH);
    _chargePersonLblF = CGRectMake(CGRectGetMinX(_trainingModeLblF), CGRectGetMinY(_gradesLblF), CGRectGetWidth(_trainingModeLblF),  CGRectGetHeight(_trainingModeLblF));


    _headerHeight = CGRectGetMaxY(_gradesLblF) + bottomPadding;

    _bgImgViewF = CGRectMake(0, 0, cellW, _headerHeight);

}

@end
