//
//  HICTrainDetailListModel.h
//  HiClass
//
//  Created by WorkOffice on 2020/3/5.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HICTrainDetailListModel : NSObject
/**
 "stageId": "long,required,阶段id",
     "stageName": "string,required,阶段名称",
     "stageNo": "int,required,阶段序号",
     "stageEndTime": "long,required,阶段结束时间",
     "isOrder": "int,required,阶段内任务是否按照顺序学习，1-是，0-否",
     "taskNum": "int,required,任务总数",
     "completedTaskNum": "int,required,完成任务数",
     "curTime": "long,required,系统当前时间(防止终端用户通过修改本地时间绕过限制)",
 "stageIsOrder": "int, required, 阶段间是否按照顺序学习，1-是，0-否",
     "stageActionList":
 */
@property (nonatomic ,strong) NSNumber *stageId;
@property (nonatomic ,strong) NSString *stageName;
@property (nonatomic ,assign) NSInteger stageNo;
@property (nonatomic ,strong) NSNumber *stageEndTime;
@property (nonatomic ,assign) NSInteger isOrder;
@property (nonatomic ,assign) NSInteger stageIsOrder;
@property (nonatomic ,assign) NSInteger taskNum;
@property (nonatomic ,assign) NSInteger completedTaskNum;
@property (nonatomic ,strong) NSNumber *curTime;
@property (nonatomic ,strong) NSNumber *points;
@property (nonatomic ,assign) NSInteger trainTerminated;
@property (nonatomic ,strong) NSArray *stageActionList;
@end

NS_ASSUME_NONNULL_END
