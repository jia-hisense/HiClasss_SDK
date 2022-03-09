//
//  HICLogManager.m
//  HiClass
//
//  Created by Eddie Ma on 2020/1/15.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICLogManager.h"
#import <iOS_LogReport_CPN/iOS_LogReport_CPN-umbrella.h>

@interface HICLogManager () <NSObject>

@property (nonatomic, strong) JLogSDKManager *reportManager;

@end

@implementation HICLogManager

+ (instancetype)shared {
    static HICLogManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (instancetype)init {
    if (self = [super init]) {
        self.reportManager = [[JLogSDKManager alloc] initWithDeviceId:SystemManager.deviceID appKey:SystemManager.appKey strUrlType:JLOGSDK_STRURL_CUSTOM_TYPE customUrl:[NSString stringWithFormat:@"%@/log/get_dotexception_strategy",APP_GPS_DOMAIN]];
    }
    return self;
}

#pragma mark --- 异常日志上报 --- start
- (void)reportExcLogWithDict:(NSDictionary *)dict {
    NSDictionary *logDict = [self mergeExcBasedDic:dict];
    [JLogSDKManager reportLogWithDict:logDict];
}

- (NSDictionary *)mergeExcBasedDic:(NSDictionary *)params {
    NSMutableDictionary *dict = (NSMutableDictionary *)params;
    [dict setValue:SystemManager.deviceID forKey:@"deviceid"];
    [dict setValue:@"-1" forKey:@"mac"];
    [dict setValue:SystemManager.appKey forKey:@"appkey"];
    [dict setValue:SystemManager.appVersion forKey:@"appversion"];
    [dict setValue:@"iOS" forKey:@"devicetype"];
    [dict setValue:@"-1" forKey:@"extramessage"];
    [dict setValue:[[UIDevice currentDevice] systemVersion] forKey:@"osversion"];
    [dict setValue:[[UIDevice currentDevice] model] forKey:@"devicemsg"];
    [dict setValue:@"Apple" forKey:@"brand"];
    [dict setValue:@"iOS" forKey:@"os"];
    [dict setValue:[self getAppName] forKey:@"appname"];
    return dict;
}

- (NSDictionary *)getExcLogEventDictWithType:(HICExcLogEventType)type {
    NSMutableDictionary *eventDict = [[NSMutableDictionary alloc] init];
    switch (type) {
            // 应用异常退出
        case HIC_EXCLOG_APP_TERMINATION: {
            [eventDict setValue:@"099199" forKey:@"eventcode"];
            [eventDict setValue:@"199" forKey:@"eventPos"];
            [eventDict setValue:@"099" forKey:@"eventType"];
            break;
        }
        case HIC_EXCLOG_API_FAILED: {
            [eventDict setValue:@"099198" forKey:@"eventcode"];
            [eventDict setValue:@"198" forKey:@"eventPos"];
            [eventDict setValue:@"099" forKey:@"eventType"];
            break;
        }
        default:
            break;
    }
    return eventDict;
}
#pragma mark --- 异常日志上报 --- end

#pragma mark --- 打点日志上报 --- start
- (void)reportDotLogWithDict:(NSDictionary *)dict {
    NSDictionary *logDict = [self mergeDotBasedDic:dict];
    [JLogSDKManager reportLogWithDict:logDict];
}

- (NSDictionary *)mergeDotBasedDic:(NSDictionary *)params {
    NSMutableDictionary *dict = (NSMutableDictionary *)params;
    [dict setValue:SystemManager.deviceID forKey:@"deviceid"];
    return dict;
}

- (NSDictionary *)getDotLogEventDictWithType:(HICDotLogEventType)type {
    return @{};
}
#pragma mark --- 打点日志上报 --- end
#pragma mark ---App启动上报---start
- (void)reportAppStart {
    NSDictionary *dict = [self getAppEventDictWithType:HIC_APP_START];
    NSDictionary *logDict = [self mergeAppStartBasedDic:dict];
    [JLogSDKManager reportLogWithDict:logDict];
}
- (NSDictionary *)mergeAppStartBasedDic:(NSDictionary *)params {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:params];
    [dict setValue:USER_CID ?: @"0" forKey:@"customerid"];
    [dict setValue:SystemManager.deviceID forKey:@"deviceid"];
    [dict setValue:SystemManager.macAddress forKey:@"mac"];
    [dict setValue:SystemManager.appKey forKey:@"appkey"];
    [dict setValue:SystemManager.appVersion forKey:@"appversion"];
    [dict setValue:@"iOS" forKey:@"devicetype"];
    [dict setValue:@"-1" forKey:@"extramessage"];
    [dict setValue:[UIDevice currentDevice].model forKey:@"devicemsg"];
    [dict setValue:@"Apple" forKey:@"brand"];
    [dict setValue:[UIDevice currentDevice].systemName forKey:@"os"];
    [dict setValue:[self getAppName] forKey:@"appname"];
    return dict;
}
- (NSDictionary *)getAppEventDictWithType:(HICAppLogEventType)type {
    NSMutableDictionary *eventDict = [[NSMutableDictionary alloc] init];
    switch (type) {
        case HIC_APP_START:{
            [eventDict setValue:@"200000" forKey:@"eventcode"];
            [eventDict setValue:@"000" forKey:@"eventPos"];
            [eventDict setValue:@"200" forKey:@"eventType"];
            break;
        }
        default:
            break;
    }
    return eventDict;
}
#pragma mark ---App启动上报---end
#pragma mark --- 业务日志上报 --- start
- (void)reportSerLogWithType:(HICSerLogEventType)type params:(NSDictionary *__nullable)params {
    NSMutableDictionary *logDict = params ? [NSMutableDictionary dictionaryWithDictionary:params] : [NSMutableDictionary dictionary];
    [logDict addEntriesFromDictionary:[self getSerLogEventDictWithType:type]];
    NSDictionary *reportDict = [self mergeSerBasedDic:logDict];
    [JLogSDKManager reportLogWithDict:reportDict];
    DDLogDebug(@"业务日志上报:%@", [self mergeSerBasedDic:reportDict]);
}

