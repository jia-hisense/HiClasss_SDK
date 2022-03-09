//
//  HICNotEnrollCourseArrangeModel.h
//  HiClass
//
//  Created by WorkOffice on 2020/6/11.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface HICNotEnrollCourseArrangeModel : NSObject
/**
 {
     "curTime":"Long,required,当前时间",
     "trainId":"Long, required,培训id",
     "classActionId":"Long, required,培训线下课id",
     "resClassName":"string,课程名称",
     "lecturerName":"string,讲师name",
     "taskType":"int,任务类型 1：课程 ，2：知识，8：线下课",
     "classStages":[
         {
             "classStartTime":"long, required,开始时间",
             "classEndTime":"long, required,结束时间",
             "place":"string，required,上课地点"
 "startTime":1593055433,
     "endTime":1593100766,
     "place":"海信食堂"
 }
         }
     ]
 }
 */
@property (nonatomic ,strong)NSNumber *curTime;
@property (nonatomic ,strong)NSNumber *trainId;
@property (nonatomic ,strong)NSNumber *classActionId;
@property (nonatomic ,strong)NSString *resClassName;
@property (nonatomic ,strong)NSString *lecturerName;
@property (nonatomic ,assign)NSInteger taskType;
@property (nonatomic ,strong)NSArray *classStages;
@end
@interface HICClassStageModel : NSObject
@property (nonatomic ,strong)NSNumber *startTime;
@property (nonatomic ,strong)NSNumber *endTime;
@property (nonatomic ,strong)NSString *place;
@end
NS_ASSUME_NONNULL_END
