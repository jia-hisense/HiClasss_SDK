//
//  HICTrainingHeaderFrame.h
//  HiClass
//
//  Created by hisense on 2020/4/16.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HICTrainingInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HICTrainingHeaderFrame : UIView

@property (nonatomic, strong) HICTrainingInfoModel *trainingInfo;


@property (nonatomic, assign, readonly) CGRect bgImgViewF;

@property (nonatomic, assign, readonly) CGRect titleLblF;

@property (nonatomic, assign, readonly) CGRect timeLblF;

@property (nonatomic, assign, readonly) CGRect trainingModeLblF;

@property (nonatomic, assign, readonly) CGRect trainingLevelLblF;

@property (nonatomic, assign, readonly) CGRect chargePersonLblF;

@property (nonatomic, assign, readonly) CGRect gradesLblF;

@property (nonatomic, assign, readonly) CGRect splitLineViewF;

@property (nonatomic, assign, readonly) CGFloat headerHeight;


- (instancetype)initWithTrainingInfo:(HICTrainingInfoModel *)trainingInfo;
@end

NS_ASSUME_NONNULL_END
