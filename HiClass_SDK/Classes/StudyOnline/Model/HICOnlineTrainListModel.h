//
//  HICOnlineTrainListModel.h
//  HiClass
//
//  Created by WorkOffice on 2020/3/3.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HICOnlineTrainListModel : NSObject
/**
"taskId": "long, required, 任务对应的id",
       "taskName": "string, required, 任务对应的名称",
       "startTime": "long, optional, 开始时间",
       "endTime": "long, optional, 结束时间",
       "trainPos": "string, optional, 培训地点",
       "trainLevel": "int, optional , 培训级别，1:集团级，2：公司级",
       "trainCat": "int, optional, 培训类型，11：分内部培训、12：外请内训、13：外送培训",
       "trainAssigner": "string, optional, 培训指派人名称",
       "trainLecturer": "string, optional, 培训讲师",
       "trainType": "int, optional, 1:线上培训，2：线下培训，3：混合培训",
       "trainProgress": "float, optional, 线上培训进度， e.g. 0.33",
       "trainTerminated": "int, optional, 培训是否被管理员结束，1:是，0:否
 "progressStatus": "int, required, 1:进行中,  2:已开始, 3:已结束 ",
 "curTime": "long, required, 系统当前时间(防止通过修改终端时间绕过考试限制)"
 "trainId": "long, required, 培训id",
        "trainName": "string, required, 培训名称",
        "startTime": "long, optional, 开始时间",
        "endTime": "long, optional, 结束时间",
        "trainPos": "string, optional, 培训地点",
        "trainCat": "int, optional, 培训类型，培训类型，线上培训：1-默认计划，2-学习计划，线下培训、混合培训：11-分内部培训，12-外请内训，13-外送培训",
        "trainAssigner": "string, optional, 培训指派人名称",
        "trainType": "int, optional, 1:线上培训，2：线下培训，3：混合培训",
        "trainProgress": "double, optional, 线上培训进度， e.g. 0.33",
        "trainTerminated": "int, optional, 培训是否被管理员结束，10-是，其余值-否",
        "curTime": "long, required, 系统当前时间(防止通过修改终端时间绕过考试限制)",
        "isImportant": "int, required, 是否重要，1-是，0-否"
 "trainLevel": "int, optional, 培训级别 1:集团级， 2:公司级， 3：部门级",
        "trainResult": "float, optional, 线下培训老师评价_打分",
        "trainConclusion": "int, optional, 线下培训老师评价_结论，1:合格，2:不合格，3:肄业"
 "registChannel":"int, optional, 是否通过报名方式参与培训：0-非报名，1-报名(仅存在于线下培训和混合培训)"
            
*/
@property (nonatomic, strong)NSNumber *trainId;//任务对应的id",
@property (nonatomic, strong)NSString *trainName;//
@property (nonatomic, strong)NSNumber *startTime;//
@property (nonatomic, strong)NSNumber *endTime;//
@property (nonatomic, strong)NSString *trainPos;//
//@property (nonatomic, assign)NSInteger trainLevel;//
@property (nonatomic, assign)NSInteger trainCat;///1-默认计划，2-学习计划，线下培训、混合培训：11-分内部培训，12-外请内训，13-外送培训",
@property (nonatomic, strong)NSString *trainAssigner;///
@property (nonatomic, assign)NSInteger trainType;///1:线上培训，2：线下培训，3：混合培训",
@property (nonatomic, assign)CGFloat trainProgress;//
@property (nonatomic, assign)NSInteger trainTerminated;//
@property (nonatomic, strong)NSNumber *curTime;//
@property (nonatomic, assign)NSInteger isImportant;//
@property (nonatomic, assign)NSInteger status;
@property (nonatomic, assign)NSInteger trainLevel;///培训级别 1:集团级， 2:公司级， 3：部门级",
@property (nonatomic, assign)CGFloat trainResult;
@property (nonatomic, assign)NSInteger trainConclusion;
@property (nonatomic, assign)NSInteger registChannel;
@property (nonatomic, strong)NSNumber * registerId;//"registerId ":  "long, optional, 报名id",
@property (nonatomic,strong) NSString *scene;
@end

NS_ASSUME_NONNULL_END
