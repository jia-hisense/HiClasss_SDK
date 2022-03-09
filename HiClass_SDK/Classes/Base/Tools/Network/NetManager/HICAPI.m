//
//  HICAPI.m
//  HiClass
//
//  Created by jiafujia on 2021/10/28.
//  Copyright © 2021 hisense. All rights reserved.
//

#import "HICAPI.h"

@implementation HICAPI

/// 绑定AliID和账号，该请求当前仅仅保留，JPUSH SDK已提供相关API
+ (void)requestToBindAliIdAndAccount {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 收到阿里deviceID后，要把该id注册到我们推送系统端
        NSString *aliId = [[NSUserDefaults standardUserDefaults] stringForKey:@"HICAliDeviceID"];
        if (![NSString isValidStr:aliId] || ![NSString isValidStr:USER_CID]) {
            DDLogDebug(@"阿里Id或账号为空，未绑定阿里Id");
            return;
        }
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setValue:aliId forKey:@"aliDeviceId"];
        [dic setValue:SystemManager.deviceID forKey:@"hsDeviceId"];
        [dic setValue:ALI_APP_KEY forKey:@"aliAppKey"];
        [dic setValue:@"true" forKey:@"pushEnabled"];
        [dic setValue:@"ios" forKey:@"osType"];
        [dic setValue:USER_CID forKey:@"appAccount"];
        HICNetModel *netModel = [[HICNetModel alloc] initWithURL:PUSH_REGISTER  params:dic];
        netModel.contentType = HTTPContentTypeJsonType;
        netModel.method = HTTPMethodPOST;
        netModel.urlType = DefaultAppPush;
        [NetManager sentHTTPRequest:netModel success:^(NSDictionary * _Nonnull responseObject) {
            DDLogDebug(@"注册阿里Id成功 responseObject = %@", responseObject);
        } failure:^(NSError * _Nonnull error) {
            NSMutableDictionary *mudic = [[NSMutableDictionary alloc]init];
            [mudic setValue:ALI_DEVICE_ID forKey:@"aliDeviceId"];
            [mudic setValue:@(error.code) forKey:@"resultCode"];
            [mudic setValue:error.description forKey:@"errorDesc"];
        }];
    });
}

+ (void)getLiveStateNum:(Success)success{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableDictionary *dic = [NSMutableDictionary new];
        [dic setValue:USER_CID forKey:@"customerId"];
        HICNetModel *netModel = [[HICNetModel alloc]initWithURL:LIVE_STATUS_NUM params:dic];
        netModel.urlType = DefaultExamURLType;
        netModel.contentType = HTTPContentTypeWwwFormType;
        netModel.method = HTTPMethodGET;
        [NetManager sentHTTPRequest:netModel success:^(NSDictionary * _Nonnull responseObject) {
            if (![responseObject isKindOfClass:[NSDictionary class]]) {
                return;
            }
            success(responseObject);
            
        } failure:^(NSError * _Nonnull error) {
            DDLogDebug(@"请求失败----%@",error.userInfo);
        }];
    });
}
+ (void)getLiveList:(NSInteger)status success:(Success)success failure:(Failure)failure {
    //1-未开始，2-进行中，3-已结束，
    NSMutableDictionary *dic = [NSMutableDictionary new];
    if (status >= 1 && status <= 3) {
        [dic setValue:@(status) forKey:@"status"];
    }
    [dic setValue:USER_CID forKey:@"customerId"];
    [dic setValue:@0 forKey:@"startNum"];
    [dic setValue:@999 forKey:@"offset"];
    [dic setValue:@0 forKey:@"flag"];
    HICNetModel *netModel = [[HICNetModel alloc]initWithURL:LIVE_LIST params:dic];
    netModel.urlType = DefaultExamURLType;
    netModel.contentType = HTTPContentTypeJsonType;
    netModel.method = HTTPMethodGET;
    [NetManager sentHTTPRequest:netModel success:^(NSDictionary * _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}
+ (void)getRoomNumWithID:(NSNumber *)lessonId success:(Success)success failure:(Failure)failure{
        NSMutableDictionary *dic = [NSMutableDictionary new];
        [dic setValue:lessonId forKey:@"liveLessonId"];
        HICNetModel *netModel = [[HICNetModel alloc]initWithURL:LIVE_DETAIL_INFO params:dic];
        netModel.urlType = DefaultExamURLType;
        netModel.contentType = HTTPContentTypeJsonType;
        netModel.method = HTTPMethodGET;
        [NetManager sentHTTPRequest:netModel success:^(NSDictionary * _Nonnull responseObject) {
            success(responseObject);
        } failure:^(NSError * _Nonnull error) {
            failure(error);
        }];
}
+ (void)getQuestionnaireStateNum:(Success)success{
    if (NetManager.netStatus == HICNetUnknown || NetManager.netStatus == HICNetNotReachable) {
        return;
    }
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setValue:USER_CID forKey:@"customerId"];
    HICNetModel *netModel = [[HICNetModel alloc]initWithURL:QUESTION_NUM params:dic];
    netModel.urlType = DefaultExamURLType;
    netModel.contentType = HTTPContentTypeWwwFormType;
    netModel.method = HTTPMethodGET;
    [NetManager sentHTTPRequest:netModel success:^(NSDictionary * _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        DDLogDebug(@"请求失败----%@",error.userInfo);
    }];
}
+ (void)getQuestionnaireList:(NSInteger)status success:(Success)success failure:(Failure)failure {
    if (NetManager.netStatus == HICNetUnknown || NetManager.netStatus == HICNetNotReachable) {
        return;
    }
    NSMutableDictionary *dic = [NSMutableDictionary new];
    if (status != 0) {
        [dic setValue:@(status) forKey:@"state"];
    }
    [dic setValue:USER_CID forKey:@"customerId"];
    [dic setValue:@0 forKey:@"flag"];
    [dic setValue:@0 forKey:@"pageNum"];
    [dic setValue:@999 forKey:@"offset"];
    HICNetModel *netModel = [[HICNetModel alloc]initWithURL:QUESTION_LIST params:dic];
    netModel.urlType = DefaultExamURLType;
    netModel.contentType = HTTPContentTypeJsonType;
    netModel.method = HTTPMethodGET;
    [NetManager sentHTTPRequest:netModel success:^(NSDictionary * _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

+ (void)getRegistrationStateNum:(Success)success{
    if (NetManager.netStatus == HICNetUnknown || NetManager.netStatus == HICNetNotReachable) {
        return;
    }
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setValue:USER_CID forKey:@"customerId"];
    HICNetModel *netModel = [[HICNetModel alloc]initWithURL:ENROLL_NUM params:dic];
    netModel.urlType = DefaultExamURLType;
    netModel.contentType = HTTPContentTypeWwwFormType;
    netModel.method = HTTPMethodGET;
    [NetManager sentHTTPRequest:netModel success:^(NSDictionary * _Nonnull responseObject) {
        if (responseObject[@"data"] ) {
            success(responseObject);
        }
    } failure:^(NSError * _Nonnull error) {
        DDLogDebug(@"请求失败----%@",error.userInfo);
    }];
}
+ (void)getRegistrationList:(NSInteger)status success:(Success)success failure:(Failure)failure {
    NSMutableDictionary *dic = [NSMutableDictionary new];
    if (status == 4) {
        
    }else{
     [dic setValue:[NSNumber numberWithInteger:status] forKey:@"status"];
    }
    [dic setValue:USER_CID forKey:@"customerId"];
    [dic setValue:@0 forKey:@"startNum"];
    [dic setValue:@999 forKey:@"offset"];
    [dic setValue:@0 forKey:@"flag"];
    HICNetModel *netModel = [[HICNetModel alloc]initWithURL:ENROLL_LIST params:dic];
    netModel.urlType = DefaultExamURLType;
    netModel.contentType = HTTPContentTypeJsonType;
    netModel.method = HTTPMethodGET;
    [NetManager sentHTTPRequest:netModel success:^(NSDictionary * _Nonnull responseObject) {
        if (responseObject[@"data"][@"list"]) {
            success(responseObject);
        }
    } failure:^(NSError * _Nonnull error) {
        failure(error);
        DDLogDebug(@"请求失败----%@",error.userInfo);
    }];
}

//+ (void)registrationDetail:(NSNumber *)registerID trainId:(NSNumber *)trainId success:(Success)success failure:(Failure)failure{
//    NSMutableDictionary *dic = [NSMutableDictionary new];
//    [dic setValue:USER_CID forKey:@"customerId"];
//    [dic setValue:registerID.integerValue  ? registerID :@-1 forKey:@"registerId"];
//    [dic setValue:trainId ? trainId : @0 forKey:@"trainId"];
//    HICNetModel *netModel = [[HICNetModel alloc]initWithURL:ENROLL_DETAIL params:dic];
//    netModel.urlType = DefaultExamURLType;
//    netModel.contentType = HTTPContentTypeWwwFormType;
//    netModel.method = HTTPMethodGET;
//    [NetManager sentHTTPRequest:netModel success:^(NSDictionary * _Nonnull responseObject) {
//        if ([HICCommonUtils isValidObject:responseObject[@"data"]]) {
//            success(responseObject);
//        }
//    } failure:^(NSError * _Nonnull error) {
//        if (error.code == 500808) {
//            failure(error);
//        }
//    }];
//}

+ (void)doRegisterWithType:(NSDictionary *)dic success:(Success)success{
    HICNetModel *netModel = [[HICNetModel alloc]initWithURL:ENROLL_OPERATE params:dic];
    netModel.urlType = DefaultExamURLType;
    netModel.contentType = HTTPContentTypeWwwFormType;
    netModel.method = HTTPMethodPOST;
    [NetManager sentHTTPRequest:netModel success:^(NSDictionary * _Nonnull responseObject) {
        if ([HICCommonUtils isValidObject:responseObject[@"msg"]]) {
            NSString *title;
            if ([dic[@"doRegister"] isEqual:@1]) {
                title = NSLocalizableString(@"registrationSuccessPrompt", nil);
                
            }else{
                title = [NSString stringWithFormat:@"%@！",NSLocalizableString(@"registrationHasBeenAbandoned", nil)];
            }
            success(responseObject);
        }
    } failure:^(NSError * _Nonnull error) {
        DDLogDebug(@"请求失败----%@",error.userInfo);
    }];
}

+ (void)forceReview:(NSNumber *)auditInstanceId{
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setValue:auditInstanceId forKey:@"auditProcessInstanceId"];
    [dic setValue:USER_CID forKey:@"customerId"];
    HICNetModel *netModel = [[HICNetModel alloc]initWithURL:ENROLL_URGE params:dic];
    netModel.urlType = DefaultExamURLType;
    netModel.contentType = HTTPContentTypeWwwFormType;
    netModel.method = HTTPMethodPOST;
    [NetManager sentHTTPRequest:netModel success:^(NSDictionary * _Nonnull responseObject) {
        if ([responseObject[@"msg"] isEqualToString:@"OK"]) {
            [HICToast showWithText:NSLocalizableString(@"urgedSuccess", nil)];
        }
    } failure:^(NSError * _Nonnull error) {
        if (error.code == 500806) {
            [HICToast showWithText:NSLocalizableString(@"urgeMoreThanThreeTimes", nil)];
        }
    }];
}
+ (void)doRegisterWithString:(NSMutableDictionary *)dic success:(Success)success{
    HICNetModel *netModel = [[HICNetModel alloc]initWithURL:ENROLL_OPERATE params:dic];
    netModel.urlType = DefaultExamURLType;
    netModel.contentType = HTTPContentTypeWwwFormType;
    netModel.method = HTTPMethodPOST;
    [NetManager sentHTTPRequest:netModel success:^(NSDictionary * _Nonnull responseObject) {
        if ([HICCommonUtils isValidObject:responseObject[@"msg"]]) {
            [HICToast showWithText:NSLocalizableString(@"submittedForReview", nil)];
            success(responseObject);
        }
    } failure:^(NSError * _Nonnull error) {
        [HICToast showWithText:NSLocalizableString(@"registrationFailed", nil)];
    }];
}

+ (void)getDataReviewTemplate:(NSNumber *)auditTemplateID success:(Success)success{
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setValue:auditTemplateID forKey:@"id"];
    [dic setValue:@1 forKey:@"terminalType"];
    HICNetModel *netModel = [[HICNetModel alloc]initWithURL:ENROLL_AUDIT_TEMPLATE params:dic];
    netModel.urlType = DefaultExamURLType;
    netModel.contentType = HTTPContentTypeWwwFormType;
    netModel.method = HTTPMethodGET;
    [NetManager sentHTTPRequest:netModel success:^(NSDictionary * _Nonnull responseObject) {
        if (responseObject[@"data"][@"auditTemplateNodes"]) {
            success(responseObject);
        }
    } failure:^(NSError * _Nonnull error) {
        DDLogDebug(@"请求失败----%@",error.userInfo);
    }];
}
+ (void)getDataReviewProgressStatus:(NSNumber *)auditInstanceId success:(Success)success{
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setValue:auditInstanceId forKey:@"id"];
    [dic setValue:@1 forKey:@"terminalType"];
    HICNetModel *netModel = [[HICNetModel alloc]initWithURL:ENROLL_AUDIT_STATUS params:dic];
    netModel.urlType = DefaultExamURLType;
    netModel.contentType = HTTPContentTypeWwwFormType;
    netModel.method = HTTPMethodGET;
    [NetManager sentHTTPRequest:netModel success:^(NSDictionary * _Nonnull responseObject) {
        if (responseObject[@"data"][@"auditProcessNodes"]) {
            success(responseObject);
        }
    } failure:^(NSError * _Nonnull error) {
        DDLogDebug(@"请求失败----%@",error.userInfo);
    }];
}

