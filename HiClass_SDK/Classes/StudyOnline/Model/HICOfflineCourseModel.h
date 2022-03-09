//
//  HICOfflineCourseModel.h
//  HiClass
//
//  Created by WorkOffice on 2020/4/20.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HICOfflineCourseModel : NSObject
/**
 "data":{
       "name":"string, required, 课程名称",
       "startTime":"long, required, 课程开始时间",
       "endTime":"long, required, 课程结束时间",
       "location":"string, optional, 上课地点",
       "comment":"string, optional, 课程描述信息",
       "rewardCredit":"float, optional, 奖励学分",
       "rewardCreditHours":"float, optional, 奖励学时",
       "rewardPoints":"float, optional, 奖励积分",
       "lecturerId":"long , required",
       "lecturerName":"string , required",
       "lecturerPost":"string, required, 公司-部门-职位",
       "lecturerInfo":"string, optional, 讲师简介",
       "trainees":"string, optional, 培训对象",
       "referenceMaterials":Array[1],参考资料
 {
        "name": "string, required, 参考资料名称",
        "url": "string, required, 参考资料full url"
      }
       "score":"float, optional, 成绩",
       "scoreGroup":"int, optional, 评级，1：不合格，5：合格，10：良好，15：优秀",
       "classPerformRating":Array[1],课堂表现得分--原因"课堂表现得分--得分
 {
         "reason": "string, classPerformRating内必填, 课堂表现得分--原因",
         "points": "float, classPerformRating内必填, 课堂表现得分--得分"
       }
       "subTasks":Array[1]
   }
 */
@property (nonatomic ,strong)NSString *name;
@property (nonatomic ,strong)NSNumber *startTime;
@property (nonatomic ,strong)NSNumber *endTime;
@property (nonatomic ,strong)NSString *location;
@property (nonatomic ,strong)NSString *comment;
@property (nonatomic ,assign)CGFloat rewardCredit;
@property (nonatomic ,assign)CGFloat rewardCreditHours;
@property (nonatomic ,assign)CGFloat rewardPoints;
@property (nonatomic ,strong)NSNumber *lecturerId;
@property (nonatomic ,strong)NSString *lecturerName;
@property (nonatomic ,strong)NSString *lecturerPost;
@property (nonatomic ,strong)NSString *lecturerInfo;
@property (nonatomic ,strong)NSString *trainees;
@property (nonatomic ,strong)NSArray *referenceMaterials;
@property (nonatomic ,assign)CGFloat score;
@property (nonatomic ,assign)NSInteger scoreGroup;
@property (nonatomic ,strong)NSArray *classPerformRating;
@property (nonatomic ,strong)NSArray *subTasks;
@end

/**
 "reason":"string, classPerformRating内必填, 课堂表现得分--原因",
 "points":"float, classPerformRating内必填, 课堂表现得分--得分"
 
 */
@interface HICOfflineClassPerformModel : NSObject
@property (nonatomic ,strong)NSString *reason;
@property (nonatomic ,assign)CGFloat points;
@end
/**
 "name":"string, required, 参考资料名称",
                "url":"string, required, 参考资料full url"
 */
@interface HICOfflineReferenceModel : NSObject
@property (nonatomic ,strong)NSString *name;
@property (nonatomic ,strong)NSString *url;
@end
NS_ASSUME_NONNULL_END
