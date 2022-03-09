//
//  HICHomeStudyClassModel.h
//  iTest
//
//  Created by Sir_Jing on 2020/3/14.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 关联课程知识信息
@interface HSCourseKLD : NSObject

/// 类型（6-课程，7-知识）
@property (nonatomic, assign) NSInteger courseKLDType;

/// 课程知识ID
@property (nonatomic, assign) NSInteger courseKLDId;

/// 课程知识名称
@property (nonatomic, copy) NSString *courseKLDName;

/// 封面图URL
@property (nonatomic, copy) NSString *coverPic;

/// 资源类型（针对知识） 0-图片，1-视频，2-音频，3-文档，4-压缩包，5-scrom,6-html
@property (nonatomic, assign) NSInteger resourceType;

/// 资源分类图片URL（针对知识）-- 作废
@property (nonatomic, copy) NSString *resourcePic;

/// 评分
@property (nonatomic, assign) NSInteger score;

/// 学分（已得学分/总学分
@property (nonatomic, copy) NSString *credit;

/// 已使用学时，单位分钟
@property (nonatomic, assign) NSInteger creditHoursUsed;

/// 学时，单位分钟
@property (nonatomic, assign) NSInteger creditHours;

/// 学习人数，默认0
@property (nonatomic, assign) NSInteger learnersNum;

/// 是否最新发布（3天内发布）0-否，1-是
@property (nonatomic, assign) NSInteger isNew;

@end

@interface HSContributor : NSObject

/// 用户ID
@property (nonatomic, assign) NSInteger customerId;

/// 用户名称
@property (nonatomic, copy) NSString *name;

/// 用户头像URL
@property (nonatomic, copy) NSString *picUrl;

/// 职级信息
@property (nonatomic, copy) NSString *positions;

/// 简介信息
@property (nonatomic, copy) NSString *synopsis;

@end

@interface HSAuthor : NSObject

/// 用户ID
@property (nonatomic, assign) NSInteger authorID;

/// 作者ID
@property (nonatomic, copy) NSString *name;

/// 人员类型:1-系统内人员，2-外部人员
@property (nonatomic, copy) NSString *type;

/// 系统内人员信息
@property (nonatomic, strong) HSContributor *customer;

@end

@interface HSAuditLog : NSObject

/// 审核流程ID
@property (nonatomic, assign) NSInteger logID;

/// 知识课程ID
@property (nonatomic, assign) NSInteger objectId;

/// 审核对象类型：5-知识课程
@property (nonatomic, copy) NSString *type;

/// 审核状态：0-待审核，1-审核中，2-审核通过，3-审核拒绝
@property (nonatomic, assign) NSInteger status;

/// 审核时间，秒级时间戳
@property (nonatomic, assign) NSInteger updateTime;

/// 审核人
@property (nonatomic, strong) HSContributor *customer;

@end

/// 首页知识列表的数据模型
@interface HICHomeStudyClassModel : NSObject

@property (nonatomic, assign) NSInteger classID;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, strong) HSCourseKLD *courseKLD;

@property (nonatomic, strong) HSContributor *contributor;

@property (nonatomic, strong) HSAuthor *author;

@property (nonatomic, strong) HSAuditLog *auditLog;

/// 创建含有此模型的数组方法
/// @param data 网络请求数据 -- 原始数据
+(NSArray *)createModelWithSourceData:(NSDictionary *)data;

@end

NS_ASSUME_NONNULL_END