+ (void)searchReviewer:(NSMutableDictionary *)dic success:(Success)success failure:(Failure)failure{
    HICNetModel *netModel = [[HICNetModel alloc]initWithURL:ENROLL_REVIEWER_LIST params:dic];
    netModel.urlType = DefaultExamURLType;
    netModel.contentType = HTTPContentTypeWwwFormType;
    netModel.method = HTTPMethodGET;
    [NetManager sentHTTPRequest:netModel success:^(NSDictionary * _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}
+ (void)trainingArrangement:(NSInteger)trainId success:(Success)success failure:(Failure)failure{
    if (!USER_CID) {
        return;
    }
    NSDictionary *paramDic = @{@"trainId":[NSNumber numberWithInteger:trainId], @"customerId":USER_CID};
    HICNetModel *model = [[HICNetModel alloc] initWithURL:@"1.0/app/train/offline/arrangements" params:paramDic];
    model.contentType = HTTPContentTypeWwwFormType;
    model.urlType = DefaultExamURLType;
    [NetManager sentHTTPRequest:model success:^(NSDictionary * _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}
+ (void)checkInAndSignOut:(NSDictionary *)dic success:(Success)success failure:(Failure)failure{
    HICNetModel *netModel = [[HICNetModel alloc] initWithURL:TRAIN_OFFLINE_ATTENDANCE params:dic];
    netModel.contentType = HTTPContentTypeJsonType;
    netModel.urlType = DefaultExamURLType;
    netModel.method = HTTPMethodPOST;
    [NetManager sentHTTPRequest:netModel success:^(NSDictionary * _Nonnull responseObject) {
        if ([responseObject[@"msg"] isEqualToString:@"OK"]) {
            if ([dic[@"taskType"] isEqual:@10]) {
                [HICToast showWithText:NSLocalizableString(@"signBackSuccessfully", nil)];
            }else{
                [HICToast showWithText:NSLocalizableString(@"signInSuccessfully", nil)];
            }
        }
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        if (error.code == HICAttError) {
            [HICToast showWithText:NSLocalizableString(@"wrongSignInPassword", nil)];
        }else if (error.code == HICAttNotTime){
           [HICToast showWithText:NSLocalizableString(@"lateSignInTime", nil)];
        }
        else if (error.code == HICAttOveredTime){
           [HICToast showWithText:NSLocalizableString(@"signInTimeIsPast", nil)];
        }else if (error.code == HICSignOffNotime){
           [HICToast showWithText:NSLocalizableString(@"lateToSignOut", nil)];
        }else if (error.code == HICSignOffOveredTime){
           [HICToast showWithText:NSLocalizableString(@"signOffTimeHasExpired", nil)];
        }else{
            
        }
        failure(error);
    }];

}

+ (void)lineClassDetails:(NSDictionary *)dic success:(Success)success{
    
    HICNetModel *netModel = [[HICNetModel alloc]initWithURL:TRAIN_OFFLINE_COURSELIST params:dic];
        netModel.urlType = DefaultExamURLType;
        netModel.contentType = HTTPContentTypeJsonType;
        netModel.method = HTTPMethodGET;
        [NetManager sentHTTPRequest:netModel success:^(NSDictionary * _Nonnull responseObject) {
            if (responseObject[@"data"]) {
                success(responseObject);
            }
        } failure:^(NSError * _Nonnull error) {
            DDLogDebug(@"请求失败----%@",error.userInfo);
        }];
}
+ (void)curriculum:(NSNumber *)trainId  success:(Success)success{
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setValue:trainId forKey:@"trainId"];
    HICNetModel *netModel = [[HICNetModel alloc]initWithURL:TRAIN_MIX_NOTENROLL params:dic];
    netModel.urlType = DefaultExamURLType;
    netModel.contentType = HTTPContentTypeWwwFormType;
    netModel.method = HTTPMethodGET;
    [NetManager sentHTTPRequest:netModel success:^(NSDictionary * _Nonnull responseObject) {
        if (responseObject[@"data"] && [responseObject[@"data"][@"list"] isKindOfClass:NSArray.class]) {
            success(responseObject);
        }
    } failure:^(NSError * _Nonnull error) {
        DDLogDebug(@"请求失败----%@",error.userInfo);
    }];
}
+ (void)offlineTrainingDetail:(NSInteger)trainId success:(Success)success failure:(Failure)failure{
    NSMutableDictionary *requestDic = [[NSMutableDictionary alloc] init];
    // 培训id
    [requestDic setValue:[NSNumber numberWithInteger:trainId] forKey:@"trainId"];
    [requestDic setValue:USER_CID forKey:@"customerId"];
    HICNetModel *netModel = [[HICNetModel alloc] initWithURL:@"1.0/app/train/offline/detailInfo" params:requestDic];
    netModel.contentType = HTTPContentTypeWwwFormType;
    netModel.method = HTTPMethodGET;
    netModel.urlType = DefaultExamURLType;
    
    [NetManager sentHTTPRequest:netModel success:^(NSDictionary * _Nonnull responseObject) {
         success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}
+ (void)registrationDetail:(NSDictionary *)dic success:(Success)success failure:(Failure)failure{
    HICNetModel *netModel = [[HICNetModel alloc]initWithURL:ENROLL_DETAIL params:dic];
    netModel.urlType = DefaultExamURLType;
    netModel.contentType = HTTPContentTypeWwwFormType;
    netModel.method = HTTPMethodGET;
    [NetManager sentHTTPRequest:netModel success:^(NSDictionary * _Nonnull responseObject) {
        if ([HICCommonUtils isValidObject:responseObject[@"data"]]) {
            success(responseObject);
        }
    } failure:^(NSError * _Nonnull error) {
        if (error.code == 500808) {//无权限查看报名
            failure(error);
        }
    }];
}
+ (void)instructorOfflineCourseDetails:(HICNetModel *)netModel   success:(Success)success failure:(Failure)failure{
    [NetManager sentHTTPRequest:netModel success:^(NSDictionary * _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}
+ (void)taskList:(NSDictionary *)dic success:(Success)success failure:(Failure)failure{
    HICNetModel *model = [[HICNetModel alloc]initWithURL:@"1.0/app/train/taskCenter/list" params:dic];
    model.contentType = HTTPContentTypeWwwFormType;
    model.urlType = DefaultExamURLType;
    [NetManager sentHTTPRequest:model success:^(NSDictionary * _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}
+ (void)homePageDetail:(Success)success failure:(Failure)failure{
    DDLogDebug(@"[HIC]-[JXL] - 网络请求首页数据");
    NSDictionary *dic = @{@"terminalType":@1, @"format": @"0", @"customerId": USER_CID};
    HICNetModel *model = [[HICNetModel alloc]initWithURL:@"heduapi/app_api/v1.0/course_kld/get_home_page" params:dic];
    model.contentType = HTTPContentTypeJsonType;
    model.urlType = DefaultExamURLType;
    [NetManager sentHTTPRequest:model success:^(NSDictionary * _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}
+ (void)getLastLearningRecord:(Success)success{
    NSDictionary *dic = @{@"customerId":USER_CID};
    HICNetModel *model = [[HICNetModel alloc]initWithURL:LEARNING_RECORD_DETAIL params:dic];
    model.contentType = HTTPContentTypeJsonType;
    model.urlType = DefaultExamURLType;
    [NetManager sentHTTPRequest:model success:^(NSDictionary * _Nonnull responseObject) {
        DDLogDebug(@"LEARNING_RECORD_DETAIL: %@", responseObject);
        if (!responseObject) { return; }
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        DDLogDebug(@"[HIC] 请求最新学习记录失败");
    }];
}
+ (void)queryCourseKnowledgeContent:(NSDictionary *)dic success:(Success)success failure:(Failure)failure{
    HICNetModel *model = [[HICNetModel alloc] initWithURL:@"heduapi/app_api/v1.0/homepage/resource/get" params:[dic copy]];
    model.contentType = HTTPContentTypeWwwFormType;
    model.urlType = DefaultExamURLType;
    [NetManager sentHTTPRequest:model success:^(NSDictionary * _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        DDLogDebug(@"[HIC]-[POST_MAP] :路线图失败%@", error.userInfo);
        failure(error);
    }];
}

+(void)directoryQuery:(NSString *)dir success:(Success)success failure:(Failure)failure{
    NSString *dirId = [NSString isValidStr:dir]?dir:@"";
    NSDictionary *dic = @{@"dirId" : dirId};
    HICNetModel *model = [[HICNetModel alloc] initWithURL:@"heduapi/app_api/v1.0/common/catalog/get" params:dic];
    model.contentType = HTTPContentTypeWwwFormType;
    model.urlType = DefaultExamURLType;
    [RoleManager showWindowLoadingView];
    [NetManager sentHTTPRequest:model success:^(NSDictionary * _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        DDLogDebug(@"[HIC]-[POST_MAP] :路线图失败%@", error.userInfo);
        failure(error);
    }];
}

+ (void)searchTeacherAndCourse:(NSDictionary *)dic success:(Success)success failure:(Failure)failure{
    
    HICNetModel *model = [[HICNetModel alloc] initWithURL:@"heduapi/app_api/v1.0/search/query" params:dic];
    model.contentType = HTTPContentTypeJsonType;
    model.urlType = DefaultExamURLType;
    [NetManager sentHTTPRequest:model success:^(NSDictionary * _Nonnull responseObject) {
        if ([HICCommonUtils isValidObject: responseObject[@"data"]]) {
            success(responseObject);
        }
    } failure:^(NSError * _Nonnull error) {
        DDLogDebug(@"[HIC]-[POST_MAP] :路线图失败%@", error.userInfo);
        failure(error); 
    }];
}
+(void)postMapRoute:(Success)success failure:(Failure)failure{

    if (!USER_CID) {
        return;
    }
    [RoleManager showWindowLoadingView];
    NSDictionary *dic = @{@"customerId":USER_CID};
    HICNetModel *model = [[HICNetModel alloc] initWithURL:@"1.0/app/train/map/post/way" params:dic];
    model.contentType = HTTPContentTypeWwwFormType;
    model.urlType = DefaultCommentURLType;

    [NetManager sentHTTPRequest:model success:^(NSDictionary * _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];

}
+(void)postRequirement:(NSInteger)ID success:(Success)success failure:(Failure)failure{
    NSDictionary *dic = @{@"customerId":USER_CID, @"trainPostId":[NSNumber numberWithInteger:ID]};
    HICNetModel *model = [[HICNetModel alloc] initWithURL:@"1.0/app/train/map/post/duty" params:dic];
    model.contentType = HTTPContentTypeWwwFormType;
    model.urlType = DefaultCommentURLType;
    [NetManager sentHTTPRequest:model success:^(NSDictionary * _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}
+ (void)getRightAlertLoadData:(NSNumber *)trainId success:(Success)success{
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setValue:trainId forKey:@"trainId"];
    [dic setValue:USER_CID forKey:@"customerId"];
    HICNetModel *netModel = [[HICNetModel alloc]initWithURL:TRAIN_DETAIL_BASE params:dic];
    netModel.urlType = DefaultExamURLType;
    netModel.contentType = HTTPContentTypeWwwFormType;
    netModel.method = HTTPMethodGET;
    [NetManager sentHTTPRequest:netModel success:^(NSDictionary * _Nonnull responseObject) {
        if (responseObject[@"data"][@"trainId"]) {
            success(responseObject);
        }
    } failure:^(NSError * _Nonnull error) {
        DDLogDebug(@"请求失败----%@",error.userInfo);
    }];
}
+ (void)syncProgress:(NSNumber *)trainId success:(Success)success failure:(Failure)failure{
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setValue:trainId forKey:@"trainId"];
    HICNetModel *netModel = [[HICNetModel alloc]initWithURL:TRAIN_SYNC_PROGRESS params:dic];
    netModel.urlType = DefaultExamURLType;
    netModel.contentType = HTTPContentTypeWwwFormType;
    netModel.method = HTTPMethodPOST;
    [NetManager sentHTTPRequest:netModel success:^(NSDictionary * _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}
+(void)morePost:(NSNumber *)nodeId success:(Success)success{
    NSDictionary *dic = @{@"customerId":USER_CID, @"nodeId":nodeId};
    HICNetModel *model = [[HICNetModel alloc] initWithURL:@"1.0/app/train/map/post/more" params:dic];
    model.contentType = HTTPContentTypeWwwFormType;
    model.urlType = DefaultCommentURLType;

    [NetManager sentHTTPRequest:model success:^(NSDictionary * _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        DDLogDebug(@"[HIC]-[MapMore] - 岗位地图更多数据请求失败");
    }];
}
+(void)loadDataCer:(NSNumber *)trainId success:(Success)success failure:(Failure)failure{
    NSDictionary *dic = @{@"customerId":USER_CID, @"trainId":trainId};
    HICNetModel *model = [[HICNetModel alloc] initWithURL:TRAIN_AWARD_CERTIFICATES params:dic];
    model.contentType = HTTPContentTypeWwwFormType;
    model.urlType = DefaultCommentURLType;

    [NetManager sentHTTPRequest:model success:^(NSDictionary * _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}
+ (void)getRankList:(NSDictionary *)dic success:(Success)success failure:(Failure)failure{
    HICNetModel *netModel = [[HICNetModel alloc]initWithURL:RANK_LIST params:dic];
    netModel.contentType = HTTPContentTypeWwwFormType;
    netModel.method = HTTPMethodGET;
    netModel.urlType = DefaultExamURLType;
    [NetManager sentHTTPRequest:netModel success:^(NSDictionary * _Nonnull responseObject) {
        if ([HICCommonUtils isValidObject:responseObject[@"data"]]) {
            success(responseObject);
        }
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}
+(void)loadDataMessageNum:(NSDictionary *)dic success:(Success)success failure:(Failure)failure{
    HICNetModel *model = [[HICNetModel alloc]initWithURL:MSG_CENTER_MSG_STATUS params:dic];
    model.contentType = HTTPContentTypeWwwFormType;
    model.urlType = DefaultExamURLType;
    [NetManager sentHTTPRequest:model success:^(NSDictionary * _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}
+(void)loadDataSever:(NSDictionary *)dic success:(Success)success failure:(Failure)failure{
    HICNetModel *model = [[HICNetModel alloc]initWithURL:@"heduapi/app_api/v1.0/course_kld/get_list_bycategory" params:dic];
    model.contentType = HTTPContentTypeWwwFormType;
    model.urlType = DefaultExamURLType;
    [NetManager sentHTTPRequest:model success:^(NSDictionary * _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        DDLogDebug(@"[HIC]-[JXL] - 网络请求首页课程知识数据失败");
        failure(error);
    }];

}
+(void)loadDataUserDetailAndRoleChangeRoot:(Success)success failure:(Failure)failure{
    if (!USER_CID || !USER_TOKEN) {
        // 不存在的情况下直接返回
        return;
    }
    
    NSDictionary *dic = @{@"id":@100, @"custId":USER_CID, @"token":USER_TOKEN, @"roleCodes":@-1, @"autonomousOrgCode":@-1, @"userDeptNumber":@-1};
    HICNetModel *model = [[HICNetModel alloc] initWithURL:@"heduopapi/employee/getDetail" params:dic];
    model.contentType = HTTPContentTypeWwwFormType;
    model.urlType = DefaultCommentURLType;

    [NetManager sentHTTPRequest:model success:^(NSDictionary * _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        DDLogDebug(@"[HIC]-[RoleManager] --- 网络数据请求失败！");
        failure(error);
    }];
}

+ (void)getSystemConfiguration {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        HICNetModel *netModel = [[HICNetModel alloc] initWithURL:SYS_CONFIG_PARAMS  params:dic];
        netModel.contentType = HTTPContentTypeJsonType;
        netModel.method = HTTPMethodPOST;
        netModel.urlType = DefaultCommentURLType;
        [NetManager sentHTTPRequest:netModel success:^(NSDictionary * _Nonnull responseObject) {
            NSDictionary *data = [responseObject valueForKey:@"data"];
            if ([HICCommonUtils isValidObject:data] && [data.allKeys containsObject:@"livePlaybackInterval"]) {
                [[NSUserDefaults standardUserDefaults] setInteger:[[data valueForKey:@"livePlaybackInterval"] integerValue] forKey:@"reportInteval"];
            }
        } failure:^(NSError * _Nonnull error) {
            DDLogDebug(@"获取系统参数的接口请求失败");
        }];
    });
}

+ (void)lecturerOfflineCourses:(NSDictionary *)dic success:(Success)success failure:(Failure)failure{
    HICNetModel *netModel = [[HICNetModel alloc]initWithURL:@"1.0/app/train/lecturer/offlineclass/list"  params:dic];
    netModel.contentType = HTTPContentTypeWwwFormType;
    netModel.urlType = DefaultExamURLType;

    [NetManager sentHTTPRequest:netModel success:^(NSDictionary * _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];

}
+ (void)lecturerScheduleLectures:(NSDictionary *)dic success:(Success)success failure:(Failure)failure{
    
    HICNetModel *netModel = [[HICNetModel alloc]initWithURL:@"1.0/app/train/lecturer/classes/calendar"  params:dic];
    netModel.contentType = HTTPContentTypeWwwFormType;
    netModel.urlType = DefaultExamURLType;

    [NetManager sentHTTPRequest:netModel success:^(NSDictionary * _Nonnull responseObject) {
        success(responseObject);
        
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];

}
+ (void)getLectureDetail:(NSDictionary *)dic success:(Success)success{
    HICNetModel *netModel = [[HICNetModel alloc]initWithURL:LECTURE_DETAIL params:dic];
    netModel.urlType = DefaultExamURLType;
    netModel.contentType = HTTPContentTypeWwwFormType;
    netModel.method = HTTPMethodGET;
    [NetManager sentHTTPRequest:netModel success:^(NSDictionary * _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        
    }];
}
+ (void)knowledgeAndCourseEnquiries:(NSDictionary *)dic success:(Success)success{
    
    HICNetModel *netModel = [[HICNetModel alloc]initWithURL:KNOWLEDGE_LIST  params:dic];
    netModel.contentType = HTTPContentTypeWwwFormType;
    netModel.urlType = DefaultExamURLType;
    [NetManager sentHTTPRequest:netModel success:^(NSDictionary * _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        
    }];
}
+ (void)homeWorkDetail:(NSDictionary *)dic success:(Success)success failure:(Failure)failure{
    HICNetModel *model = [[HICNetModel alloc] initWithURL:@"1.0/app/train/work/list" params:dic];
    model.contentType = HTTPContentTypeWwwFormType;
    model.urlType = DefaultCommentURLType;
    [NetManager sentHTTPRequest:model success:^(NSDictionary * _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}
+(void)homeworkSubtaskDetails:(NSDictionary *)dic success:(Success)success{
    HICNetModel *model = [[HICNetModel alloc] initWithURL:@"1.0/app/train/work/job/result/detail" params:dic];
    model.contentType = HTTPContentTypeWwwFormType;
    model.urlType = DefaultExamURLType;

    [NetManager sentHTTPRequest:model success:^(NSDictionary * _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        DDLogDebug(@"[HIC]-[HomeworkDetail]--作业详情网络请求错误%@", error.userInfo);
    }];
}
+(void)homeworkSubtaskWithdraw:(NSDictionary *)dic success:(Success)success{
    
    HICNetModel *model = [[HICNetModel alloc] initWithURL:@"1.0/app/train/work/job/recall" params:dic];
    model.contentType = HTTPContentTypeWwwFormType;
    model.urlType = DefaultExamURLType;

    [NetManager sentHTTPRequest:model success:^(NSDictionary * _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        DDLogDebug(@"[HIC]-[HomeworkDetail]--作业详情网络请求错误%@", error.userInfo);
    }];
}
+(void)homeworkSubtaskSubmit:(NSDictionary *)dic url:(NSString *)url success:(Success)success failure:(Failure)failure{
    
    HICNetModel *netModel = [[HICNetModel alloc] initWithURL:url params:dic];
    netModel.method = HTTPMethodPOST;
    netModel.contentType = HTTPContentTypeJsonType;
    netModel.urlType = DefaultCommentURLType;
    [NetManager sentHTTPRequest:netModel success:^(NSDictionary * _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}
+ (void)getTrainingManagementNum:(Success)success{
    if (NetManager.netStatus == HICNetUnknown || NetManager.netStatus == HICNetNotReachable) {
        return;
    }
    NSMutableDictionary *dic = [NSMutableDictionary new];
//    [dic setValue:@1859955887 forKey:@"customerId"];
    HICNetModel *netModel = [[HICNetModel alloc]initWithURL:TRAIN_TASKNUM params:dic];
    netModel.urlType = DefaultExamURLType;
    netModel.contentType = HTTPContentTypeWwwFormType;
    netModel.method = HTTPMethodGET;
    [NetManager sentHTTPRequest:netModel success:^(NSDictionary * _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {

    }];
}
+ (void)getTrainingManagementList:(NSInteger)status success:(Success)success failure:(Failure)failure{
    if (NetManager.netStatus == HICNetUnknown || NetManager.netStatus == HICNetNotReachable) {
        return;
    }
    NSMutableDictionary *dic = [NSMutableDictionary new];
    if (status == 4) {
       [dic setValue:@0 forKey:@"status"];
    }else{
     [dic setValue:[NSNumber numberWithInteger:status] forKey:@"status"];
    }
    [dic setValue:@0 forKey:@"startNum"];
    [dic setValue:@999 forKey:@"offset"];
    HICNetModel *netModel = [[HICNetModel alloc]initWithURL:TRAIN_LIST params:dic];
    netModel.urlType = DefaultExamURLType;
    netModel.contentType = HTTPContentTypeJsonType;
    netModel.method = HTTPMethodGET;
    [NetManager sentHTTPRequest:netModel success:^(NSDictionary * _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
    
}
+ (void)traineesRanking:(NSNumber *)trainId success:(Success)success{
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setValue:trainId forKey:@"trainId"];
    [dic setValue:USER_CID forKey:@"customerId"];
    HICNetModel *netModel = [[HICNetModel alloc]initWithURL:TRAIN_TRAINEE_POSITION params:dic];
    netModel.urlType = DefaultExamURLType;
    netModel.contentType = HTTPContentTypeWwwFormType;
    netModel.method = HTTPMethodGET;
    [NetManager sentHTTPRequest:netModel success:^(NSDictionary * _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        
    }];
}
+ (void)trainingTaskList:(NSNumber *)trainId success:(Success)success failure:(Failure)failure{
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setValue:trainId forKey:@"trainId"];
    HICNetModel *netModel = [[HICNetModel alloc]initWithURL:TRAIN_DETAIL_LIST params:dic];
    netModel.urlType = DefaultExamURLType;
    netModel.contentType = HTTPContentTypeWwwFormType;
    netModel.method = HTTPMethodGET;
    [NetManager sentHTTPRequest:netModel success:^(NSDictionary * _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}
+ (void)clickScoreBtnWithType:(NSDictionary *)dic success:(Success)success{
    HICNetModel *netModel = [[HICNetModel alloc]initWithURL:HANDON_APPLY params:dic];
    netModel.urlType = DefaultExamURLType;
    netModel.contentType = HTTPContentTypeJsonType;
    netModel.method = HTTPMethodPOST;
    [NetManager sentHTTPRequest:netModel success:^(NSDictionary * _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        [HICToast showWithText:NSLocalizableString(@"toApplyGradeFaild", nil)];
    }];
    
}
+ (void)homePageDataQuery:(Success)success failure:(Failure)failure{
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setValue:@1 forKey:@"terminalType"];
    //        [dic setValue:@1831037005 forKey:@"customerId"];
    HICNetModel *netModel = [[HICNetModel alloc]initWithURL:MY_FIRST_PAGE_INFO params:dic];
    netModel.urlType = DefaultExamURLType;
    netModel.contentType = HTTPContentTypeJsonType;
    netModel.method = HTTPMethodGET;
    [NetManager sentHTTPRequest:netModel success:^(NSDictionary * _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}
+ (void)mixedTrainingArrangement:(NSNumber *)trainId success:(Success)success{
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setValue:trainId forKey:@"trainId"];
    [dic setValue:USER_CID forKey:@"customerId"];
    HICNetModel *netModel = [[HICNetModel alloc]initWithURL:TRAIN_MIX_ARRANGE params:dic];
    netModel.urlType = DefaultExamURLType;
    netModel.contentType = HTTPContentTypeWwwFormType;
    netModel.method = HTTPMethodGET;
    [NetManager sentHTTPRequest:netModel success:^(NSDictionary * _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        
    }];
}
+ (void)queryingMessageList:(HICMsgType )msgType success:(Success)success{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:@(msgType) forKey:@"messageType"];
    [dic setValue:@(1) forKey:@"terminalType"];
    HICNetModel *netModel = [[HICNetModel alloc] initWithURL:MSG_CENTER_MSG_LIST params:dic];
    netModel.contentType = HTTPContentTypeWwwFormType;
//    netModel.method = HTTPMethodPOST;
    netModel.urlType = DefaultExamURLType;
    [NetManager sentHTTPRequest:netModel success:^(NSDictionary * _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        DDLogDebug(@"error");
    }];
}
+ (void)changeUnreadMsgStatusWithArr:(NSArray *)arr success:(Success)success failure:(Failure)failure{
    if (arr.count > 0) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setValue:[arr componentsJoinedByString:@","] forKey:@"messageIds"];
        [dic setValue:@(1) forKey:@"messageStatus"];
        [dic setValue:@(1) forKey:@"action"];
        [dic setValue:@(1) forKey:@"terminalType"];

        NSMutableString *URL = [NSMutableString stringWithFormat:@"%@",MSG_CENTER_MSG_MANAGE];
            //获取字典的所有keys
            NSArray * keys = [dic allKeys];

            //拼接字符串
            for (int j = 0; j < keys.count; j ++){
                NSString *string;
                if (j == 0){
                    //拼接时加？
                    string = [NSString stringWithFormat:@"?%@=%@", keys[j], dic[keys[j]]];

                }else{
                    //拼接时加&
                    string = [NSString stringWithFormat:@"&%@=%@", keys[j], dic[keys[j]]];
                }
                //拼接字符串
                [URL appendString:string];

            }

        HICNetModel *netModel = [[HICNetModel alloc] initWithURL:[URL copy]  params:dic];
        netModel.contentType = HTTPContentTypeJsonType;
        netModel.urlType = DefaultExamURLType;
        netModel.method = HTTPMethodPOST;
        [NetManager sentHTTPRequest:netModel success:^(NSDictionary * _Nonnull responseObject) {
            success(responseObject);
        } failure:^(NSError * _Nonnull error) {
            failure(error);
        }];
    }
}

+ (void)myComment:(NSInteger)pageIndex success:(Success)success failure:(Failure)failure {
    NSMutableDictionary *postModel = [NSMutableDictionary new];
    [postModel setObject:[NSNumber numberWithInteger:pageIndex * 10] forKey:@"start"];
    [postModel setObject:@10 forKey:@"limit"];
    HICNetModel *netModel = [[HICNetModel alloc]initWithURL:MY_COMMENT_LIST  params:postModel];
    netModel.contentType = HTTPContentTypeWwwFormType;
    netModel.method = HTTPMethodGET;
    netModel.urlType = DefaultExamURLType;
    [NetManager sentHTTPRequest:netModel success:^(NSDictionary * _Nonnull responseObject){
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

+ (void)LikeReplyDeleteCommentReply:(NSDictionary *)dic success:(Success)success failure:(Failure)failure{
    HICNetModel *netModel = [[HICNetModel alloc] initWithURL:COMMENT_ACTION  params:dic];
    netModel.contentType = HTTPContentTypeWwwFormType;
    netModel.method = HTTPMethodPOST;
    netModel.urlType = DefaultCommentURLType;
    [NetManager sentHTTPRequest:netModel success:^(NSDictionary * _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}
+(void)deleteCollection:(NSDictionary *)dic url:(NSString *)url success:(Success)success{
    HICNetModel *netModel = [[HICNetModel alloc]initWithURL:url params:dic];
    netModel.contentType = HTTPContentTypeJsonType;
    netModel.method = HTTPMethodPOST;
    netModel.urlType = DefaultExamURLType;
    [NetManager sentHTTPRequest:netModel success:^(NSDictionary * _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {

    }];
}
+ (void)integralTaskList:(Success)success{
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setValue:@1 forKey:@"terminalType"];
    [dic setValue:USER_CID forKey:@"customerId"];
    HICNetModel *netModel = [[HICNetModel alloc]initWithURL:Integral_TASK_LIST params:dic];
    netModel.urlType = DefaultExamURLType;
    netModel.contentType = HTTPContentTypeJsonType;
    netModel.method = HTTPMethodGET;
    [NetManager sentHTTPRequest:netModel success:^(NSDictionary * _Nonnull responseObject) {
        if ([responseObject[@"resultCode"] isEqual:@0]) {
            if (responseObject[@"data"] ) {
                success(responseObject);
            }
        }
    } failure:^(NSError * _Nonnull error) {
        //             [RoleManager hiddenWindowLoadingView];
    }];
}
+(void)IntegralSubsidiaryList:(NSInteger)pageIndex success:(Success)success failure:(Failure)failure {

    NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithDictionary:@{@"pageNum":[NSNumber numberWithInteger:pageIndex], @"pageSize":@20, @"customerId":USER_CID}];
    HICNetModel *model = [[HICNetModel alloc] initWithURL:Integral_Subsidiary_List params:[mDic copy]];
    model.contentType = HTTPContentTypeWwwFormType;
    model.urlType = DefaultExamURLType;
    [NetManager sentHTTPRequest:model success:^(NSDictionary * _Nonnull responseObject) {
        if ([responseObject[@"resultCode"] isEqual:@0]) {
            if (responseObject[@"data"] ) {
                success(responseObject);
            }
        }
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}
+ (void)certificateDetails:(NSString *)employeeCertId success:(Success)success {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:employeeCertId forKey:@"employeeCertId"];

    HICNetModel *netModel = [[HICNetModel alloc] initWithURL:MY_CERT_DETAIL  params:dic];
    netModel.contentType = HTTPContentTypeJsonType;
    netModel.urlType = DefaultCommentURLType;
    [NetManager sentHTTPRequest:netModel success:^(NSDictionary * _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        DDLogDebug(@"error");
    }];
}
+ (void)certificateList:(NSDictionary *)dic success:(Success)success {
    HICNetModel *netModel = [[HICNetModel alloc] initWithURL:MY_CERT_LIST  params:dic];
    netModel.contentType = HTTPContentTypeJsonType;
    netModel.urlType = DefaultCommentURLType;
    [NetManager sentHTTPRequest:netModel success:^(NSDictionary * _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        DDLogDebug(@"error");
    }];
}
+ (void)auditedTasksNum:(Success)success failure:(Failure)failure {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:@0 forKey:@"status"];
    HICNetModel *netModel = [[HICNetModel alloc] initWithURL:WORK_SPACE_AUDIT_NUMS  params:dic];
    netModel.contentType = HTTPContentTypeJsonType;
    netModel.urlType = DefaultCommentURLType;
    [NetManager sentHTTPRequest:netModel success:^(NSDictionary * _Nonnull responseObject) {
        success(responseObject);

    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}
+ (void)uploadHeaderWith:(NSString *)picUrl success:(Success)success failure:(Failure)failure{
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setValue:picUrl forKey:@"headPicUrl"];
    [dic setValue:USER_TOKEN forKey:@"accessToken"];
    NSString *url = [HEADER_UPLODE stringByAppendingFormat:@"?terminalType=1"];
    HICNetModel *netModel = [[HICNetModel alloc]initWithURL:url params:dic];
    netModel.urlType = DefaultExamURLType;
    netModel.contentType = HTTPContentTypeJsonType;
    netModel.method = HTTPMethodPOST;
    [NetManager sentHTTPRequest:netModel success:^(NSDictionary * _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}
+ (void)studyNoteList:(Success)success failure:(Failure)failure {
    NSMutableDictionary *postModel = [NSMutableDictionary new];
    HICNetModel *netModel = [[HICNetModel alloc]initWithURL:MY_NOTE_OVERVIEW  params:postModel];
    netModel.contentType = HTTPContentTypeWwwFormType;
    netModel.method = HTTPMethodGET;
    netModel.urlType = DefaultExamURLType;
    [RoleManager showWindowLoadingView];
    [NetManager sentHTTPRequest:netModel success:^(NSDictionary * _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}
+ (void)myCollectionList:(Success)success failure:(Failure)failure {
    NSMutableDictionary *postModel = [NSMutableDictionary new];
    HICNetModel *netModel = [[HICNetModel alloc]initWithURL:MY_COLLECT_LIST  params:postModel];
    netModel.contentType = HTTPContentTypeWwwFormType;
    netModel.method = HTTPMethodGET;
    netModel.urlType = DefaultExamURLType;
    [RoleManager showWindowLoadingView];
    [NetManager sentHTTPRequest:netModel success:^(NSDictionary * _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}
+ (void)studyRecordList:(Success)success failure:(Failure)failure {
    NSMutableDictionary *postModel = [NSMutableDictionary new];
    HICNetModel *netModel = [[HICNetModel alloc]initWithURL:MY_RECORD_LIST  params:postModel];
    netModel.contentType = HTTPContentTypeWwwFormType;
    netModel.method = HTTPMethodGET;
    netModel.urlType = DefaultExamURLType;
    [RoleManager showWindowLoadingView];
    [NetManager sentHTTPRequest:netModel success:^(NSDictionary * _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

+ (void)uploadDownloadRecordWithModel:(HICKnowledgeDownloadModel *)model{
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setValue:model.mediaId forKey:@"resourceId"];
    [dic setValue:@7 forKey:@"resourceType"];
    [dic setValue:model.mediaType forKey:@"mediaType"];
    [dic setValue:model.trainID forKey:@"trainId"];
    [dic setValue:model.cMediaId forKey:@"courseId"];
    [dic setValue:model.sectionId forKey:@"sectionId"];
    [dic setValue:USER_TOKEN forKey:@"accessToken"];
    NSString *urlStr = [DOWNLOAD_RECORD stringByAppendingFormat:@"?terminalType=1&customerId=%@&appVersion=%@&appVersionCode=22&appVersionName=%@&appPackageName=%@&deviceId=%@",USER_CID,SystemManager.appVersion,SystemManager.appVersion,SystemManager.appBundle,SystemManager.deviceID];
    HICNetModel*netModel = [[HICNetModel alloc]initWithURL:urlStr  params:dic];
    netModel.contentType = HTTPContentTypeJsonType;
    netModel.urlType = DefaultExamURLType;
    netModel.method = HTTPMethodPOST;
    [NetManager sentHTTPRequest:netModel success:^(NSDictionary * _Nonnull responseObject) {
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}
+ (void)studyNoteDetail:(NSDictionary *)dic success:(Success)success failure:(Failure)failure {
    
        HICNetModel *netModel = [[HICNetModel alloc] initWithURL:MY_NOTE_LIST  params:dic];
        netModel.contentType = HTTPContentTypeWwwFormType;
        netModel.urlType = DefaultExamURLType;
        [NetManager sentHTTPRequest:netModel success:^(NSDictionary * _Nonnull responseObject) {
            success(responseObject);
        } failure:^(NSError * _Nonnull error) {
            failure(error);
        }];
        
        
}
+ (void)commentList:(NSDictionary *)dic success:(Success)success failure:(Failure)failure {
    HICNetModel *model = [[HICNetModel alloc] initWithURL:COMMENT_LIST  params:dic];
    model.contentType = HTTPContentTypeJsonType;
    model.urlType = DefaultCommentURLType;
    [NetManager sentHTTPRequest:model success:^(NSDictionary * _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

+ (void)knowledgeAndCourseDetails:(NSDictionary *)dic success:(Success)success failure:(Failure)failure{
    HICNetModel *netModel = [[HICNetModel alloc]initWithURL:COURSE_LIST_DETAIL  params:dic];
    netModel.contentType = HTTPContentTypeWwwFormType;
    netModel.method = HTTPMethodGET;
    netModel.urlType = DefaultExamURLType;
    [NetManager sentHTTPRequest:netModel success:^(NSDictionary * _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

+ (void)publishBtnClickedWithContent:(NSString *)content type:(HICCommentType)type starNum:(NSInteger)stars isImportant:(BOOL)important toAnybody:(NSString *)name objectID:(NSNumber *)objectID typeCode:(HICReportType)typeCode success:(Success)success failure:(Failure)failure{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    NSString *url = @"";
    if (type == HICCommentWrite) { // 发表评论
        url = COMMENT_POST_COMMENT;
        [dic setValue:[NSString stringWithFormat:@"%ld", (long)stars] forKey:@"userscore"];
        [dic setValue:content forKey:@"comment"];
        [dic setValue:[NSString stringWithFormat:@"%lu",(unsigned long)typeCode] forKey:@"typeCode"];
        [dic setValue:@"9999" forKey:@"productCode"];
        [dic setValue:[objectID toString] forKey:@"objectid"];
        [dic setValue:@"0" forKey:@"coverflag"];
    } else if (type == HICCommentReply) { // 回复评论
        DDLogDebug(@"回复评论");
    } else { // 添加笔记
        url = KLD_ADD_NOTE;
        [dic setValue:important ? @(1) : @(0) forKey:@"majorFlag"];
        [dic setValue:@(6) forKey:@"objectType"];
        [dic setValue:objectID forKey:@"objectId"];
        [dic setValue:@(1) forKey:@"terminalType"];
        [dic setValue:content forKey:@"content"];
        [dic setValue:@"" forKey:@"title"];
    }

    HICNetModel *netModel = [[HICNetModel alloc] initWithURL:url  params:dic];
    netModel.contentType = type == HICCommentWrite ? HTTPContentTypeWwwFormType : HTTPContentTypeJsonType;
    netModel.method = HTTPMethodPOST;
    if (type == HICCommentNote) {
        netModel.urlType = DefaultExamURLType;
    } else {
        netModel.urlType = DefaultCommentURLType;
    }
    [NetManager sentHTTPRequest:netModel success:^(NSDictionary * _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}
+(void)reportLearningRecords:(NSDictionary *)dic success:(Success)success failure:(Failure)failure{
    NSString *urlStr = [REPORT_RECORD stringByAppendingFormat:@"?terminalType=1&customerId=%@&appVersion=%@&appVersionCode=22&appVersionName=%@&appPackageName=%@&deviceId=%@",USER_CID,SystemManager.appVersion,SystemManager.appVersion,SystemManager.appBundle,SystemManager.deviceID];
    HICNetModel *netModel = [[HICNetModel alloc] initWithURL:urlStr  params:dic];
    netModel.contentType = HTTPContentTypeJsonType;
    netModel.urlType = DefaultExamURLType;
    netModel.method = HTTPMethodPOST;
    [NetManager sentHTTPRequest:netModel success:^(NSDictionary * _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
    
}

+ (void)exercisesList:(NSDictionary *)dic success:(Success)success{
    
    HICNetModel *netModel = [[HICNetModel alloc]initWithURL:EXERCISES_LIST  params:dic];
    netModel.contentType = HTTPContentTypeWwwFormType;
    netModel.urlType = DefaultExamURLType;
    netModel.method = HTTPMethodGET;
    [NetManager sentHTTPRequest:netModel success:^(NSDictionary * _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

+ (void)courseRelatedRecommendation:(NSDictionary *)dic success:(Success)succes{
    
    HICNetModel *netModel = [[HICNetModel alloc]initWithURL:RECOMMEND_LIST  params:dic];
    netModel.contentType = HTTPContentTypeWwwFormType;
    netModel.urlType = DefaultExamURLType;
    netModel.method = HTTPMethodGET;
    [NetManager sentHTTPRequest:netModel success:^(NSDictionary * _Nonnull responseObject) {
        succes(responseObject);
    } failure:^(NSError * _Nonnull error) {

    }];
}
+ (void)commentBack:(NSDictionary *)dic success:(Success)succes {
    HICNetModel *netModel = [[HICNetModel alloc] initWithURL:COMMENT_REPLIES  params:dic];
    netModel.contentType = HTTPContentTypeJsonType;
    netModel.urlType = DefaultCommentURLType;
    [NetManager sentHTTPRequest:netModel success:^(NSDictionary * _Nonnull responseObject) {
        succes(responseObject);
    } failure:^(NSError * _Nonnull error) {
        DDLogDebug(@"error");
    }];
}

+ (void)setToImportantClicked:(NSDictionary *)dic url:(NSString *)url success:(Success)success failure:(Failure)failure{
    
    HICNetModel *netModel = [[HICNetModel alloc] initWithURL:url  params:dic];
    netModel.contentType = HTTPContentTypeJsonType;
    netModel.method = HTTPMethodPOST;
    netModel.urlType = DefaultExamURLType;
    [NetManager sentHTTPRequest:netModel success:^(NSDictionary * _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}
+ (void)collectionCourse:(NSNumber *)action dic:(NSDictionary *)dic success:(Success)succes failure:(Failure)failure {
    
    NSString *url = [NSString stringWithFormat:@"%@?action=%@",KLD_COLLECTION,action];
    HICNetModel *netModel = [[HICNetModel alloc] initWithURL:url  params:dic];
    netModel.contentType = HTTPContentTypeJsonType;
    netModel.method = HTTPMethodPOST;
    netModel.urlType = DefaultExamURLType;
    [NetManager sentHTTPRequest:netModel success:^(NSDictionary * _Nonnull responseObject) {
        succes(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}
+ (void)thumbupCourse:(NSNumber *)action dic:(NSDictionary *)dic success:(Success)succes failure:(Failure)failure{
    NSString *url = [NSString stringWithFormat:@"%@?action=%@",KLD_THUMBUP,action];
    HICNetModel *netModel = [[HICNetModel alloc] initWithURL:url  params:dic];
    netModel.contentType = HTTPContentTypeJsonType;
    netModel.method = HTTPMethodPOST;
    netModel.urlType = DefaultExamURLType;
    [NetManager sentHTTPRequest:netModel success:^(NSDictionary * _Nonnull responseObject) {
        succes(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

+ (void)examCenterList:(NSDictionary *)dic success:(Success)success failure:(Failure)failure{
    
    HICNetModel *netModel = [[HICNetModel alloc] initWithURL:EXAM_CENTER_LIST  params:dic];
    netModel.contentType = HTTPContentTypeJsonType;
    netModel.method = HTTPMethodGET;
    netModel.urlType = DefaultExamURLType;
    [NetManager sentHTTPRequest:netModel success:^(NSDictionary * _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}
+ (void)examStatesNum:(Success)success{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
       [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSMutableDictionary *params = [NSMutableDictionary new];
//    [params setValue:@1859955887 forKey:@"customerId"];
    HICNetModel *netModel = [[HICNetModel alloc]initWithURL:EXAM_STATUS_COUNT params:params];
    netModel.urlType = DefaultExamURLType;
    netModel.contentType = HTTPContentTypeWwwFormType;
    netModel.method = HTTPMethodGET;
    [NetManager sentHTTPRequest:netModel success:^(NSDictionary * _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

+ (void)checkAppUpdate:(Success)success failure:(Failure)failure{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:SystemManager.appBundle forKey:@"packageName"];
    [dic setValue:HICAPPVersionCode forKey:@"currentVersion"];
    [dic setValue:@"1" forKey:@"statCode"];
    [dic setValue:@"1" forKey:@"postCode"];
    [dic setValue:@(0) forKey:@"checkType"];
    
    [dic setValue:[HICCommonUtils appBundleIden] == HICAppBundleIdenZhiYu ? @"1" : @"0" forKey:@"format"];
    HICNetModel *netModel = [[HICNetModel alloc] initWithURL:APP_UPGRADE  params:dic];
    netModel.contentType = HTTPContentTypeJsonType;
    netModel.urlType = DefaultAppUpgrade;
    netModel.responseType = [HICCommonUtils appBundleIden] == HICAppBundleIdenZhiYu ? ResponseTypeJSONType : ResponseTypeXMLType;
    [NetManager sentHTTPRequest:netModel success:^(NSDictionary * _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        DDLogDebug(@"error %ld", (long)error.code);
        failure(error);
    }];
}

+ (void)refreshToken:(Success)success failure:(Failure)failure {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:USER_REFRESH_TOKEN forKey:@"refreshToken"];
    HICNetModel *netModel = [[HICNetModel alloc] initWithURL:ACCOUNT_TOKEN_REFRESH params:dic];
    netModel.contentType = HTTPContentTypeWwwFormType;
    netModel.method = HTTPMethodPOST;
    [NetManager sentHTTPRequest:netModel success:^(NSDictionary * _Nonnull responseObject) {
        // 刷新token成功
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

+ (void)logout:(Success)success failure:(Failure)failure {
    
    HICNetModel *netModel = [[HICNetModel alloc] initWithURL:ACCOUNT_LOGOUT  params:nil];
    netModel.contentType = HTTPContentTypeWwwFormType;
    netModel.method = HTTPMethodPOST;
    [NetManager sentHTTPRequest:netModel success:^(NSDictionary * _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

+ (void)confirmBtnClickedWithPass:(NSDictionary *)dic success:(Success)success failure:(Failure)failure{
    HICNetModel *netModel = [[HICNetModel alloc] initWithURL:CHANGE_PASS_BYTOKEN  params:dic];
    netModel.contentType = HTTPContentTypeWwwFormType;
    netModel.method = HTTPMethodPOST;
    [NetManager sentHTTPRequest:netModel success:^(NSDictionary * _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

+(void)changePwd:(NSDictionary *)dic success:(Success)success{
    HICNetModel *netModel = [[HICNetModel alloc] initWithURL:CHANGE_PASS  params:dic];
    netModel.contentType = HTTPContentTypeWwwFormType;
    netModel.method = HTTPMethodPOST;
    [NetManager sentHTTPRequest:netModel success:^(NSDictionary * _Nonnull responseObject) {
        [HICToast showWithText:NSLocalizableString(@"changePwdSuccess", nil)];
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        [HICToast showWithText:[error.userInfo valueForKey:@"error_desc"] ? [error.userInfo valueForKey:@"error_desc"] : @"Net error!"];
    }];
    
}
+(void)getMsgFromSever:(NSString *)phone success:(Success)success failure:(Failure)failure {
    
    // 1. 获取网络连接地址
    NSString *urlStr = ACCOUNT_SEND_VERIFIYCODE;

    // 2. 拼接自己需要的请求参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:phone forKey:@"mobilephone"];

    HICNetModel *model = [[HICNetModel alloc] initWithURL:urlStr params:[dic copy]];
    model.contentType = HTTPContentTypeWwwFormType;
    model.method = HTTPMethodPOST;
    [NetManager sentHTTPRequest:model success:^(NSDictionary * _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

+ (void)confirmBtnClickedWithAccount:(NSDictionary *)dic success:(Success)success failure:(Failure)failure{
    HICNetModel *netModel = [[HICNetModel alloc]initWithURL:ACCOUNT_LOGIN params:dic];
    netModel.method = HTTPMethodPOST;
    netModel.contentType = HTTPContentTypeWwwFormType;
    [NetManager sentHTTPRequest:netModel success:^(NSDictionary * _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}
+ (void)getPWDSystem:(Success)success failure:(Failure)failure{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:@"PWD_GEN_RULE" forKey:@"paramCode"];
    HICNetModel *model = [[HICNetModel alloc] initWithURL:SYSTEM_PWD params:dic];
    model.urlType = DefaultAccURLType;
    model.contentType = HTTPContentTypeJsonType;
    model.method = HTTPMethodGET;
    [NetManager sentHTTPRequest:model success:^(NSDictionary * _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        failure(error);
    }];
}

+ (void)requestAgreement:(Success)success {
    NSDictionary *dic = @{@"terminalType":@1};
    HICNetModel *netModel = [[HICNetModel alloc]initWithURL:PRIVACY_AGREEMENT params:dic];
    netModel.contentType = HTTPContentTypeJsonType;
    netModel.urlType = DefaultExamURLType;
    [NetManager sentHTTPRequest:netModel success:^(NSDictionary * _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        [HICToast showWithText:[error.userInfo valueForKey:@"error_desc"] ? [error.userInfo valueForKey:@"error_desc"] : @"Net error!"];
    }];
}

+(void)loadDataUserRoleChangeRoot:(NSDictionary *)dic success:(Success)success failure:(Failure)failure {
    
    HICNetModel *model = [[HICNetModel alloc] initWithURL:@"heduopapi/common/getMenus" params:dic];
    model.contentType = HTTPContentTypeWwwFormType;
    model.urlType = DefaultCommentURLType;
    
    [NetManager sentHTTPRequest:model success:^(NSDictionary * _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        DDLogDebug(@"[HIC]-[RoleManager] --- 网络数据角色信息请求失败！");
        failure(error);
    }];
}

+(void)loadDataTabMenuChangeRoot:(Success)success failure:(Failure)failure {

    HICNetModel *model = [[HICNetModel alloc] initWithURL:@"heduapi/app_api/v1.0/course_kld/get_bottom_nav" params:@{}];
    model.contentType = HTTPContentTypeWwwFormType;
    model.urlType = DefaultCommentURLType;

    [NetManager sentHTTPRequest:model success:^(NSDictionary * _Nonnull responseObject) {
        success(responseObject);
    } failure:^(NSError * _Nonnull error) {
        DDLogDebug(@"[HIC]-[RoleManager] --- 网络数据角色信息请求失败！");
        failure(error);
    }];
}
+ (void)getSecurityInfo:(Success)success failure:(Failure)failure{
    if (!USER_CID || !USER_TOKEN) {
        // 不存在的情况下直接返回
        return;
    }
    HICNetModel *model = [[HICNetModel alloc] initWithURL:ACCOUNT_SECURITY params:@{@"terminalType":@1}];
       model.contentType = HTTPContentTypeWwwFormType;
       model.urlType = DefaultExamURLType;
        model.method = HTTPMethodGET;
       [NetManager sentHTTPRequest:model success:^(NSDictionary * _Nonnull responseObject) {
           success(responseObject);
       } failure:^(NSError * _Nonnull error) {
           DDLogDebug(@"[HIC]-[RoleManager] --- 网络安全信息请求失败！");
           failure(error);
       }];
}

@end
