//
//  HICTestModel.h
//  HiClass
//
//  Created by Eddie Ma on 2020/1/19.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HICTestModel : NSObject

/** 考试名  */
@property(nonatomic, strong) NSNumber * needShowSection;
/** 级别  */
@property(nonatomic, strong) NSNumber * assignTime;
/** 考试ID  */
@property(nonatomic, strong) NSString * startLable;
/** 试卷ID  */
@property(nonatomic, strong) NSString * start;
/** 状态 integer,考试状态 0-待考试，1-进行中，2-批阅中，3-已完成，4-缺考 */
@property(nonatomic, strong) NSString * name;
/** 创建人  */
@property(nonatomic, strong) NSString * examTime;
/** 总分数  */
@property(nonatomic, strong) NSString * examDuration;
@property(nonatomic, strong) NSString * score;
/** 通过分数  */
@property(nonatomic, strong) NSString * passScore;
/** 考题数  */
@property(nonatomic, strong) NSString * examTimes;
/** 统一交卷时间  */
@property(nonatomic, strong) NSString * examer;
/// 考试重要程度 重要 、可用考试次数 、考试总次数、考试时间、考试分数
/** 考试说明  */
@property(nonatomic, strong) NSArray * grade;

@property(nonatomic, strong) NSString * tag;


- (instancetype)initWithDic:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
