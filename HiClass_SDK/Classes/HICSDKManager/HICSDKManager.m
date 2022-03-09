//
//  HICSDKManager.m
//  HIClass_SDK
//
//  Created by 铁柱， on 2020/8/26.
//  Copyright © 2020 铁柱，. All rights reserved.
//

#import "HICSDKManager.h"
#import "HICMyBaseInfoModel.h"
#import "HICSDKLoadingVC.h"
#import "HICBaseNavigationViewController.h"
#import "MainTabBarVC.h"

@implementation HICSDKManager

+ (instancetype)shared {
    static HICSDKManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [[self alloc] init];
        }
    });
    return manager;
}

- (void)loginWithToken:(NSString *)token andUserId:(NSNumber *)userId success:(void (^)(BOOL issuccess))success failure:(void (^)(NSInteger code, NSString * errorStr))failure {
    NSMutableDictionary *postModel = [NSMutableDictionary new];
    [postModel setValue:@1201 forKey:@"thirdPlatformId"];
    [postModel setValue:@1 forKey:@"thirdLoginType"];
    [postModel setValue:token forKey:@"thirdToken"];
    [postModel setValue:@"app" forKey:@"loginType"];
    [postModel setValue:@"9765b96150475e4a7753dfab7622e707" forKey:@"extInfo"];
    [postModel setValue:userId forKey:@"userId"];
    [postModel setValue:@"1.0" forKey:@"version"];
    [postModel setValue:@1 forKey:@"sourceType"];
    [postModel setValue:@"xtw" forKey:@"brandCode"];
    [postModel setValue:HICSystemManager.shared.deviceID forKey:@"deviceId"];
    [postModel setValue:HICSystemManager.shared.randomStr forKey:@"randStr"];
    
    HICNetModel *netModel = [[HICNetModel alloc]initWithURL:ACCOUNT_THIRD_LOGIN  params:postModel];
    netModel.contentType = HTTPContentTypeWwwFormType;
    netModel.method = HTTPMethodPOST;
    [HICNetManager.shared  sentHTTPRequest:netModel success:^(NSDictionary * _Nonnull responseObject) {
        if (responseObject) {
            [self initVC];
            success(YES);
            [HICLoginManager.shared saveUserInfo:responseObject];
            [self initBaseInfo];
            [self configHICModuleWithDic:responseObject];
        }
    } failure:^(NSError * _Nonnull error) {
        failure(error.code,error.description);
        [HICToast showWithText:[NSString stringWithFormat:@"%@",error.description]];
    }];
}

- (void)loginWithAccount:(NSString *)account password:(NSString *)password success:(void(^)(BOOL issuccess))success failure:(void(^)(NSInteger code, NSString * errorStr))failure;{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"loginName"] = account;
    password = [HICSystemManager.shared getAESStringWithStr:password];
    params[@"password"] = password;
    params[@"registType"] = @"2";
    HICNetModel *netModel = [[HICNetModel alloc]initWithURL:ACCOUNT_LOGIN params:params];
    netModel.method = HTTPMethodPOST;
    netModel.contentType = HTTPContentTypeWwwFormType;
    [HICNetManager.shared sentHTTPRequest:netModel success:^(NSDictionary * _Nonnull responseObject) {
        [HICLoginManager.shared saveUserInfo:responseObject];
        [self initBaseInfo];
        [self configHICModuleWithDic:responseObject];
    } failure:^(NSError * _Nonnull error) {
        [HICToast showWithText:[error.userInfo valueForKey:@"error_desc"] ? [error.userInfo valueForKey:@"error_desc"] : @"Net error!"];
    }];
}

- (void)loginWithPhone:(NSString *)phone password:(NSString *)password success:(void(^)(BOOL issuccess))success failure:(void(^)(NSInteger code, NSString * errorStr))failure;{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"loginName"] = phone;
    password = [HICSystemManager.shared getMD5AndBase64StringWithStrgetAESStringWithStr:password];
    params[@"password"] = password;
    params[@"registType"] = @"1";
    HICNetModel *netModel = [[HICNetModel alloc]initWithURL:ACCOUNT_LOGIN params:params];
    netModel.method = HTTPMethodPOST;
    netModel.contentType = HTTPContentTypeWwwFormType;
    
    [NetManager sentHTTPRequest:netModel success:^(NSDictionary * _Nonnull responseObject) {
        [HICLoginManager.shared saveUserInfo:responseObject];
        [self initBaseInfo];
        [self configHICModuleWithDic:responseObject];
    } failure:^(NSError * _Nonnull error) {
        [HICToast showWithText:[error.userInfo valueForKey:@"error_desc"] ? [error.userInfo valueForKey:@"error_desc"] : @"Net error!"];
    }];
}

