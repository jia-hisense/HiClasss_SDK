//
//  HICLectureTrainModel.h
//  HiClass
//
//  Created by hisense on 2020/5/15.
//  Copyright © 2020 haoqian. All rights reserved.
//

typedef enum : NSUInteger {
    DefaultAssign = 1,
    StudyAssign = 2,
    InsideTrain = 11,
    OutsideTrain = 12,
    OutWardTrain = 13
    //1:默认计划 2:学习计划  线下培训、混合培训：11：分内部培训、12：外请内训、13：外送培训"
} HICLectureTrainCategoryType;

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HICLectureTrainSubCourseModel : NSObject
@property (nonatomic, assign) NSInteger resClassId; //":"long,线下课资源ID",
@property (nonatomic, strong) NSString *resClassName; //":"string,线下课资源名称",
@property (nonatomic, assign) NSInteger rewardPeriod; //":"int, 线下课奖励-学时",
@property (nonatomic, strong) NSNumber *classDuration; //":"int, 标准课时，单位分钟",
@property (nonatomic, assign) NSInteger classStageId; //":"long,线下课排期ID",
@property (nonatomic, strong) NSNumber *classStartTime; //":"long,线下课开始时间, UTC时间戳",
@property (nonatomic, strong) NSNumber *classEndTime; //":"long,线下课结束时间, UTC时间戳",
@property (nonatomic, strong) NSString *classPlace; //":"string,上课地点"

@property (nonatomic, strong, getter=getCourseHourStr) NSString *courseHourStr;

@end

@interface HICLectureTrainSubModel : NSObject
@property (nonatomic, assign) NSInteger classType; //":"int,课程类型，8-线下课",
@property (nonatomic, assign) NSInteger trainId; //":"long,培训ID",
@property (nonatomic, strong) NSString *trainName; //":"string,培训名称",
@property (nonatomic, assign) NSInteger trainCategory; //":"int,培训类型: 1:默认计划 2:学习计划  线下培训、混合培训：11：分内部培训、12：外请内训、13：外送培训",
@property (nonatomic, strong) NSString *trainPlace; //":"string,培训地点",
@property (nonatomic, assign) NSInteger trainStartTime; //":"long,培训开始时间, UTC时间戳",
@property (nonatomic, assign) NSInteger trainEndTime; //":"long,培训结束时间, UTC时间戳",
@property (nonatomic, assign) NSInteger dayInWeek; //":"int,星期标识: -1=不限时间, 0=星期一，1=星期二, ……6=星期天",

@property (nonatomic, strong) NSArray *classes;
@end



@interface HICLectureTrainModel : NSObject

@property (nonatomic, assign) NSInteger total;
@property (nonatomic, strong) NSMutableArray *list;

@end

NS_ASSUME_NONNULL_END
