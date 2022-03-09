//
//  HICLectureDetailModel.h
//  HiClass
//
//  Created by WorkOffice on 2020/3/12.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HICLectureDetailModel : NSObject
/*
 "id":"long, required, 讲师id",
 "customerId":"string, optional, cusId",
 "headPortraitUrl":"string, optional, 讲师头像",
 "type":"int, required, 讲师类型，0-内部讲师，1-外部讲师",
 "name":"string, required, 讲师名字",
 "knowledgeNum":"int, required, 知识数",
 "offlineClassNum":"int, required, 线下课程数",
 "teachingHourNum":"int, required, 授课课时",
 "province":"string, optional, 省",
 "city":"string, optional, 市",
 "groupLevel":"string, optional, 集团级别名称",
 "companyLevel":"string, optional, 公司级别名称",
 "postName":"string, optional，岗位名称",
 "deptName":"string, optional, 部门名称",
 "briefIntroduction":"string, optionaal, 简介",
 "tagList":[
 */
@property (nonatomic ,strong)NSNumber *lectureId;
@property (nonatomic ,strong)NSNumber *customerId;
@property (nonatomic ,strong)NSString *headPortraitUrl;
@property (nonatomic ,assign)NSInteger type;
@property (nonatomic ,strong)NSString *name;
@property (nonatomic ,assign)NSInteger knowledgeNum;
@property (nonatomic ,assign)NSInteger offlineClassNum;
@property (nonatomic ,assign)NSInteger teachingHourNum;
@property (nonatomic ,strong)NSString *province;
@property (nonatomic ,strong)NSString *city;
@property (nonatomic ,strong)NSString *groupLevel;
@property (nonatomic ,strong)NSString *companyLevel;
@property (nonatomic ,strong)NSString *postName;
@property (nonatomic ,strong)NSString *deptName;
@property (nonatomic ,strong)NSString *briefIntroduction;
@property (nonatomic ,strong)NSArray *tagList;
@end

NS_ASSUME_NONNULL_END
