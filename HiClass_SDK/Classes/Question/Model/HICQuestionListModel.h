//
//  HICQuestionListModel.h
//  HiClass
//
//  Created by WorkOffice on 2020/6/8.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HICQuestionListModel : NSObject
/**
"actionId":"long, required, 任务对应的活动id",
               "actionName":"string, required, 任务对应的活动名称",
               "startTime":"long, required, 活动开始时间",
               "endTime":"long, required, 活动结束时间",
               "type":"int, required, 类型  1：问卷 2：评价",
               "state":"short, required , 2.待参与   5.已完成  6.已过期",
               "isEnd":"int,required,0:未结束，1：已结束 ",
               "questionAssigner":"string, optional, 问卷发起人",
               "commitTime":"long，optional，提交时间"

*/
@property (nonatomic, strong)NSNumber *actionId;
@property (nonatomic, strong)NSString *actionName;
@property (nonatomic, strong)NSNumber *startTime;
@property (nonatomic, strong)NSNumber *endTime;
@property (nonatomic, assign)NSInteger type;
@property (nonatomic, assign)NSInteger state;
@property (nonatomic, assign)NSInteger isEnd;
@property (nonatomic, strong)NSString *questionAssigner;
@property (nonatomic, strong)NSNumber *commitTime;
@property (nonatomic, strong)NSNumber *points;
@end

NS_ASSUME_NONNULL_END
