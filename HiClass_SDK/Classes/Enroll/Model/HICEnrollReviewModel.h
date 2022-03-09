//
//  HICEnrollReviewModel.h
//  HiClass
//
//  Created by WorkOffice on 2020/6/12.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HICEnrollReviewModel : NSObject
@property (nonatomic ,strong)NSNumber *auditId;
@property (nonatomic ,strong)NSString *name;
@property (nonatomic ,strong)NSNumber *displayOrder;
@property (nonatomic ,strong)NSMutableArray *auditTemplateNodeAuditors;
@property (nonatomic ,strong)NSString *auditorName;
@property (nonatomic ,strong)NSNumber *auditorId;
@end

@interface HICEnrollReviewerModel : NSObject
/**
{
  "resultCode": "integer,结果标识  0-成功|1-失败",
  "data": {
    "id": "long,审核模板id",
    "name": "string,审核模板名称",
    "type": "integer,审核模板类型：1-试卷审核，2-试题审核，5-知识课程审核，8-报名审核，9-请假审核",
    "auditTemplateNodes": [
      {
        "id": "long,审核模板节点ID",
        "name": "string,审核模板节点名称",
        "displayOrder": "integer,节点排序，无明确定义从0/1开始，只是相对概念",
        "auditTemplateNodeAuditors": [
          {
            "id": "long,主键",
            "customerId": "long,审核人ID",
            "name": "string,审核人名称",
            "email": "string,审核人邮箱",
            "departmen": "string,审核人部门信息"
          }
        ]
      }
    ],
    "auditTemplateContainerStatus": "integer,所属模板集合状态 0-关闭，1-开启"
  },
  "signatureServer": "string,下行签名"
}
*/
@property (nonatomic ,strong)NSNumber *auditorKey;
@property (nonatomic ,strong)NSNumber *customerId;
@property (nonatomic ,strong)NSString *name;
@property (nonatomic ,strong)NSString *email;
@property (nonatomic ,strong)NSString *department;
@property (nonatomic ,assign)BOOL isSelected;
@end
/**
 data": {
   "id": "long,审核流ID",
   "name": "string,审核流名称",
   "status": "integer,审核状态，0-待审核，1-审核中，2-审核通过，3-审核拒绝",
   "auditProcessNodes": [
     {
       "id": "long,审核流节点ID",
       "name": "string,审核流节点名称",
       "auditTime": "long,审核时间，时间戳，单位秒，默认值：0",
       "auditOpinion": "string,审核意见，默认值：“”",
       "status": "integer,审核状态，0-待审核，2-审核通过，3-审核拒绝",
       "auditProcessNodeAuditor": {
         "id": "long,主键",
         "customerId": "long,审核人ID",
         "name": "string,审核人名称",
         "email": "string,审核人邮箱",
         "department": "string,审核人部门信息"
       }
     }
   ]
 },

 */

@interface HICEnrollReviewProcessModel : NSObject
@property (nonatomic ,strong)NSNumber *auditNodeId;
@property (nonatomic ,strong)NSString *name;
@property (nonatomic ,strong)NSNumber *auditTime;
@property (nonatomic ,strong)NSString *auditOpinion;
@property (nonatomic ,assign)NSInteger status;
@property (nonatomic ,strong)HICEnrollReviewerModel *auditProcessAuditor;
@end
@interface HICEnrollReviewStatusModel :NSObject
@property (nonatomic ,strong)NSNumber *auditInstanceId;
@property (nonatomic ,strong)NSString *name;
///"status": "integer,审核状态，0-待审核，1-审核中，2-审核通过，3-审核拒绝",
@property (nonatomic ,assign)NSInteger status;
@property (nonatomic, strong)NSArray<HICEnrollReviewProcessModel *> *auditProcessNodes;
@end
NS_ASSUME_NONNULL_END
