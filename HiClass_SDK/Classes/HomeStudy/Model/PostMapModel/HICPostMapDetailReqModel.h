//
//  HICPostMapDetailReqModel.h
//  HiClass
//
//  Created by Sir_Jing on 2020/3/19.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 岗位地图证书模型
@interface HICPostMapCerModel : NSObject

/// 证书id
@property (nonatomic, assign) NSInteger cerId;
/// 证书名称
@property (nonatomic, copy) NSString * name;
/// 人员证书id（已获得的才有，未获得的为0）
@property (nonatomic, assign) NSInteger employeeCertId;
/// 证书url
@property (nonatomic, copy) NSString * url;
/// 当前用户是否已获得此证书: 0-未获得，1-已获得
@property (nonatomic, assign) NSInteger acquired;

/// 获取服务器返回数据转换成模型数组
/// @param dic 返回数据
+(NSArray *)getModelArrayWithRep:(NSDictionary *)dic;

@end

@interface HICPostMapDetailReqModel : NSObject

/// 岗位职责
@property (nonatomic, copy) NSString * duty;

/// 任职要求
@property (nonatomic, copy) NSString * demand;

/// 自主学习学分
@property (nonatomic, assign) double  selfStudyCredit;

/// 已获自主学习学分
@property (nonatomic, assign) double  mySelfStudyCredit;

/// 指派学习学分
@property (nonatomic, assign) double  assignStudyCredit;

/// 指派学习学分
@property (nonatomic, assign) double  myAssignStudyCredit;

/// 学习方案对应的培训id
@property (nonatomic, assign) NSInteger  trainId;


@end

NS_ASSUME_NONNULL_END
