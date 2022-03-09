//
//  HICStudyLogReportModel.m
//  HiClass
//
//  Created by WorkOffice on 2020/4/2.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICStudyLogReportModel.h"
@interface HICStudyLogReportModel()
@property (nonatomic ,assign)NSInteger reportType;

@end
@implementation HICStudyLogReportModel
- (instancetype)initWithType:(HICSerLogEventType)type
{
    self = [super init];
    if (self) {
        self.reportType = type;
        _customerid = [USER_CID toNumber];
        _subscriberid = @-1;
        _eventtime = [NSNumber numberWithInteger:[HICCommonUtils getNowTimeTimestampSS].integerValue];
        _logstamp = @139;
        _version = @"6.0";
        _os = @"iOS";
        _brand = @"Apple";
        _osversion = [[UIDevice currentDevice] systemVersion];
        _devicemsg = [[UIDevice currentDevice] model];
    }
    return self;
}

-(NSDictionary *)getParamDict {
    NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
    [mdic setValue:_customerid forKey:@"customerid"];
    [mdic setValue:_devicemsg forKey:@"devicemsg"];
    [mdic setValue:_subscriberid forKey:@"subscriberid"];
    [mdic setValue:_version forKey:@"version"];
    [mdic setValue:_logstamp forKey:@"logstamp"];
    [mdic setValue:_brand forKey:@"brand"];
    [mdic setValue:_os forKey:@"os"];
    [mdic setValue:_osversion forKey:@"osversion"];
    [mdic setValue:_eventtime forKey:@"eventtime"];
    
    
    
    if (self.reportType == HICStudyLogTypeStart || self.reportType == HICStudyLogTypeEnd ||self.reportType == HICStudyLogTypeTiming) {
        [mdic setValue:_mediaid forKey:@"mediaid"];
        [mdic setValue:_knowtype forKey:@"knowtype"];
        [mdic setValue:_courseid forKey:@"courseid"];
        [mdic setValue:_traincourseid forKey:@"traincourseid"];
        if (self.reportType == HICStudyLogTypeStart) {
               [mdic setValue:_videoquality forKey:@"videoquality"];
               [mdic setValue:_learnTime forKey:@"learnTime"];
           }else if (self.reportType == HICStudyLogTypeEnd){
               [mdic setValue:_duration forKey:@"duration"];
               [mdic setValue:_videoquality forKey:@"videoquality"];
               [mdic setValue:_learnTime forKey:@"learnTime"];
           }else{
               [mdic setValue:_credits forKey:@"credits"];
               [mdic setValue:_sectionId forKey:@"sectionId"];
               [mdic setValue:_startTime forKey:@"startTime"];
               [mdic setValue:_endTime forKey:@"endTime"];
               [mdic setValue:_learnTime forKey:@"learnTime"];
               [mdic setValue:_totalDuration forKey:@"totalDuration"];
               [mdic setValue:_kldCreditHours forKey:@"kldCreditHours"];
           }
    }
    if (self.reportType == HICPlayBackUpload) {
        [mdic setValue:_mediaid forKey:@"mediaid"];
    }
    if (self.reportType == HICPlayBackEnd) {
        [mdic setValue:_mediaid forKey:@"mediaid"];
        [mdic setValue:_duration forKey:@"duration"];
    }
    if (self.reportType == HICFirstSearch) {
        [mdic setValue:_mediaid forKey:@"mediaid"];
        [mdic setValue:_knowtype forKey:@"knowtype"];
        [mdic setValue:_mediatype forKey:@"mediatype"];
        [mdic setValue:_teacherid forKey:@"teacherid"];
    }
    
    if (self.reportType == HICFirstKnowledgeClick) {
        [mdic setValue:_mediaid forKey:@"mediaid"];
        [mdic setValue:_knowtype forKey:@"knowtype"];
        [mdic setValue:_mediatype forKey:@"mediatype"];
        [mdic setValue:_tabid forKey:@"tabid"];
    }
    if (self.reportType == HICFirstOtherTaskClick) {
        [mdic setValue:_mediaid forKey:@"mediaid"];
        [mdic setValue:_tasktype forKey:@"tasktype"];
        [mdic setValue:_taskstatus forKey:@"taskstatus"];
        [mdic setValue:_tabid forKey:@"tabid"];
    }
    if (self.reportType == HICFirstLectureClick) {
        [mdic setValue:_teacherid forKey:@"teacherid"];
        [mdic setValue:_tabid forKey:@"tabid"];
    }
    if (self.reportType == HICFirstTaskTypeClick) {
        [mdic setValue:_tasktype forKey:@"tasktype"];
        [mdic setValue:_tabid forKey:@"tabid"];
    }
    if (self.reportType == HICFirstAllKnowledge) {
        [mdic setValue:_tabid forKey:@"tabid"];
    }
    if (self.reportType == HICFirstRankClick) {
        [mdic setValue:_tabid forKey:@"tabid"];
    }
    
    if (self.reportType == HICTaskCenterTaskType) {
         [mdic setValue:_tasktype forKey:@"tasktype"];
    }
    if (self.reportType == HICTaskClick) {
        [mdic setValue:_mediaid forKey:@"mediaid"];
        [mdic setValue:_tasktype forKey:@"tasktype"];
        [mdic setValue:_taskstatus forKey:@"taskstatus"];
        [mdic setValue:_trainmode forKey:@"trainmode"];
        [mdic setValue:_tabid forKey:@"tabid"];
    }
    if (self.reportType == HICTaskTabClick) {
        [mdic setValue:_mediaid forKey:@"mediaid"];
               [mdic setValue:_tasktype forKey:@"tasktype"];
               [mdic setValue:_trainmode forKey:@"trainmode"];
               [mdic setValue:_tab forKey:@"tab"];
    }
    if (self.reportType == HICScanJumpClick) {
        [mdic setValue:_mediaid forKey:@"mediaid"];
        [mdic setValue:_tasktype forKey:@"tasktype"];
    }
    
    if (self.reportType == HICTrainOnlineKnowledgeClick) {
        [mdic setValue:_mediaid forKey:@"mediaid"];
        [mdic setValue:_mediatype forKey:@"mediatype"];
        [mdic setValue:_knowtype forKey:@"knowtype"];
        [mdic setValue:_traincourseid forKey:@"traincourseid"];
    }
    if (self.reportType == HICCourseDetailClick) {
        [mdic setValue:_mediaid forKey:@"mediaid"];
        [mdic setValue:_buttonname forKey:@"buttonname"];
        [mdic setValue:_knowtype forKey:@"knowtype"];
        [mdic setValue:_mediatype forKey:@"mediatype"];
    }
    if (self.reportType == HICCourseIndexClickKnowledge) {
        [mdic setValue:_mediaid forKey:@"mediaid"];
        [mdic setValue:_knowtype forKey:@"knowtype"];
        [mdic setValue:_courseid forKey:@"courseid"];
    }
    if (self.reportType == HICCourseIndexClickTask) {
        [mdic setValue:_mediaid forKey:@"mediaid"];
        [mdic setValue:_courseid forKey:@"courseid"];
        [mdic setValue:_taskstatus forKey:@"taskstatus"];
        [mdic setValue:_tasktype forKey:@"tasktype"];
    }
    
    if (self.reportType == HICRecommendClick) {
        [mdic setValue:_mediaid forKey:@"mediaid"];
               [mdic setValue:_knowtype forKey:@"knowtype"];
               [mdic setValue:_mediatype forKey:@"mediatype"];
    }
    
    if (self.reportType == HICExamClick) {
        [mdic setValue:_mediaid forKey:@"mediaid"];
    }
    if (self.reportType == HICExamFinishedOne) {
        [mdic setValue:_mediaid forKey:@"mediaid"];
    }
    
    if (self.reportType == HICLectureClick) {
        [mdic setValue:_mediaid forKey:@"mediaid"];
        [mdic setValue:_knowtype forKey:@"knowtype"];
        [mdic setValue:_mediatype forKey:@"mediatype"];
        [mdic setValue:_teacherid forKey:@"teacherid"];
    }
    if (self.reportType == HICLectureOfflineCourseClick) {
        [mdic setValue:_mediaid forKey:@"mediaid"];
        [mdic setValue:_teacherid forKey:@"teacherid"];
    }
    
    if (self.reportType == HICPosKnowledgeClick) {
        [mdic setValue:_mediaid forKey:@"mediaid"];
        [mdic setValue:_knowtype forKey:@"knowtype"];
        [mdic setValue:_mediatype forKey:@"mediatype"];
    }
    if (self.reportType == HICPosTaskClick) {
        [mdic setValue:_mediaid forKey:@"mediaid"];
               [mdic setValue:_taskstatus forKey:@"taskstatus"];
               [mdic setValue:_tasktype forKey:@"tasktype"];
    }
    
    if (self.reportType == HICAllKnowledgeClick ) {
        [mdic setValue:_mediaid forKey:@"mediaid"];
        [mdic setValue:_knowtype forKey:@"knowtype"];
        [mdic setValue:_mediatype forKey:@"mediatype"];
    }
    
    if (self.reportType == HICNotiClick) {
       [mdic setValue:_mediaid forKey:@"mediaid"];
        [mdic setValue:_tasktype forKey:@"tasktype"];
        [mdic setValue:_notifytype forKey:@"notifytype"];
        [mdic setValue:_notifymode forKey:@"notifymode"];
    }
    
    if (self.reportType == HICTrainOnlineTaskClick) {
        [mdic setValue:_tasktype forKey:@"tasktype"];
        [mdic setValue:_traincourseid forKey:@"traincourseid"];
        [mdic setValue:_taskstatus forKey:@"taskstatus"];
        [mdic setValue:_mediaid forKey:@"mediaid"];
    }
    if (self.reportType == HICMyRecordClickToKnowledge ||self.reportType == HICMyCollectToKnowledge ||self.reportType == HICMyNoteToKnowledge || self.reportType == HICMyCommentToKnowledge|| self.reportType == HICMyDownloadToKnowledge || self.reportType == HICStudyExplosion) {
        [mdic setValue:_mediaid forKey:@"mediaid"];
        [mdic setValue:_knowtype forKey:@"knowtype"];
        [mdic setValue:_mediatype forKey:@"mediatype"];
    }

    
    return [mdic copy];
}

@end
