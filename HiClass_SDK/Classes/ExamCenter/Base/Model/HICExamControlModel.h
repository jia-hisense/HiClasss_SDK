//
//  HICExamControlModel.h
//  HiClass
//
//  Created by WorkOffice on 2020/2/19.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HICExamControlModel : NSObject
/// integer,统一考试时长，单位分钟，0表示不限制
@property(nonatomic, assign) NSInteger  examDuration;
/// long,考试允许进入开始时间，0表示 不限时
@property(nonatomic, strong) NSNumber *joinStartTime;
/// long,考试允许进入结束时间，0表示不限时
@property(nonatomic, strong) NSNumber *joinEndTime;
/// long,强制交卷时间，0表示不限制
@property(nonatomic, strong) NSNumber *forceCommitTime;
/// integer,允许参加考试次数上限，0表示不限制
@property(nonatomic, assign) NSInteger  allowTimes;
/// string,主观题上传附件答题控制
@property(nonatomic, strong) NSString * allowAttach;
/// integer,考试中允许查看解析，  0-否  1-是
@property(nonatomic, assign) NSInteger  allowShowAnalysis;
/// integer,允许移动端参加考试,0-否，1-允许APP参加但不开启人脸识别，2-允许APP并开启人脸识别，3-允许H5参加，4-允许APP和H5参加但不开启人脸识别，5-允许APP和H5参加且开启人脸识别
@property(nonatomic, assign) NSInteger  allowMobile;
/// integer,允许pc参加考试，0-否，1-是，默认1
@property(nonatomic, assign) NSInteger  allowPC;
/// integer,人脸识别自拍间隔，单位分钟  （allowMobile为2和5时生效）
@property(nonatomic, assign) NSInteger  faceRecognitionIntervel;
/// integer,考试允许切屏次数，0标识不允许
@property(nonatomic, assign) NSInteger  switchScreenNum;
/// string,切屏目的，switchScreenNum>0时生效; (规则：{\\\"gobackFlag\\\":0, \\\"phoneFlag\\\":1, \\\"noticeBarFlag\\\":1, \"             + \"\\\"switchAppFlag\\\":1, \\\"homeBackRunFlag\\\":0}
@property(nonatomic, strong) NSString * switchScreenObjective;
/// integer,n分钟未操作自动交卷，0表示不限制； 单位分钟
@property(nonatomic, assign) NSInteger  autoCommitDuration;
/// integer,考试允许更换设备，0-不允许  1-允许
@property(nonatomic, assign) NSInteger  replaceDevice;
/// 考试ip白名单,多个以英文逗号隔开（10.18.*,10.19.100.*,10.20.100.2）
@property(nonatomic, strong) NSString * allowIP;
/// integer,批阅后允许考生查看成绩，0-不允许，1-显示分数，2-显示是否通过，3-都显示
@property(nonatomic, assign)NSInteger allowViewScore  ;
/// integer,批阅后允许查看详情，0-不允许，1-可查看答案，2-可查看解析，3-都可以查看
@property(nonatomic, assign) NSInteger allowViewDetail  ;
/// long,允许查看详情开始时间
@property(nonatomic, strong) NSString *viewDetailStartTime ;
/// long,允许查看详情结束时间
@property(nonatomic, strong) NSString *viewDetailEndTime ;
/// integer,考题是否随机，0-否  1-是
@property(nonatomic, assign) NSInteger questionOrderRandom;
/// integer,考题选项是否随机，0-否  1-是
@property(nonatomic, assign) NSInteger optionOrderRandom;
//@property (nonatomic,assign) NSInteger blankAuto;
@end

NS_ASSUME_NONNULL_END
