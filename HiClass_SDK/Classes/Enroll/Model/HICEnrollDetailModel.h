//
//  HICEnrollDetailModel.h
//  HiClass
//
//  Created by WorkOffice on 2020/6/8.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HICEnrollDetailModel : NSObject
/**
 "curTime":"long，required,当前时间",
 "id":"long, required, 报名id",
 "registerName":"string, required, 报名名称",
 "registerDescription":"string, optional.报名描述",
 "registerStartTime":"long, required, 报名开始时间",
 "registerEndTime":"long, required, 报名结束时间",
 "acceptAuditProcessId":" long,optional,报名审核模板id，如果无审核流程，则为0",
 "auditProcessInstanceId":" long,optional,报名审核实例id，如果无审核，则为0",
 "enrollmentNumber":"int, required, 正式录取人数，-1默认值时表示不限制",
 "applicationsNumber":"int, required,允许报名人数，-1默认值时表示不限制，与正式录取人数相同",
 "registerApplyNum":"int,required,已报名人数 ",
 "registerEnrollmentNum":"int,required,已l录取人数",
 "personInCharge":"string, required,报名负责人name,多个以,隔开",
 "abandonFlag":"int, optional,是否允许学员放弃资格1是0 否",
 "abandonEndTime":"long,optional, 放弃报名截止时间",
 "noPassReason":"String, required, 不符合报名限制的原因",
 "curApprover":"long, optional,当前流程审批者customerId",
 "curApproverName":"string, optional,当前流程审批者name",
 "registerStatus":"int,optional, 报名状态： 5：进行中，7：暂停， 10：管理员手动结束,",
 "userRegisterStatus":"int,optional, 用户报名状态 ： 0：未报名，116：审批中，121：正式学员，126：替补学员，131：放弃资格，136：取消资格，141：报名失败",
 "approvalStatus":"int,optional,报名审批状态：-1: 审批不通过，1: 审批通过",
 "approvalOpinion":"string,optional,审核意见",
 "limit":"String, required, 报名要求",
 "customerId":"String, required, 用户customerId",
 "isPassFlag":"int,required, 是否符合报名范围和报名限制",
 "createdTime":"long,optional, 报名时间",
 "giveUpTime":"long,optional,放弃报名时间",
 "trainId":"long,reqired,培训id"
"acceptAuditProcessStatus": " int,optional,报名审核模板状态0-关闭，1-开启，若无审核模板，则为0",
 */
@property (nonatomic ,strong)NSNumber *curTime;
@property (nonatomic ,strong)NSNumber *registerId;
@property (nonatomic ,strong)NSString *registerName;
@property (nonatomic ,strong)NSString *registerDescription;
@property (nonatomic ,strong)NSNumber *registerStartTime;
@property (nonatomic ,strong)NSNumber *registerEndTime;
@property (nonatomic ,strong)NSNumber *acceptAuditProcessId;
@property (nonatomic ,strong)NSNumber *auditProcessInstanceId;
@property (nonatomic ,assign)NSInteger enrollmentNumber;
@property (nonatomic ,assign)NSInteger applicationsNumber;
@property (nonatomic ,assign)NSInteger registerApplyNum;
@property (nonatomic ,assign)NSInteger registerEnrollmentNum;
@property (nonatomic ,strong)NSString *personInCharge;
@property (nonatomic ,assign)NSInteger abandonFlag;
@property (nonatomic ,strong)NSNumber *abandonEndTime;
@property (nonatomic ,strong)NSString *noPassReason;
@property (nonatomic ,strong)NSNumber *curApprover;
@property (nonatomic ,strong)NSString *curApproverName;
@property (nonatomic ,assign)NSInteger registerStatus;
@property (nonatomic ,assign)NSInteger userRegisterStatus;
@property (nonatomic ,strong)NSString *approvalOpinion;
@property (nonatomic ,assign)NSInteger approvalStatus;
@property (nonatomic ,strong)NSString *limit;
@property (nonatomic ,strong)NSString *customerId;
@property (nonatomic ,assign)NSInteger isPassFlag;
@property (nonatomic ,strong)NSNumber *createdTime;
@property (nonatomic ,strong)NSNumber *giveUpTime;
@property (nonatomic ,strong)NSNumber *trainId;
@property (nonatomic ,assign)NSInteger status;
/// int,optional,报名审核模板状态0-关闭，1-开启，若无审核模板，则为0",
@property (nonatomic ,assign)NSInteger acceptAuditProcessStatus;
@property (nonatomic ,strong)NSString *expelReason;
@end

NS_ASSUME_NONNULL_END