- (void)reportSerLogWithDict:(NSDictionary *)dict {
    NSDictionary *logDict = [self mergeSerBasedDic:dict];
    DDLogDebug(@"业务日志上报:%@", logDict);
    [JLogSDKManager reportLogWithDict:logDict];
}

- (NSMutableDictionary *)mergeSerBasedDic:(NSDictionary *)params {
    NSMutableDictionary *dict = (NSMutableDictionary *)params;
    [dict setValue:SystemManager.deviceID forKey:@"deviceid"];
    [dict setValue:@"-1" forKey:@"mac"];
    [dict setValue:SystemManager.appKey forKey:@"appkey"];
    [dict setValue:SystemManager.appVersion forKey:@"appversion"];
    [dict setValue:@"iOS" forKey:@"devicetype"];
    [dict setValue:@"-1" forKey:@"extramessage"];
    [dict setValue:[self getAppName] forKey:@"appname"];
    [dict setValue:@"6.0" forKey:@"version"];
    [dict setValue:@139 forKey:@"logstamp"];
    return dict;
}

- (NSDictionary *)getSerLogEventDictWithType:(HICSerLogEventType)type {
    NSMutableDictionary *eventDict = [[NSMutableDictionary alloc] init];
    switch (type) {
        case HICStudyExplosion: {
            [eventDict setValue:@"200001" forKey:@"eventcode"];
            [eventDict setValue:@"001" forKey:@"eventPos"];
            [eventDict setValue:@"200" forKey:@"eventType"];
            break;
        }
        case HICStudyLogTypeStart: {
            [eventDict setValue:@"210008" forKey:@"eventcode"];
            [eventDict setValue:@"008" forKey:@"eventPos"];
            [eventDict setValue:@"210" forKey:@"eventType"];
            break;
        }
        case HICStudyLogTypeTiming: {
            [eventDict setValue:@"210010" forKey:@"eventcode"];
            [eventDict setValue:@"010" forKey:@"eventPos"];
            [eventDict setValue:@"210" forKey:@"eventType"];
            break;
        }
        case HICStudyLogTypeEnd: {
            [eventDict setValue:@"210009" forKey:@"eventcode"];
            [eventDict setValue:@"009" forKey:@"eventPos"];
            [eventDict setValue:@"210" forKey:@"eventType"];
            break;
        }
            // 应用异常退出
        case HICFirstSearch: {
            [eventDict setValue:@"201000" forKey:@"eventcode"];
            [eventDict setValue:@"000" forKey:@"eventPos"];
            [eventDict setValue:@"201" forKey:@"eventType"];
            break;
        }
        case HICFirstScan: {
            [eventDict setValue:@"201001" forKey:@"eventcode"];
            [eventDict setValue:@"001" forKey:@"eventPos"];
            [eventDict setValue:@"201" forKey:@"eventType"];
            break;
        }
        case HICFirstKnowledgeClick: {
            [eventDict setValue:@"201002" forKey:@"eventcode"];
            [eventDict setValue:@"002" forKey:@"eventPos"];
            [eventDict setValue:@"201" forKey:@"eventType"];
            break;
        }
            ///首页上报
        case HICFirstOtherTaskClick: {
            [eventDict setValue:@"201003" forKey:@"eventcode"];
            [eventDict setValue:@"003" forKey:@"eventPos"];
            [eventDict setValue:@"201" forKey:@"eventType"];
            break;
        }
        case HICFirstLectureClick: {
            [eventDict setValue:@"201004" forKey:@"eventcode"];
            [eventDict setValue:@"004" forKey:@"eventPos"];
            [eventDict setValue:@"201" forKey:@"eventType"];
            break;
        }
        case HICFirstTaskTypeClick: {
            [eventDict setValue:@"201005" forKey:@"eventcode"];
            [eventDict setValue:@"005" forKey:@"eventPos"];
            [eventDict setValue:@"201" forKey:@"eventType"];
            break;
        }
        case HICFirstAllKnowledge: {
            [eventDict setValue:@"201007" forKey:@"eventcode"];
            [eventDict setValue:@"007" forKey:@"eventPos"];
            [eventDict setValue:@"201" forKey:@"eventType"];
            break;
        }
        case HICFirstRankClick: {
            [eventDict setValue:@"201008" forKey:@"eventcode"];
            [eventDict setValue:@"007" forKey:@"eventPos"];
            [eventDict setValue:@"201" forKey:@"eventType"];
            break;
        }
            ///任务中心
        case HICTaskCenterTaskType: {
            [eventDict setValue:@"203001" forKey:@"eventcode"];
            [eventDict setValue:@"001" forKey:@"eventPos"];
            [eventDict setValue:@"203" forKey:@"eventType"];
            break;
        }
        case HICTaskClick: {
            [eventDict setValue:@"203002" forKey:@"eventcode"];
            [eventDict setValue:@"002" forKey:@"eventPos"];
            [eventDict setValue:@"203" forKey:@"eventType"];
            break;
        }
        case HICTaskTabClick: {
            [eventDict setValue:@"203004" forKey:@"eventcode"];
            [eventDict setValue:@"004" forKey:@"eventPos"];
            [eventDict setValue:@"203" forKey:@"eventType"];
            break;
        }
            //扫码
        case HICScanJumpClick: {
            [eventDict setValue:@"205000" forKey:@"eventcode"];
            [eventDict setValue:@"000" forKey:@"eventPos"];
            [eventDict setValue:@"205" forKey:@"eventType"];
            break;
        }
            ///培训
        case HICTrainOnlineKnowledgeClick: {
            [eventDict setValue:@"206000" forKey:@"eventcode"];
            [eventDict setValue:@"000" forKey:@"eventPos"];
            [eventDict setValue:@"206" forKey:@"eventType"];
            break;
        }
        case HICTrainOnlineTaskClick: {
            [eventDict setValue:@"206001" forKey:@"eventcode"];
            [eventDict setValue:@"001" forKey:@"eventPos"];
            [eventDict setValue:@"206" forKey:@"eventType"];
            break;
        }
            ///课程
        case HICCourseDetailClick: {
            [eventDict setValue:@"210001" forKey:@"eventcode"];
            [eventDict setValue:@"001" forKey:@"eventPos"];
            [eventDict setValue:@"210" forKey:@"eventType"];
            break;
        }
        case HICCourseIndexClickKnowledge: {
            [eventDict setValue:@"210003" forKey:@"eventcode"];
            [eventDict setValue:@"003" forKey:@"eventPos"];
            [eventDict setValue:@"210" forKey:@"eventType"];
            break;
        }
        case HICCourseIndexClickTask: {
            [eventDict setValue:@"210004" forKey:@"eventcode"];
            [eventDict setValue:@"004" forKey:@"eventPos"];
            [eventDict setValue:@"210" forKey:@"eventType"];
            break;
        }
            
        case HICRecommendClick: {
            [eventDict setValue:@"210005" forKey:@"eventcode"];
            [eventDict setValue:@"005" forKey:@"eventPos"];
            [eventDict setValue:@"210" forKey:@"eventType"];
            break;
        }
        case HICExamClick: {
            [eventDict setValue:@"210007" forKey:@"eventcode"];
            [eventDict setValue:@"007" forKey:@"eventPos"];
            [eventDict setValue:@"210" forKey:@"eventType"];
            break;
        }
        case HICExamFinishedOne: {
            [eventDict setValue:@"210012" forKey:@"eventcode"];
            [eventDict setValue:@"012" forKey:@"eventPos"];
            [eventDict setValue:@"210" forKey:@"eventType"];
            break;
        }
            //讲师
        case HICLectureClick: {
            [eventDict setValue:@"220000" forKey:@"eventcode"];
            [eventDict setValue:@"000" forKey:@"eventPos"];
            [eventDict setValue:@"220" forKey:@"eventType"];
            break;
        }
        case HICLectureOfflineCourseClick: {
            [eventDict setValue:@"220002" forKey:@"eventcode"];
            [eventDict setValue:@"002" forKey:@"eventPos"];
            [eventDict setValue:@"220" forKey:@"eventType"];
            break;
        }
            //岗位
        case HICPosKnowledgeClick: {
            [eventDict setValue:@"230000" forKey:@"eventcode"];
            [eventDict setValue:@"000" forKey:@"eventPos"];
            [eventDict setValue:@"230" forKey:@"eventType"];
            break;
        }
        case HICPosTaskClick: {
            [eventDict setValue:@"230001" forKey:@"eventcode"];
            [eventDict setValue:@"001" forKey:@"eventPos"];
            [eventDict setValue:@"230" forKey:@"eventType"];
            break;
        }
        case HICAllKnowledgeClick: {
            [eventDict setValue:@"240000" forKey:@"eventcode"];
            [eventDict setValue:@"000" forKey:@"eventPos"];
            [eventDict setValue:@"240" forKey:@"eventType"];
            break;
        }
            ///通知
        case HICNotiClick: {
            [eventDict setValue:@"260000" forKey:@"eventcode"];
            [eventDict setValue:@"000" forKey:@"eventPos"];
            [eventDict setValue:@"260" forKey:@"eventType"];
            break;
        }
        case HICNotiCommentClickToKnowledge: {
            [eventDict setValue:@"260002" forKey:@"eventcode"];
            [eventDict setValue:@"002" forKey:@"eventPos"];
            [eventDict setValue:@"260" forKey:@"eventType"];
            break;
        }
            ///我的
        case HICMyRecordClickToKnowledge: {
            [eventDict setValue:@"270000" forKey:@"eventcode"];
            [eventDict setValue:@"000" forKey:@"eventPos"];
            [eventDict setValue:@"270" forKey:@"eventType"];
            break;
        }
        case HICMyCommentToKnowledge: {
            [eventDict setValue:@"270001" forKey:@"eventcode"];
            [eventDict setValue:@"001" forKey:@"eventPos"];
            [eventDict setValue:@"270" forKey:@"eventType"];
            break;
        }
        case HICMyCollectToKnowledge: {
            [eventDict setValue:@"270002" forKey:@"eventcode"];
            [eventDict setValue:@"002" forKey:@"eventPos"];
            [eventDict setValue:@"270" forKey:@"eventType"];
            break;
        }
        case HICMyNoteToKnowledge: {
            [eventDict setValue:@"270003" forKey:@"eventcode"];
            [eventDict setValue:@"003" forKey:@"eventPos"];
            [eventDict setValue:@"270" forKey:@"eventType"];
            break;
        }
        case HICMyDownloadToKnowledge: {
            [eventDict setValue:@"270004" forKey:@"eventcode"];
            [eventDict setValue:@"004" forKey:@"eventPos"];
            [eventDict setValue:@"270" forKey:@"eventType"];
            break;
        }
        case HICPlayBackUpload: {
            [eventDict setValue:@"280000" forKey:@"eventcode"];
            [eventDict setValue:@"000" forKey:@"eventPos"];
            [eventDict setValue:@"280" forKey:@"eventType"];
            break;
        }
        case HICPlayBackEnd: {
            [eventDict setValue:@"280001" forKey:@"eventcode"];
            [eventDict setValue:@"001" forKey:@"eventPos"];
            [eventDict setValue:@"280" forKey:@"eventType"];
            break;
        }
        case HICLiveCenter: {
            [eventDict setValue:@"280003" forKey:@"eventcode"];
            [eventDict setValue:@"003" forKey:@"eventPos"];
            [eventDict setValue:@"280" forKey:@"eventType"];
        }
            break;
        case HICPlayBackBtn: {
            [eventDict setValue:@"280004" forKey:@"eventcode"];
            [eventDict setValue:@"004" forKey:@"eventPos"];
            [eventDict setValue:@"280" forKey:@"eventType"];
        }
            break;
        default:
            break;
    }
    return eventDict;
}

#pragma mark --- 业务日志上报 --- end
- (NSString *)getAppName {
    NSString *appname = @"";
    switch ([HICCommonUtils appBundleIden]) {
        case HICAppBundleIdenZhiYu:
            appname = @"zhiyu";
            break;
        case HICAppBundleIdenHiClass:
            appname = @"hiclass";
            break;
        default:
            appname = @"xtw";
            break;
    }
    return appname;
}

@end
