//
//  HICHomeTaskCenterModel.h
//  iTest
//
//  Created by Sir_Jing on 2020/3/14.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

/// 首页今日任务 和 任务中心的数据模型  ---  可通用
@interface HICHomeTaskCenterModel : NSObject

/// 任务类型,1-考试,2-培训,3-问卷,4-报名(含独立报名和培训报名),5-评价（已作废），6-直播
@property (nonatomic, assign) NSInteger taskType;

/// 任务对应的id
@property (nonatomic, assign) NSInteger taskId;

/// 任务对应的名称
@property (nonatomic, copy) NSString *taskName;

/// 是否重要，1-是，0-否
@property (nonatomic, assign) NSInteger isImportant;

/// 开始时间
@property (nonatomic, assign) NSInteger startTime;

///结束时间
@property (nonatomic, assign) NSInteger endTime;

///指派人名字
@property (nonatomic, copy) NSString *assigner;

///考试时长, 单位：分
@property (nonatomic, assign) NSInteger examDuration;

///考试总分数
@property (nonatomic, assign) double examTotalScore;

///考试通过分数
@property (nonatomic, assign) double examPassScore;

///可用考试次数
@property (nonatomic, assign) NSInteger examAvaiNum;

///最大考试次数
@property (nonatomic, assign) NSInteger examAllowNum;

///培训地点
@property (nonatomic, copy) NSString *trainPos;

///培训级别，1-集团级，2-公司级，3-部门级
@property (nonatomic, assign) NSInteger trainLevel;

///培训类型，11-内部培训，12-外请内训，13-外送培训
@property (nonatomic, assign) NSInteger trainCat;

///1-在线学习，2-线下培训，3-混合培训
@property (nonatomic, assign) NSInteger trainType;

//线上培训进度，e.g. 33.0
@property (nonatomic, assign) double trainProgress;

///该报名对应的培训id，如果是独立报名，则为0
@property (nonatomic, assign) NSInteger registerTrainId;

///已报名人数
@property (nonatomic, assign) NSInteger registerApplyNum;
///已录取人数
@property (nonatomic, assign) NSInteger registerEnrollmentNum;
///int, required, 正式录取人数限制，-1默认值时表示不限制
@property (nonatomic, assign) NSInteger enrollmentNumber;
/// "applicationsNumber": "int, required,允许报名人数限制，-1默认值时表示不限制，与正式录取人数相同",
///
///报名状态
@property (nonatomic ,assign) NSInteger registerStatus;
///混合培训场景
@property (nonatomic ,strong) NSString *scene;
/// "trainResult": "double,optional,线下/混合培训成绩，-1为未打分",
@property (nonatomic ,assign) CGFloat trainResult;
///"trainConclusion": "int,optional,线下/混合培训结论，0-肄业，1-合格，2-不合格，-1为未打分",
@property (nonatomic ,assign) NSInteger trainConclusion;
///"registerId ": "long, optional, 报名id",
@property (nonatomic ,strong)NSNumber *registerId;
///"registChannel": "int, optional, 是否通过报名方式参与培训：0-非报名，1-报名(仅存在于线下培训和混合培训)"
@property (nonatomic ,assign) NSInteger registChannel;

@property (nonatomic, strong) NSArray *liveTeacherList;
@property (nonatomic, strong) NSNumber *points;

/// 创建含有此模型的数组方法
/// @param data 网络请求数据 -- 原始数据
/// @param name 数组名称 -- 转化的名称。
+(NSArray *)createModelWithSourceData:(NSDictionary *)data name:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
