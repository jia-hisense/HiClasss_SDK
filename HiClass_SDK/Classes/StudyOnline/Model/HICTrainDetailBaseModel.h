//
//  HICTrainDetailBaseModel.h
//  HiClass
//
//  Created by WorkOffice on 2020/3/5.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HICTrainDetailBaseModel : NSObject
/**
 "trainId": "long, required, 培训id",
 "trainName": "string, required, 培训名称",
 "startTime": "long, optional, 开始时间",
 "endTime": "long, optional, 结束时间",
 "totalCredit": "double, required, 总学分",
 "completedCredit": "double, required, 已获得学分",
 "totalNum": "int, required, 总学员人数",
 "position": "int, required, 当前用户排名",
 "progress": "double, required, 进度，e.g. 35.0",
 "assigner": "string, optional, 指派人名字",
 "isImportant": "int, required, 是否重要，1-是，0-否""
 "int, requred, 培训是否同步进度, 1：是，0：否
 "trainComment": "string,optional,培训描述",
 "trainGoal": "string,optional,培训目标",
 "trainAudience": "string,optional,培训对象",
  "stageIsOrder": "int, required, 阶段间是否按照顺序学习，1-是，0-否"
 "status": "int, required, 1-进行中，2-待开始，3-已完成",
    "curTime": "long, required, 系统当前时间(防止通过修改终端时间绕过考试限制)
 "totalCreditHours": "long, required, 总学时",
       "completedCreditHours": "long, required, 已获得学时",
 */

@property (nonatomic, strong)NSNumber *trainId;
@property (nonatomic, strong)NSString *trainName;
@property (nonatomic, strong)NSNumber *startTime;
@property (nonatomic, strong)NSNumber *endTime;
@property (nonatomic, assign)CGFloat totalCredit;
@property (nonatomic, assign)CGFloat completedCredit;
@property (nonatomic, strong)NSNumber *totalCreditHours;
@property (nonatomic, strong)NSNumber *points;
@property (nonatomic, strong)NSNumber *completedCreditHours;
@property (nonatomic, assign)NSInteger totalNum;
@property (nonatomic, assign)NSInteger position;
@property (nonatomic, assign)CGFloat progress;
@property (nonatomic, strong)NSString *assigner;
@property (nonatomic, assign)NSInteger isImportant;
@property (nonatomic, assign)NSInteger syncProgress;
@property (nonatomic ,strong)NSString *trainComment;
@property (nonatomic ,strong)NSString *trainGoal;
@property (nonatomic ,strong)NSString *trainAudience;
@property (nonatomic ,assign)NSInteger stageIsOrder;
@property (nonatomic ,assign)NSInteger status;
@property (nonatomic ,strong)NSNumber *curTime;
@property (nonatomic ,strong)NSString *leaderNames;
@end
/**
 "id": "long, required, 证书id",
 "name": "string, required, 证书名称",
 "employeeCertId": "long, optional, 人员证书id（已获得的才有，未获得的为0）",
 "url": "string, required, 证书url",
 "acquired": "int, required, 当前用户是否已获得此证书: 0-未获得，1-已获得"
 */
@interface HICTrainCertificateModel : NSObject
@property (nonatomic ,strong)NSNumber *certId;
@property (nonatomic ,strong)NSString *name;
@property (nonatomic ,strong)NSNumber *employeeCertId;
@property (nonatomic ,strong)NSString *url;
@property (nonatomic ,assign)NSInteger acquired;
@end
NS_ASSUME_NONNULL_END
