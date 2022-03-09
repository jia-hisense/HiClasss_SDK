//
//  HICSubTask.h
//  HiClass
//
//  Created by hisense on 2020/4/23.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    Course = 1,
    Knowledge = 2,
    Exam = 3,
    Homework = 4,
    Questionnaire = 6,
    Evaluate = 7,
    SignIn = 9,
    SignBack = 10
} HICSubTaskType;

typedef enum : NSUInteger {
    TaskStatusSignIn = 1,
    TaskStatusSignBack = 2,
    TaskStatusLeave = 3
} HICTaskStatusType;

typedef enum : NSUInteger {
    NotStart = 0,
    Ongoing = 1,
    Unapproved = 3,
    Approving = 4,
    Done = 5
} HICWorkStatus;

@interface HICAttendanceRequires : NSObject

@property (nonatomic, strong) NSString *longitude; //": "string, optional, 签到经度",
@property (nonatomic, strong) NSString *latitude; //": "string, optional, 签到维度",
@property (nonatomic, assign) NSInteger radius; //": "long，optional, 签到半径",
@property (nonatomic, strong) NSString *locationName; //": "string, optional, 签到地点",
@property (nonatomic, assign) NSInteger startTime; //": "long, attendanceRequires内必填, 正常考勤开始时间",
@property (nonatomic, assign) NSInteger endTime; //": "long, attendanceRequires内必填，正常考勤结束时间",
@property (nonatomic, assign) NSInteger lateArrivalThreshold; //": "long, optional, 迟到签到时间(正常签到开始时间后几分钟内)，超出不允许签到",
@property (nonatomic, strong) NSString *password; //string, optional, 签到口令

@end


@interface HICSubTask : NSObject

@property (nonatomic, assign) NSInteger curTime; //当前时间

@property (nonatomic, assign) NSInteger trainStageId; //": "long, required, train_stage_task表的id",
@property (nonatomic, assign) HICSubTaskType taskType; //": "int, required, 任务类型，1-课程，2-知识，3-考试，4-作业，6-问卷，7-评价，9-签到，10-签退",
@property (nonatomic, assign) NSInteger studyType; //": "int, required, 选修类型 1:必修， 2：选修",
@property (nonatomic, assign) NSInteger taskId;//": "long, required, 培训任务活动id",
@property (nonatomic, strong) NSString *taskName; //": "string, required, 任务名称",
@property (nonatomic, assign) NSInteger startTime; //": "long, required, 开始时间，UTC秒; -1表示不限时间",
@property (nonatomic, assign) NSInteger endTime; //": "long, required, 结束时间，UTC秒； -1表示不限时间",
@property (nonatomic, assign) HICTaskStatusType taskStatus; //": "int, optional, 1:已签到，2：已签退，3：请假",
@property (nonatomic, assign) NSInteger questionCommitTime; //": "int, optional",
@property (nonatomic, assign) NSInteger workJobCommitTime; //":"long, optional, 作业下子任务最后提交时间",
@property (nonatomic, assign) HICWorkStatus workStatus; //": "int, optional, 作业状态，0-待开始，1-进行中，3-待批阅，4-批阅中，5-已完成",
@property (nonatomic, strong) HICAttendanceRequires *attendanceRequires;
@property (nonatomic, assign) NSInteger attendanceExeTime; //": "long, optional, 考勤任务执行时间(签到/签退时间)"



@end

NS_ASSUME_NONNULL_END