- (void)initBaseInfo {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableDictionary *dic = [NSMutableDictionary new];
        [dic setValue:@1 forKey:@"terminalType"];
        //        [dic setValue:@1831037005 forKey:@"customerId"];
        HICNetModel *netModel = [[HICNetModel alloc]initWithURL:MY_FIRST_PAGE_INFO params:dic];
        netModel.urlType = DefaultExamURLType;
        netModel.contentType = HTTPContentTypeJsonType;
        netModel.method = HTTPMethodGET;
        [HICNetManager.shared sentHTTPRequest:netModel success:^(NSDictionary * _Nonnull responseObject) {
            if (responseObject[@"data"] ) {
                HICMyBaseInfoModel *baseInfoModel = [HICMyBaseInfoModel mj_objectWithKeyValues:responseObject[@"data"][@"baseInfo"]];
                [[NSUserDefaults standardUserDefaults] setValue:baseInfoModel.name forKey:@"HICUSER_NAME"];
            }
        } failure:^(NSError * _Nonnull error) {
        }];
    });
}


- (void)applicationDidEnterBackground {
    ////调用这句,防止应用在进入后台后所有任务被终止
    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{}];
}
- (void)applicationWillEnterForeground {
    
}
- (void)backApp {
    if (self.backBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.backBlock();
        });
    }
}
- (void)needSignAgain{
    if (self.logBlock) {
        self.logBlock();
    }
}

- (void)configHICModuleWithDic:(NSDictionary *)responseObject{
    if ([HICLoginManager.shared isLoggedIn]) {
        [HICRoleManager.shareInstance loadDataUserDetailAndRoleChangeRootBlock:^(BOOL isSuccess) {
//            if (isSuccess) {
//                [HICCommonUtils setRootViewToRoleMainTabVC];
//            }else {
//                [HICCommonUtils setRootViewToMainTabVC];
//            }
            [HICCommonUtils setRootViewToMainVC];
        }];
    } else {
        [HICToast showWithText:@"token失败"];
    }
}

/***********************************************************************/
- (void)handleAppCrash {
    // 抓取崩溃
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    if (APP_CRASH_INFO) {
#ifdef DEBUG
        
#else
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setDictionary:[LogManager getExcLogEventDictWithType:HIC_EXCLOG_APP_TERMINATION]];
        [params setValue:@"app crash" forKey:@"operationname"];
        [params setValue:APP_CRASH_REASON forKey:@"exceptionmessage"];
        [params setValue:APP_CRASH_NAME forKey:@"exceptionname"];
        [params setValue:APP_CRASH_STACK forKey:@"exceptioninfo"];
        //                NSLog(@"%@ [Log]App Crash Reason: %@",logName, params);
        [LogManager reportExcLogWithDict:params];
#endif
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"HICappCrashInfo"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"HICappCrashName"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"HICappCrashReason"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"HICappCrashStackArray"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

// 配置本地日志输出参数
- (void)configLogInput {
    [DDLog addLogger:[DDOSLogger sharedInstance]]; // Uses os_log
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init]; // File Logger
    fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
    fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
    [DDLog addLogger:fileLogger];
}

