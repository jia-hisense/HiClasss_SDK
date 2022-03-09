//
//  HICMyBaseInfoModel.h
//  HiClass
//
//  Created by WorkOffice on 2020/3/16.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HICMyBaseInfoModel : NSObject
/**
 
 "id":"long,员工ID",
 "customerId":"long,账号ID",
 "name":"string,员工名称",
 "uid":"string,OA账号",
 "employeeNumber":"string,员工工号",
 "headPic":"string,头像url，空时终端使用本地默认图",
 "department":{
     "id":"long,部门id",
     "name":"string,部门名称"
 },
 "sex":"string,性别,1-男，0-女",
 "birthday":"string,生日，yyyy-MM-dd",
 "classPositions":{
     "id":"long,职级ID",
     "name":"string,职级名称"
 },
 "entryTime":"string,入职时间，yyyy-MM-dd",
 "creditHours":"long,年度学时",
 "credit":"long,年度学分",
 "points":"long,年度积分"
 "post": "string,岗位信息"
 */

@property (nonatomic ,strong)NSNumber *workerId;
@property (nonatomic ,strong)NSNumber *customerId;
@property (nonatomic ,strong)NSString *name;
@property (nonatomic ,strong)NSString *uid;
@property (nonatomic ,strong)NSString *employeeNumber;
@property (nonatomic ,strong)NSString *headPic;
@property (nonatomic ,strong)NSString *sex;
@property (nonatomic ,strong)NSString *birthday;
@property (nonatomic ,strong)NSString *entryTime;
@property (nonatomic ,strong)NSString *credit;
@property (nonatomic ,strong)NSString *creditHours;
@property (nonatomic ,strong)NSString *points;
@property (nonatomic ,strong)NSString *department;
@property (nonatomic ,strong)NSString *classPositions;
@property (nonatomic ,strong)NSString *post;
@end

NS_ASSUME_NONNULL_END
