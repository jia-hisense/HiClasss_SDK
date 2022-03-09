//
//  HICMixTrainArrangeModel.h
//  HiClass
//
//  Created by WorkOffice on 2020/6/17.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OfflineTrainingListModel.h"
NS_ASSUME_NONNULL_BEGIN
@interface HICMixTrainArrangeModel : NSObject
/**
 "trainTerminated":5,
 "stageId":1313,
 "stageName":"啊啊啊阶段4",
 "stageNo":4,
 "stageEndTime":-1,
 "isOrder":0,
 "stageIsOrder":0,
 "taskNum":2,
 "completedTaskNum":0,
 "taskCreditHours":3,
 "curTime":1592793048,
 "syncProgress":0,
 
 */
@property (nonatomic ,strong)NSNumber *stageId;
@property (nonatomic ,strong)NSString *stageName;
@property (nonatomic ,strong)NSNumber *curTime;
///"int,required,培训是否结束，10-是，其余值-否",
@property (nonatomic ,assign)NSInteger trainTerminated;
@property (nonatomic ,strong)NSArray* stageActionList;
@property (nonatomic, strong)NSNumber *syncProgress;

@end
@interface HICMixTrainArrangeListModel : NSObject
/// 系统端当前时间
@property (nonatomic, assign) NSInteger curTime;
/// 任务类型，3-考试，4-作业，6-问卷，7-评价，8-线下课，9-签到，10-签退, 11-线下成绩",
@property (nonatomic, assign) NSInteger taskType;
/// 选修类型 1:必修， 2：选修
@property (nonatomic, assign) NSInteger studyType;
/// 培训任务活动id
@property (nonatomic, assign) NSInteger taskId;
/// 任务名称
@property (nonatomic, copy) NSString *taskName;
/// 开始时间，UTC秒; -1表示不限时间
@property (nonatomic, assign) NSInteger startTime;
/// 结束时间，UTC秒； -1表示不限时间
@property (nonatomic, assign) NSInteger endTime;
///long,optional,课程/知识/考试的媒资id",
@property (nonatomic, strong) NSNumber *resourceId;
///,知识的资源类型，0-图片，1-视频，2-音频，3-文档，4-压缩包，5-scrom，6-html
@property (nonatomic, assign) NSInteger resourceType;
@property (nonatomic, copy)NSString *partnerCode;
///string,optional,知识的文件后缀名
@property (nonatomic ,strong) NSString *docType;
///"double,optional,课程/知识总学分"
@property (nonatomic ,assign) CGFloat totalCredit;
/// "totalCreditHours": "long,optional,课程总学时(分钟)",
@property (nonatomic, strong) NSNumber *totalCreditHours;
/// "completedCreditHours": "long,optional,已花费学时",
@property (nonatomic, strong) NSNumber *completedCreditHours;
/// "progress": "double,optional,任务进度 e.g. 33.0",
@property (nonatomic ,assign) CGFloat progress;
///"classPicUrl": "string, optional, 课程/知识图片完整url",
@property (nonatomic ,strong) NSString *classPicUrl;
/// 考勤数据
@property (nonatomic, strong) OfflineTrainListAttendanceRequires *attendanceRequires;
/// 考勤任务最后执行时间(最后签到/签退时间)
@property (nonatomic, assign) NSInteger attendanceLastExeTime;
/// "offclassExceptStatus": "int, optional, 线下课任务特殊状态,3-请假，6-缺勤,7-免修",
@property (nonatomic, assign) NSInteger offclassExceptStatus;

/// 可用考试次数，如果examAllowNum为0，则不限制
@property (nonatomic, assign) NSInteger examAvaiNum;
/// 最大考试次数，0为不限制
@property (nonatomic, assign) NSInteger examAllowNum;
/// 最大考试次数，0为不限制
@property (nonatomic, assign) NSInteger examPlanStatus;
/// 考试状态，0-待考试，1-进行中，2-批阅中，3-已完成，4-缺考
@property (nonatomic, assign) NSInteger examStatus;
/// 考试得分
@property (nonatomic, assign) double examScore;
/// 考试通过分数
@property (nonatomic, assign) double examPassScore;
/// 考试总分数 -- 修改double 目前没有用到
@property (nonatomic, assign) double examTotalScore;
/// 作业状态，0-待开始，1-进行中，3-待批阅，4-批阅中，5-已完成
@property (nonatomic, assign) NSInteger workStatus;
/// 作业/问卷/评价提交时间
@property (nonatomic, assign) NSInteger commitTime;
/// 线下成绩分数
@property (nonatomic, assign) double offResultScore;
/// 线下成绩总分数
@property (nonatomic, assign) double offResultTotalScore;
/// 是否合格，0-不合格，1-合格
@property (nonatomic, assign) NSInteger offResultPass;
/// 评分方式，1-直接评分，2-是否合格
@property (nonatomic, assign) NSInteger offResultEvalType;
/// 0-未开始，1-已评分
@property (nonatomic, assign) NSInteger offResultStatus;
/// 讲师(taskType==8)
@property (nonatomic, copy) NSString *lecturer;
/// "offlineClassScore": "int, optional, 线下课成绩，-1未有成绩",
@property (nonatomic, assign) NSInteger offlineClassScore;
/// "offlineClassResult": "int, optional, 1.不合格 2.合格 3.良好 4.优秀",
@property (nonatomic, assign) NSInteger offlineClassResult;
/// "classType": "int, optional,  2.课程 3.知识"
@property (nonatomic, assign) NSInteger classType;
/// 子课程数据模型
@property (nonatomic, strong) NSMutableArray<HICMixTrainArrangeListModel *> *subTasks;
/// 内容的高度 -- 104.5 还是 82.6  还是存在子内容的扩展高度
@property (nonatomic, assign) CGFloat contentHeight;

@end
@interface OfflineMixTrainCellModel : NSObject
@property (nonatomic, strong) NSArray<NSNumber *> *listCellHeight;
@property (nonatomic, strong) NSArray<NSArray *> *listModels;
/// 全部数据类型的数据模型
/// @param arr 返回的数据
+(instancetype)createModelWithRep:(NSArray *)arr;
/// 分项显示的数据模型
/// @param dic 服务端数据字典
/// @param type 分项类型
//+(instancetype)createModelWithRep:(NSDictionary *)dic withType:(PlanDetailType)type;
@end
NS_ASSUME_NONNULL_END