void uncaughtExceptionHandler(NSException *exception) {
    // 异常的堆栈信息
    NSArray *stackArray = [exception callStackSymbols];
    NSString *stackArrayStr = [NSString stringWithFormat:@"%@", stackArray];
    // 出现异常的原因
    NSString *reason = [exception reason];
    // 异常名称
    NSString *name = [exception name];
    NSString *exceptionInfo = [NSString stringWithFormat:@"Exception reason：%@\nException name：%@\nException stack：%@",name, reason, stackArray];
    //保存到本地  --  当然你可以在下次启动的时候，上传这个log
    [exceptionInfo writeToFile:[NSString stringWithFormat:@"%@/Documents/error.log",NSHomeDirectory()]  atomically:YES encoding:NSUTF8StringEncoding error:nil];
    [[NSUserDefaults standardUserDefaults] setValue:exceptionInfo forKey:@"HICappCrashInfo"];
    [[NSUserDefaults standardUserDefaults] setValue:name forKey:@"HICappCrashName"];
    [[NSUserDefaults standardUserDefaults] setValue:reason forKey:@"HICappCrashReason"];
    [[NSUserDefaults standardUserDefaults] setValue:stackArrayStr forKey:@"HICappCrashStackArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
//-(void)listenNetWorkingStatus {
//    [GLobalRealReachability startNotifier];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(networkChanged:)
//                                                 name:kRealReachabilityChangedNotification
//                                               object:nil];
//    ReachabilityStatus status = [GLobalRealReachability currentReachabilityStatus];
//    [self realNetworkingStatus:status];
//}
//
//- (void)networkChanged:(NSNotification *)notification {
//    RealReachability *reachability = (RealReachability *)notification.object;
//    ReachabilityStatus status = [reachability currentReachabilityStatus];
//    [self realNetworkingStatus:status];
//}

//- (void)realNetworkingStatus:(ReachabilityStatus)status {
//    HICNetStatus netStatus;
//    switch (status) {
//        case RealStatusUnknown:
//            NSLog(@"~~~~~~~~~~~~~RealStatusUnknown");
//            netStatus = HICNetUnknown;
//            break;
//        case RealStatusNotReachable:
//            NSLog(@"~~~~~~~~~~~~~RealStatusNotReachable");
//            netStatus = HICNetNotReachable;
//            break;
//        case RealStatusViaWWAN:
//            NSLog(@"~~~~~~~~~~~~~RealStatusViaWWAN");
//            netStatus = HICNetWWAN;
//            break;
//        case RealStatusViaWiFi:
//            NSLog(@"~~~~~~~~~~~~~RealStatusViaWiFi");
//            netStatus = HICNetWiFi;
//            break;
//        default:
//            break;
//    }
//    if (HICSDKHICNetManager.shared .netStatus != netStatus) {
//        if (netStatus == HICNetUnknown || netStatus == HICNetNotReachable) {
//            [HICToast showWithText:@"无网络连接，请检查网络" bottomOffset:100];
//        }
//    }
//    HICSDKHICNetManager.shared .netStatus = netStatus;
//}
//
//- (void)startLocalServer {
//    NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
//    GCDWebDAVServer *davServer = [[GCDWebDAVServer alloc] initWithUploadDirectory:caches];
//    [davServer start];
//    NSLog(@"serverURL：%@", davServer.serverURL);
//}
-(void)getWebSDKInfo {
    [HiWebViewPerson sharePerson].getPublicValueBlock = ^NSDictionary * _Nullable(WebGetUserInfoType type, NSDictionary * _Nonnull param) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:param];
        NSString *returnStr;
        if (type == WebGetUserInfoToken) {
            returnStr = USER_TOKEN;
        }else if (type == WebGetUserInfoAppName) {
            returnStr = HICSystemManager.shared.appName;
        }else if (type == WebGetUserInfoAppVersion) {
            returnStr = HICSystemManager.shared.appVersion;
        }else if (type == WebGetUserInfoCustomerId) {
            returnStr = USER_CID;
        }else if (type == WebGetUserInfoAppPackName) {
            returnStr = HICSystemManager.shared.appBundle;
        }else if (type == WebGetUserInfoCustomerName) {
            returnStr = USER_CID;
        }else if (type == WebGetUserInfoAppVersionCode) {
            returnStr = @"1";
        }else if (type == WebGetUserInfoDeviceId) {
            returnStr = HICSystemManager.shared.deviceID;
        }
        [dic setValue:returnStr forKey:@"returnValue"];
        return [dic copy];
    };
}
- (void)initVC{
    //    [self configureBugly];
    // 处理崩溃日志544666666666666666667
    
    [self handleAppCrash];
    // 初始化推送SDK
    //        [self initJHKPushSDK: launchOptions];
    //设置网络请求
    //    [self configHttpRequest];
    // 设置系统状态栏
    //        if (@available(iOS 13.0, *)) {
    //            UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleDarkContent;
    //        } else {
    //            // Fallback on earlier versions
    //            UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleDefault;
    //        }
    //        [RoleManager getSecurityInfoBlock:^(BOOL isSuccess) {
    //            if (isSuccess) {
    //                [HICCommonUtils handleSecurityScreen];
    //            }
    //        }];
    //关闭selfsizng
    if (@available(iOS 11.0, *)) {
        UITableView.appearance.estimatedRowHeight = 0;
        UITableView.appearance.estimatedSectionFooterHeight = 0;
        UITableView.appearance.estimatedSectionHeaderHeight = 0;
    }
    
    // 获取系统配置的Domain
    [HICSystemManager.shared setDomainsFromSystem];
    
    
    // 配置本地日志输出参数
    [self configLogInput];
    
    // WebSDK的通用方法
    [self getWebSDKInfo];
    
    // 引导图 - 放置的当前控制器 会出现更换后消失的现象 -- 因此 更改一下位置。
    //
    //        [self listenNetWorkingStatus];
    //
    //        [self startLocalServer];
    
    // FIXME: 发布版本需要更改高德地图的key
    // 高德地图设置 -- 正式 @"0f81b003cba73014843ba340c19b698f"; - 测试 @"3b6bb37a977368a062f8d8abd9af8388"
    [AMapServices sharedServices].apiKey = @"333235c5dd03b5253ccfcb72fea2a70e";
    [OTPSignManager shareInstance]; // 初始化定位类，并且获取定位信息。 <先注释>
    
    
    NSMutableDictionary *report = [NSMutableDictionary new];
    [report setValuesForKeysWithDictionary:[LogManager getAppEventDictWithType:HIC_APP_START]];
    [LogManager reportAppStart];
}

@end

