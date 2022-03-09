//
//  HICUserDetailModel.h
//  HiClass
//
//  Created by Sir_Jing on 2020/3/21.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HICUserDetailModel : NSObject

/// ID 员工ID
@property (nonatomic, assign) NSInteger  userId;

/// customerId
@property (nonatomic, copy) NSString * customerId;

/// 姓名
@property (nonatomic, copy) NSString * name;

/// 部门编码
@property (nonatomic, copy) NSString * deptNumber;

/// 手机号码
@property (nonatomic, copy) NSString * mobile;

/// 员工编码
@property (nonatomic, copy) NSString * employeeNumber;

/// 邮箱
@property (nonatomic, copy) NSString * mail;

/// 工作电话
@property (nonatomic, copy) NSString * telephoneNumber;

/// 性别0，女，1，男
@property (nonatomic, copy) NSString * gender;

/// 身份证号码
@property (nonatomic, copy) NSString * idNumber;

/// 生日2000-03-03
@property (nonatomic, copy) NSString * birthday;

/// 入职时间2000-03-03
@property (nonatomic, copy) NSString * entryTime;

/// 有效时间
@property (nonatomic, assign) NSInteger expiredTime;

/// 毕业院校
@property (nonatomic, copy) NSString * school;

/// 学历
@property (nonatomic, copy) NSString * education;

/// 账户类型，0，ldap抓取，1，创建
@property (nonatomic, copy) NSString * accountType;

/// 直属经理编号
@property (nonatomic, copy) NSString * directManagerId;

/// 导师编号
@property (nonatomic, copy) NSString * mentorId;

/// 0，启用，1，锁定，2，禁用
@property (nonatomic, copy) NSString * lockFlag;

/// 学时
@property (nonatomic, copy) NSString * creditHours;

/// 学分
@property (nonatomic, copy) NSString * credit;

/// 积分
@property (nonatomic, copy) NSString * points;

/// 角色列表 里边为NSDictionary {@"id":角色ID, @"name":角色名称，@"code":角色编码}
@property (nonatomic, strong) NSArray * roleList;

/// 职级列表 里边为NSDictionary {@"id":职级ID，@"name":职级名称}
@property (nonatomic, strong) NSArray * titleLevelList;

/// 用户组 里边为NSDictionary {@"id":用户组ID，@"name":用户组名称}
@property (nonatomic, strong) NSArray * userGroupList;

/// 入海信时学历
@property (nonatomic, copy) NSString * entryEducation;

/// 外语水平
@property (nonatomic, copy) NSString * englishLevel;

/// 外语分数
@property (nonatomic, copy) NSString * englishScore;

/// 员工类型代码
@property (nonatomic, copy) NSString * employeeTypeNumber;

/// 员工类型名称
@property (nonatomic, copy) NSString * employeeTypeName;

/// 开始工作时间
@property (nonatomic, copy) NSString * startWorkDate;

/// 所在部门
@property (nonatomic, copy) NSString * deptTree;

/// 工作经历
@property (nonatomic, copy) NSString * workHistory;

/// sap部门
@property (nonatomic, copy) NSString * sapDepartment;

/// sap岗位
@property (nonatomic, copy) NSString * sapPost;

/// sap职位任职时间
@property (nonatomic, copy) NSString * sapTitleLevelStartTime;

/// sap一级序列代码
@property (nonatomic, copy) NSString * sapFirstOrderSequenceCode;

/// sap一级序列名称
@property (nonatomic, copy) NSString * sapFirstOrderSequenceName;

/// sap二级序列代码
@property (nonatomic, copy) NSString * sapSecondOrderSequenceCode;

/// sap二级序列名称
@property (nonatomic, copy) NSString * sapSecondOrderSequenceName;

/// sap人事子范围代码
@property (nonatomic, copy) NSString * sapPersonnelSubscopeCode;

/// sap人事子范围名称
@property (nonatomic, copy) NSString * sapPersonnelSubscopeName;

/// sap非操作类职衔
@property (nonatomic, copy) NSString * sapNonOperationalTitle;

/// sap操作类职衔
@property (nonatomic, copy) NSString * sapOperationalTitle;

/// sap层级
@property (nonatomic, copy) NSString * sapDir;

/// sap专业层级
@property (nonatomic, copy) NSString * sapProfessionalDir;

/// sap内部职称
@property (nonatomic, copy) NSString * sapInternalTitle;

/// sap外部职称
@property (nonatomic, copy) NSString * sapOutsideTitle;

/// sap工号
@property (nonatomic, copy) NSString * sapCustomerId;

/// 部门名称
@property (nonatomic, copy) NSString * deptName;

/// 岗位 里边为NSDictionary {@"id":岗位ID，@"name":岗位名称}
@property (nonatomic, strong) NSArray * postList;

/// 直属经理姓名
@property (nonatomic, copy) NSString * directManagerName;

/// 导师姓名
@property (nonatomic, copy) NSString * mentorName;

/// 更新时间
@property (nonatomic, assign) NSInteger uptateTime;

/// 返回数据权限 里边两个数组 1:users:人员权限部门列表 -->@{@"deptName":人员权限部门名称, @"deptNumber":人员权限部门number}; 2:resources:资源权限部门列表 --> @{@"deptName":资源权限部门名称, @"deptNumber":资源权限部门number}
@property (nonatomic, strong) NSDictionary * auth;

/// sap工号
@property (nonatomic, copy) NSString * sapNumber;

/// 专业
@property (nonatomic, copy) NSString * major;

/// sap职位
@property (nonatomic, copy) NSString * sapTitleLevel;

/// 自治组织编码
@property (nonatomic, copy) NSString * autonomousOrgCode;


/// 创建含有此模型的方法 -- 用户详情
/// @param data 网络请求数据 -- 原始数据
+(instancetype)createModelWithSourceData:(NSDictionary *)data;


/// 获取数据的角色的ID
-(NSString *)getRoleIdStr;

@end


NS_ASSUME_NONNULL_END
