//
//  HICEnrollListModel.h
//  HiClass
//
//  Created by WorkOffice on 2020/6/4.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HICEnrollListModel : NSObject
/**
 "status":"int,required,报名类型： 1-待报名，2-已完成，3-已过期",
 "id":"long, required, 报名id",
 "trainId":"long, optional, 该报名对应的培训id，如果是独立报名，则为0",
 "name":"string, required, 报名名称",
 "description":"string, optional.报名描述",
 "startTime":"long, required, 报名开始时间",
 "endTime":"long, required, 报名结束时间",
 "enrollmentNumber":"int, required, 正式录取人数限制，-1默认值时表示不限制",
 "applicationsNumber":"int, required,允许报名人数限制，-1默认值时表示不限制，与正式录取人数相同",
 "registerApplyNum":"int,required,已报名人数",
 "registerEnrollmentNum":"int,required,已l录取人数",
 "acceptAuditProcessId":" long,optional,报名审核流id，如果无审核流程，则为0",
 "abandonFlag":" int,optional,是否允许学员放弃资格1是0 否",
 "abandonEndTime":"long, required, 允许学员放弃截止时间",
 "customerId":"String, required, 用户customerId",
 "isPassFlag":"int,required, 是否符合报名范围和报名限制",
 "noPassReason":"string,optional,审核不通过原因",
 "registerStatus":"int,required, 报名状态：5：进行中，7：暂停， 10：管理员手动结束,",
 "userRegisterStatus":"int,optional, 用户报名状态：: 0：未报名   116：审批中，121：正式学员，126：替补学员，131：放弃资格，136：取消资格，141：报名失败",
 "approvalStatus":"int,optional,报名审批状态：-1: 审批不通过，1: 审批通过",
 "auditProcessInstanceId":" long,optional,报名审核实例id，如果无审核，则为0",
 "curApprover":"long,optional,当前流程的审批者customerId",
 "curApproverName":"string,optional,当前流程的审批者name",
 "curTime":"long, required, 系统当前时间(防止通过修改终端时间绕过报名限制)"
 expelReason取消资格原因字段
 */
@property (nonatomic ,strong)NSNumber *enrollId;
@property (nonatomic ,assign)NSInteger status;
@property (nonatomic ,strong)NSNumber *trainId;
@property (nonatomic ,strong)NSString *name;
@property (nonatomic ,strong)NSString *enrollDesc;
@property (nonatomic ,strong)NSNumber *startTime;
@property (nonatomic ,strong)NSNumber *endTime;
@property (nonatomic ,assign)NSInteger enrollmentNumber;
@property (nonatomic ,assign)NSInteger registerEnrollmentNum;
@property (nonatomic ,assign)NSInteger applicationsNumber;
@property (nonatomic ,assign)NSInteger registerApplyNum;
@property (nonatomic ,strong)NSNumber *acceptAuditProcessId;
@property (nonatomic ,assign)NSInteger abandonFlag;
@property (nonatomic ,strong)NSNumber *abandonEndTime;
@property (nonatomic ,strong)NSString *customerId;
@property (nonatomic ,assign)NSInteger isPassFlag;
@property (nonatomic ,strong)NSString *noPassReason;
@property (nonatomic ,assign)HICEnrollRegisterStatus registerStatus;///5：进行中，7：暂停， 10：管理员手动结束,",
@property (nonatomic ,assign)HICEnrollUserRegisterStatus userRegisterStatus;/// 0：未报名   116：审批中，121：正式学员，126：替补学员，131：放弃资格，136：取消资格，141：报名失败
@property (nonatomic ,assign)NSInteger approvalStatus;///报名审批状态：-1: 审批不通过，1: 审批通过",
@property (nonatomic ,strong)NSNumber *curApprover;
@property (nonatomic ,strong)NSString *curApproverName;
@property (nonatomic ,strong)NSNumber  *curTime;
@property (nonatomic ,strong)NSString *expelReason;
@end


NS_ASSUME_NONNULL_END
