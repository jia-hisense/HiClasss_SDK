//
//  HICHomeworkModel.h
//  HiClass
//
//  Created by Eddie Ma on 2020/3/11.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HICHomeworkModel : NSObject

/// 课程名称(如果作业关联了课程)
@property (nonatomic, copy) NSString *workName;
/// 作业海报
@property (nonatomic, copy) NSString *coverPic;
/// 开始时间
@property (nonatomic, strong) NSNumber *startTime;
/// 截止时间
@property (nonatomic, strong) NSNumber *endTime;
/// 培训是否结束 10:是 其余值否
@property (nonatomic, assign) NSInteger trainTerminated;


/// 作业ID
@property (nonatomic, strong) NSNumber *jobId;
/// 作业任务结果ID
@property (nonatomic, strong) NSNumber *jobRetId;
/// 学习的状态 未开始-1, 待完成-2, 待批阅-3, 批阅中-4, 已完成-5,
@property (nonatomic, assign) HICHomeworkStatus jobStatus;
/// 提交的时间
@property (nonatomic, strong) NSNumber *commitTime;
/// 老师查看时间
@property (nonatomic, strong) NSNumber *viewTime;
/// 子任务批阅时间
@property (nonatomic, strong) NSNumber *reviewTime;
/// 成绩
@property (nonatomic, strong) NSNumber *score;
/// 是否合格 1：合格 0：不合格
@property (nonatomic, strong) NSNumber *pass;
/// 是否退回重写(1:是 0:否, 2:学生撤回)
@property (nonatomic, strong) NSNumber *rejected;
/// 总成绩
@property (nonatomic, strong) NSNumber *totalGrade;
@property (nonatomic, strong) NSNumber *maxScore;
/// 通过成绩
@property (nonatomic, strong) NSNumber *passGrade;
/// 精华 0-不是， 1-是
@property (nonatomic, strong) NSNumber *essence;
/// 是否超期，1：超时 0：未超时
@property (nonatomic, strong) NSNumber *isTimeOut;
///评分方式，1：直接评分，2：是否合格
@property (nonatomic, strong) NSNumber *scoreType;
/// 作业名称
@property (nonatomic, copy) NSString *name;
/// 作业子任务描述
@property (nonatomic, copy) NSString *comment;
/// 老师评语
@property (nonatomic, copy) NSString *evaluation;

@end

NS_ASSUME_NONNULL_END
