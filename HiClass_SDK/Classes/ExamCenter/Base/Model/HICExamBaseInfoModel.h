//
//  HICExamBaseInfoModel.h
//  HiClass
//
//  Created by WorkOffice on 2020/2/19.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HICExamBaseInfoModel : NSObject
/// 考试名
@property(nonatomic, strong) NSString *name;
/// 考试ID
@property(nonatomic, strong) NSNumber *examID;
/// 状态 integer,考试状态 0-待考试，1-进行中，2-批阅中，3-已完成，4-缺考
@property(nonatomic, assign) NSInteger status;
///考试安排状态 "examStatus":"integer,考试安排状态，0-未发布、1-进行中、2-已结束、3-已归档",
@property(nonatomic, assign) NSInteger examStatus;
/// 总分数
@property(nonatomic, assign) CGFloat score;
/// 通过分数
@property(nonatomic, assign) CGFloat passScroe;
/// 考题数
@property(nonatomic, assign) NSInteger questionNum;
/// 考试说明
@property(nonatomic, strong) NSString *desc;
/// 考试标签：补考、重要
@property(nonatomic, strong) NSString *tags;
@property (nonatomic, assign) NSInteger importantFlag;
/// 考试指派人
@property(nonatomic, strong) NSString *assignor;
/// 考试安排时间，秒级时间戳
@property(nonatomic, strong) NSNumber *assignTime;
/// 已参加考试次数
@property(nonatomic, assign) NSInteger times;
@end

NS_ASSUME_NONNULL_END
