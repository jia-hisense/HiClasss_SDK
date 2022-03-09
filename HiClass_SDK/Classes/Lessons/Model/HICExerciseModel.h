//
//  HICExerciseModel.h
//  HiClass
//
//  Created by WorkOffice on 2020/2/17.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HICExerciseModel : NSObject
//"id": "long,关联明细ID",
//       "resourceType": "integer,资源类型  1-练习题集",
//       "exerciseInfo": {
//         "exerciseId": "long,练习题集ID",
//         "exerciseName": "string,练习题集名称",
//         "status": "integer,状态（考试记录状态）",
//         "answerNum": "integer,已答题数",
//         "totalNum": "integer,题",
//         "displayOrder": "integer,展示顺序",
//         "participantNum": "integer,参与答题人数"
@property (nonatomic ,strong)NSNumber *exerciseId;//long,练习题集ID
@property (nonatomic ,strong)NSString *exerciseName;//练习题集名称
@property (nonatomic ,assign)NSInteger status;//"integer,状态（考试记录状态）"
@property (nonatomic ,assign)NSInteger answerNum;//"integer,"integer,已答题数""
@property (nonatomic ,assign)NSInteger totalNum;//"integer,题"
@property (nonatomic ,assign)NSInteger participantNum;//"integer,参与答题人数"
@property (nonatomic ,assign)NSInteger displayOrder;//展示顺序
@property (nonatomic ,assign)NSInteger times;//练习次数
@end

NS_ASSUME_NONNULL_END
