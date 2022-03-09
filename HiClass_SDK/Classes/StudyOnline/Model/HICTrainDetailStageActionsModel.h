//
//  HICTrainDetailStageActionsModel.h
//  HiClass
//
//  Created by WorkOffice on 2020/3/5.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HICTrainDetailStageActionsModel : NSObject
/**
"taskId":"long, required, 培训内task的id",
                   "taskType":"int, required, 任务对应的类型, e.g. 1:考试, 2:课程, 3:知识, 4:问卷，5:作业",
                   "taskName":"string, required, 任务在阶段内的名称",
                   "startTime":"long, optional, 开始时间",
                   "endTime":"long, optional, 结束时间",
                   "classId":"long, optional, 课程 或 知识的 媒资id",
                   "totalCredit":"int, optional, 课程总学分",
                   "completedCredit":"int, optional, 已获得学分",
                   "totalCreditHours":"int, optional, 课程总学时(分钟)",
                   "completedCreditHours":"int, optional, 以花费学时",
                   "classMediaType":"int, optional, 知识的媒资类型(0-图片，1-视频，2-音频，3-文档，4-压缩包，5-scrom,6-html)",
                   "classProgress":"float, optional, 课程进度 e.g. 0.33",
                   "classPicUrl":"string, optional, 课程/知识 图片完整url",
                   "examDuration":"short, optional, 考试时长,时间为分钟",
                   "examAvaiNum":"short, optional, 可用考试次数",
                   "examAllowNum":"int, optional, 最大考试次数",
                   "examTotalScore":"int, optional, 考试总分, e.g. 100",
                   "examPassThresh":"int, optional, 通过分数, e.g. 60",
                   "examScore":"int, optional, 实际分数",
                   "examStatus1":"integer,考试状态 0-待考试，1-进行中，2-批阅中，3-已完成，4-缺考",
                   "examStatus2":"integer,考试安排状态，0-未发布、1-进行中、2-已结束、3-已归档",
                   "workStatus":"int, optional, 作业状态(未开始/写作业/待批阅/批阅中/已完成)",
                   "workCommitTime":"long, optional, 作业提交时间",
                   "questionMediaId":"long, optional, 问卷媒资id",
                   "questionCommitTime":"long, optional, 问卷提交时间"
 
                            "offResultScore": "double,optional,线下成绩得分",
                            "offResultTotalScore": "double,optional,线下成绩总分数",
                            //"offResultPass": "int,optional,是否合格，0-不合格，1-合格",
                            //"offResultEvalType": "int,optional,评分方式，1-直接评分，2-是否合格",
                            //"offResultStatus": "int,optional,0-未开始，1-已评分"
 "commitTime": "long,作业/问卷/实操提交时间",
 "status": "string,任务状态（实操）：0-未申请 1-已申请  2-已提交",
 "score": "decimal,任务得分（实操）：保留一位小数",
 "passScore": "decimal,任务通过分数(实操)：保留1位小数",

                
 */
@property (nonatomic, strong)NSNumber *taskId;//
@property (nonatomic, assign)NSInteger taskType;//
@property (nonatomic, strong)NSString *taskName;//
@property (nonatomic, assign)NSInteger orderNo;//int,required,任务序号",
@property (nonatomic, strong)NSNumber *startTime;//
@property (nonatomic, strong)NSNumber *endTime;//
@property (nonatomic, strong)NSNumber *resourceId;//"long,optional,课程/知识/考试的媒资id",
@property (nonatomic, assign)CGFloat totalCredit;//
@property (nonatomic, assign)CGFloat completedCredit;//
@property (nonatomic, assign)NSInteger totalCreditHours;//
@property (nonatomic, assign)NSInteger completedCreditHours;//
//@property (nonatomic, assign)NSInteger classMediaType;//
@property (nonatomic, assign)CGFloat progress;//
@property (nonatomic, strong)NSString *classPicUrl;//
//@property (nonatomic, assign)NSInteger examDuration;//
@property (nonatomic, assign)NSInteger examAvaiNum;//
@property (nonatomic, assign)NSInteger examAllowNum;//
//@property (nonatomic, assign)NSInteger examTotalScore;//
//@property (nonatomic, assign)NSInteger examPassThresh;//
//@property (nonatomic, assign)NSInteger examScore;//
@property (nonatomic, assign)NSInteger examStatus;//
@property (nonatomic, assign)NSInteger workStatus;//
//@property (nonatomic, assign)NSNumber *workCommitTime;//
@property (nonatomic, strong)NSNumber *commitTime;//long,作业/问卷/实操提交时间
@property (nonatomic, assign)NSInteger resourceType;
@property (nonatomic, copy)NSString *partnerCode;
@property (nonatomic ,copy)NSString *docType;
@property (nonatomic ,assign)CGFloat offResultScore;
@property (nonatomic ,assign)CGFloat offResultTotalScore;
@property (nonatomic, assign)NSInteger offResultPass;///"offResultPass": "int,optional,是否合格，0-不合格，1-合格",
@property (nonatomic, assign)NSInteger offResultEvalType;///"offResultEvalType": "int,optional,评分方式，1-直接评分，2-是否合格",
@property (nonatomic, assign)NSInteger offResultStatus;///"offResultStatus": "int,optional,0-未开始，1-已评分"
///string,任务状态（实操）：0-未申请 1-已申请  2-已提交",
@property (nonatomic ,strong)NSString *status;
///任务得分（实操）：保留一位小数",
@property (nonatomic ,assign)CGFloat score;
///"decimal,任务通过分数(实操)：保留1位小数",
@property (nonatomic ,assign)CGFloat passScore;
/// "passFlag": "integer,任务是否合格（实操）：0-不合格，1-合格"
@property (nonatomic ,assign)NSInteger passFlag;
@end

NS_ASSUME_NONNULL_END
