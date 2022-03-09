//
//  HICExamRecordModel.h
//  HiClass
//
//  Created by Eddie Ma on 2020/1/21.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HICExamRecordModel : NSObject

/// 考试记录ID
@property(nonatomic, strong) NSNumber *examRecordID;

/// 交卷时间，秒级时间戳
@property(nonatomic, strong) NSNumber *submitTime;

/// 考试状态，参考考试信息查询接口定义
@property(nonatomic, assign) NSInteger status;

/// 得分
@property(nonatomic, assign) CGFloat score;

/// 是否通过，0-未通过  1-通过
@property(nonatomic, assign) NSInteger passedFlag;

/// 正确率，终端增加%即可
@property(nonatomic, assign) CGFloat correctRate;

/// 考试时长，单位秒
@property(nonatomic, strong) NSNumber *duration;

/// 批阅时间
@property(nonatomic, strong) NSNumber *reviewTime;

/// 重复次数（第几次考试）
@property(nonatomic, assign) NSInteger examNumber;

/// 交卷类型  0-主动交卷  1-强制交卷
@property(nonatomic, assign) NSInteger submitType;

@end

NS_ASSUME_NONNULL_END
