//
//  HICStudyLogReportModel.h
//  HiClass
//
//  Created by WorkOffice on 2020/4/2.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HICStudyLogReportModel : NSObject
@property (nonatomic ,strong)NSNumber *subscriberid;
@property (nonatomic ,strong)NSNumber *customerid;
@property (nonatomic ,strong)NSString *version;
@property (nonatomic ,strong)NSNumber *logstamp;
@property (nonatomic ,strong)NSString *brand;
@property (nonatomic ,strong)NSString *os;
@property (nonatomic ,strong)NSString *osversion;
@property (nonatomic ,strong)NSString *devicemsg;
@property (nonatomic ,strong)NSNumber *eventtime;

@property (nonatomic ,strong)NSNumber *mediaid;
@property (nonatomic ,strong)NSNumber *knowtype;
@property (nonatomic ,strong)NSNumber *courseid;
@property (nonatomic ,strong)NSNumber *videoquality;
@property (nonatomic ,strong)NSNumber *traincourseid;
@property (nonatomic ,strong)NSNumber *duration;
@property (nonatomic ,strong)NSNumber *credits;
@property (nonatomic ,strong)NSNumber *sectionId;
@property (nonatomic ,strong)NSNumber *startTime;
@property (nonatomic ,strong)NSNumber *endTime;
@property (nonatomic ,strong)NSNumber *learnTime;
@property (nonatomic ,strong)NSNumber *totalDuration;
@property (nonatomic ,strong)NSNumber *kldCreditHours;


@property(nonatomic ,strong)NSNumber *mediatype;
@property (nonatomic ,strong)NSNumber *tabid;
@property (nonatomic ,strong)NSNumber *tasktype;
@property (nonatomic ,strong)NSString *taskstatus;
@property (nonatomic ,strong)NSNumber *teacherid;
@property (nonatomic ,strong)NSNumber *trainmode;
@property (nonatomic ,strong)NSString *tab;
@property (nonatomic ,strong)NSString *buttonname;
@property (nonatomic ,strong)NSNumber *notifytype;
@property (nonatomic ,strong)NSNumber *notifymode;

- (instancetype)initWithType:(HICSerLogEventType)type;
-(NSDictionary *)getParamDict;
@end

NS_ASSUME_NONNULL_END
