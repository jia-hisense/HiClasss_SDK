//
//  HICTrainingInfoModel.h
//  HiClass
//
//  Created by hisense on 2020/4/14.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HICOfflineCertificate : NSObject
@property (nonatomic, assign) NSInteger certId;
@property (nonatomic, strong) NSString *certName;

@end


@interface HICTrainingInfoModel : NSObject

@property (nonatomic, strong) NSNumber *trainingId;
@property (nonatomic, strong) NSNumber *trainCat; //": "int,optional,培训类型，线上培训：1-默认计划，2-学习计划，线下培训、混合培训：11-内部培训，12-外请内训，13-外送培训",
@property (nonatomic, assign) NSInteger  trainTerminated; //":"int,required,培训是否结束，10-是，其余值-否",
@property (nonatomic, strong) NSString *trainName; //string,required,eg:'培训名称'",
@property (nonatomic, assign) NSInteger startTime; //": "long,required,培训开始时间，eg:1111111111",
@property (nonatomic, assign) NSInteger endTime; //: "int,required,培训结束时间，eg:1111",
@property (nonatomic, assign) NSInteger trainLevel; //: "int, required, 培训级别 1：集团级别，2：公司级， 3：部门级",
@property (nonatomic, strong) NSNumber *trainResult; //double,optional,线下培训成绩",
@property (nonatomic, strong) NSNumber *trainConclusion; //"int,optional,线下培训结论，0-肄业，1-合格，2-不合格",
@property (nonatomic, strong) NSString *trainComment; //": "string,required,eg:'培训描述'",
@property (nonatomic, strong) NSString *trainGoal; //": "string,required,培训目标，eg:''",
@property (nonatomic, strong) NSString *trainPos; //": "string,required,培训地点，eg:'1111'",
@property (nonatomic, strong) NSString *trainManager; //"string,optional,负责人，以','分隔",
@property (nonatomic, strong) NSString *trainAudience; //": "string,required,培训对象，eg,'培训对象'",
@property (nonatomic, strong) NSNumber *rewardCredits; //"double,optional,奖励学分"
@property (nonatomic, strong) NSNumber *points; // "积分"
@property (nonatomic, strong) NSNumber *rewardCreditHours; //"long,optional,奖励学时"
@property (nonatomic, strong) NSArray<HICOfflineCertificate *> *certificateList; //": "string,optional,eg:'结婚证，离婚证'"
@property (nonatomic, assign) NSInteger registChannel;//"int, optional,是否通过报名方式参与培训：0-非报名，1-报名(仅存在于线下培训和混合培训)",
@property (nonatomic, strong) NSString *scene;
// 培训方式 线下培训
@property (nonatomic, strong) NSString *mode;
/// "trainType": "int,required,培训类型 1：线上培训， 2：线下培训， 3：混合培训，4：岗位地图",
@property (nonatomic, assign) NSInteger trainType;

@property (nonatomic, strong, readonly, getter=getLevelStr) NSString *levelStr;

/// 项目成绩
@property (nonatomic, strong, readonly, getter=getTeacherEvalScoreStr) NSString *teacherEvalScoreStr;

/// 学分
@property (nonatomic, strong, readonly, getter=getRewardPointsStr) NSString *rewardPointsStr;

/// 学时
@property (nonatomic, strong, readonly, getter=getRewardCreditMinsStr) NSString *rewardCreditMinsStr;


@property (nonatomic, strong, readonly, getter=getCertificateListStr) NSString *certificateListStr;

@property (nonatomic, strong, readonly, getter=getTrainManagerStr) NSString *trainManagerStr;





@end

NS_ASSUME_NONNULL_END
