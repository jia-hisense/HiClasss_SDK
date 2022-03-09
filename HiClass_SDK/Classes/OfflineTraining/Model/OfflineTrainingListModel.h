//
//  OfflineTrainingListModel.h
//  HiClass
//
//  Created by 铁柱， on 2020/4/22.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 线下培训菜单显示项
typedef enum : NSUInteger {
    PlanDetailType_All,             // 全部
    PlanDetailType_Class,           // 课程
    PlanDetailType_Sign,            // 考勤
    PlanDetailType_Exam,            // 考试
    PlanDetailType_Homework,        // 作业
    PlanDetailType_Questionnaire,   // 问卷
    PlanDetailType_Evaluate,        // 评价
    PlabDetailType_Grade,           // 成绩
} PlanDetailType;

NS_ASSUME_NONNULL_BEGIN

@interface OfflineTrainListAttendanceRequires : NSObject
/// 签到经度
@property (nonatomic, copy) NSString *longitude;
/// 签到维度
@property (nonatomic, copy) NSString *latitude;
/// 签到半径
@property (nonatomic, assign) NSInteger radius;
/// 签到地点
@property (nonatomic, copy) NSString *locationName;
/// 正常考勤开始时间
@property (nonatomic, assign) NSInteger startTime;
/// 正常考勤结束时间
@property (nonatomic, assign) NSInteger endTime;
/// 迟到签到时间(正常签到开始时间后几分钟内)，超出不允许签到
@property (nonatomic, assign) NSInteger lateArrivalThreshold;
// 签到方式(多种签到方式，以英文逗号衔接) --- 废弃
//@property (nonatomic, copy) NSString *type;
/// 签到口令
@property (nonatomic, copy) NSString *password;

@end


@interface OfflineTrainingListModel : NSObject
/// 系统端当前时间
@property (nonatomic, assign) NSInteger curTime;
/// train_stage_task表的id
@property (nonatomic, assign) NSInteger trainId;
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
/// 考勤数据
@property (nonatomic, strong) OfflineTrainListAttendanceRequires *attendanceRequires;
/// 考勤任务最后执行时间(最后签到/签退时间)
@property (nonatomic, assign) NSInteger attendanceLastExeTime;
/// 线下课任务特殊状态 3：请假,6-缺勤,7-免修
@property (nonatomic, assign) NSInteger offclassExcptStatus;
/// 评价/问卷提交时间 -- 作废
@property (nonatomic, assign) NSInteger questionCommitTime;
/// 可用考试次数，如果examAllowNum为0，则不限制
@property (nonatomic, assign) NSInteger examAvaiNum;
/// 最大考试次数，0为不限制
@property (nonatomic, assign) NSInteger examAllowNum;
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
/// 线下成绩得分
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
/// 子课程数据模型
@property (nonatomic, strong) NSArray<OfflineTrainingListModel *> *subTasks;

#pragma mark - cell内部单个条目私有属性
/// 内容的高度 -- 104.5 还是 82.6  还是存在子内容的扩展高度
@property (nonatomic, assign) CGFloat contentHeight;

@end

@interface OfflineTrainListCellModel : NSObject

/// 对应的cell的相应的数据信息，注册信息可以不用，因为是通过菜单切换的，因此目前可以只存储cell高度
@property (nonatomic, strong) NSArray<NSNumber *> *listCellHeight;
/// 对应cell的日期时间字符串
@property (nonatomic, strong) NSArray<NSString *> *listCellTimes;
/// 今天所在的数组的位置，同样也是table对应的row的位置 -- 默认值-1
@property (nonatomic, assign) NSInteger currentTimeIndex;

/// 解析成 cell的模型数组 -- 会按时间整合排序，可能存在多条数据
@property (nonatomic, strong) NSArray<NSArray *> *listModels;

/// 全部数据类型的数据模型
/// @param dic 返回的数据字典
+(instancetype)createModelWithRep:(NSDictionary *)dic;

/// 分项显示的数据模型
/// @param dic 服务端数据字典
/// @param type 分项类型
+(instancetype)createModelWithRep:(NSDictionary *)dic withType:(PlanDetailType)type;
@end
NS_ASSUME_NONNULL_END
