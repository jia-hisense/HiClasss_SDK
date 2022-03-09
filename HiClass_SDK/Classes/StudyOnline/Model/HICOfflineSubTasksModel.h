//
//  HICOfflineSubTasksModel.h
//  HiClass
//
//  Created by WorkOffice on 2020/4/20.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HICOfflineSubTasksModel : NSObject
/**
 "id":"long, required, train_stage_task表的id",
                "taskType":"int, required, 任务类型，1-课程，2-知识，3-考试，4-作业，6-问卷，7-评价，9-签到，10-签退",
                "studyType":"int, required, 选修类型 1:必修， 2：选修",
                "taskId":"long, required, 培训任务活动id",
                "taskName":"string, required, 任务名称",
                "startTime":"long, required, 开始时间，UTC秒; -1表示不限时间",
                "endTime":"long, required, 结束时间，UTC秒； -1表示不限时间",
                "taskStatus":"int, optional, 1:已签到，2：已签退，3：请假",
                "questionCommitTime":"int, optional",
                "examAvaiNum":"int, optional, 可用考试次数，如果examAllowNum为0，则不限制",
                "examAllowNum":"int, optional, 最大考试次数，0为不限制",
                "attendanceRequires":Object{...},
                "attendanceExeTime":"long, optional, 考勤任务执行时间(签到/签退时间)"
 */
@property (nonatomic, strong)NSNumber *trainStageId;
@property (nonatomic, assign)NSInteger taskType;
@property (nonatomic, assign)NSInteger studyType;
@property (nonatomic, strong)NSNumber *taskId;
@property (nonatomic, strong)NSString *taskName;
@property (nonatomic, strong)NSNumber *startTime;
@property (nonatomic, strong)NSNumber *endTime;
@property (nonatomic, assign)NSInteger taskStatus;
@property (nonatomic, assign)NSInteger questionCommitTime;
@property (nonatomic, assign)NSInteger examAvaiNum;
@property (nonatomic, assign)NSInteger examAllowNum;
@property (nonatomic, strong)NSDictionary *attendanceRequires;
@property (nonatomic, strong)NSNumber *attendanceExeTime;
@end
/**
 "longitude":"string, optional, 签到经度",
 "latitude":"string, optional, 签到维度",
 "radius":"long，optional, 签到半径",
 "locationName":"string, optional, 签到地点",
 "startTime":"long, attendanceRequires内必填, 正常考勤开始时间",
 "endTime":"long, attendanceRequires内必填，正常考勤结束时间",
 "lateArrivalThreshold":"long, optional, 迟到签到时间(正常签到开始时间后几分钟内)，超出不允许签到",
 "type":"string, attendanceRequires内必填, 签到方式(多种签到方式，以英文逗号衔接)"
 */
@interface HICOfflineattendAnceRequiresModel : NSObject
@property (nonatomic ,strong)NSString *longitude;
@property (nonatomic ,strong)NSString *latitude;
@property (nonatomic ,strong)NSNumber *radius;
@property (nonatomic ,strong)NSString *locationName;
@property (nonatomic ,strong)NSNumber *startTime;
@property (nonatomic ,strong)NSNumber *endTime;
@property (nonatomic ,strong)NSNumber *lateArrivalThreshold;
@property (nonatomic ,strong)NSString *type;
@end

NS_ASSUME_NONNULL_END
