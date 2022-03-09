//
//  HICNetManager.m
//  HiClass
//
//  Created by Eddie Ma on 2020/1/2.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICNetManager.h"
#import <HIClassSwift_SDK/HIClassSwift_SDK.h>
#import <iOS_CloudSDK_CPN/iOS_CloudSDK_CPN-Swift.h>

static NSString *logName = @"[HIC][NM]";

@implementation HICNetManager

+ (instancetype)shared {
    static HICNetManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (void)sentHTTPRequest:(HICNetModel *)model success:(Success)success failure:(Failure)failure {
    HICSDKHelper * helper = [[HICSDKHelper alloc] init];
//    NSString *domain = [NSString isValidStr:HIC_ACC_DOMAIN] ? HIC_ACC_DOMAIN : DEFAULT_ACC_DOMAIN;
    NSString *domain = DEFAULT_ACC_DOMAIN;
    // URL 的类型：账号，考试，评论，系统
    model.urlType = model.urlType ? model.urlType : DefaultAccURLType;
    if (model.urlType == DefaultExamURLType) {
        domain = DEFALUT_EXAM_DOMAIN;
    } else if (model.urlType == DefaultCommentURLType) {
        domain = DEFALUT_COMMENTS_DOMAIN;
    } else if (model.urlType == DefaultAppUpgrade) {
        domain = APP_UPGRADE_DOMAIN;
    } else if (model.urlType == DefaultAppPush) {
        domain = PUSH_DOMAIN;
    }

    // URL
    NSString *strURL = model.url;
    strURL = strURL ? strURL : @"";
    if ([NSString isValidStr:strURL]) {
        strURL = [NSString stringWithFormat:@"%@/%@", domain, strURL];
    }else{
        strURL = domain;
    }

    // Params
    BOOL needToken = [strURL containsString:ACCOUNT_TOKEN_REFRESH] ? NO : YES;
    NSDictionary *temParams = model.params;
    if ([temParams objectForKey:@"sourceType"]) {
        DDLogDebug(@"sdhklsajdhsl;adhklas%@",temParams[@"sourceType"]);
    }
    
    temParams = temParams ? [self allParams:temParams needToken:needToken] : [self allParams:@{} needToken:needToken];
    // Method
    model.method = model.method == HTTPMethodGET ? model.method : HTTPMethodPOST;
    // contentType
    model.contentType = model.contentType ? model.contentType : HTTPContentTypeWwwFormType;
    // needSignDownCheck
    BOOL needSignDownCheckBool = model.needSignDownCheck == 1 ? YES : NO;
    // signType
    model.signType = model.signType ? model.signType : SignTypeGatewaySign;
    // publicKey
    model.publicKey = model.publicKey ? model.publicKey : DEFAULT_PUBLIC_KEY;
    // salt
    model.salt = model.salt ? model.salt : DEFAULT_SALT;
    // signInHeaderBool
    BOOL signInHeaderBool = model.signInHeader == 1 ? NO : YES;
    // responseType
    model.responseType = model.responseType ? model.responseType : ResponseTypeJSONType;
    // timeout
    model.timeout = model.timeout ? model.timeout : 20;
    // formatSpecialCharacters
    BOOL formatSpecialCharactersBool = model.formatSpecialCharacters == 1 ? YES : NO;
    
    DDLogDebug(@"%@ HTTP Request URL: %@, method: %ld, contentType: %ld, signType: %ld, needSignDownCheckBool: %@", logName, strURL, (long)model.method, (long)model.contentType, (long)model.signType, needSignDownCheckBool ? @"Need" : @"NO need");
    if ([strURL hasSuffix:@".com"]) {
        return;
    }
    if ([temParams objectForKey:@"sourceType"]) {
           DDLogDebug(@"sdhklsajdhsl;adhklas%@",temParams[@"sourceType"]);
       }
    [helper universalHTTPRequestWithUrl:strURL params:temParams method:model.method contentType:model.contentType needSignDownCheck:needSignDownCheckBool signType:model.signType public_key:model.publicKey salt:model.salt signInHeader:signInHeaderBool responseType:model.responseType timeout:model.timeout formatSpecialCharacters:formatSpecialCharactersBool block:^(BOOL suc, id _Nonnull result) {
        if (result == nil) {
            DDLogDebug(@"%@ HTTP Request FAILED, URL: %@, RESULT: Data parse failed", logName, strURL);
            NSError *error = [[NSError alloc] initWithDomain:model.url code:-1 userInfo:@{@"error_code":@"-1",@"error_desc":@"Data parse failed"}];
            [self reportExcLogWithErrorCode:@(error.code) errorDesc:@"Data parse failed" errorType:HIC_NET_ERROR_FROM_LOCAL];
            failure(error);
            return;
        }
        if (suc) {
            NSDictionary *dic;
            if (![result isKindOfClass:NSDictionary.class]) {
                dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
            } else {
                dic = result;
            }
            if ([strURL containsString:@"upgrade/check_app_version"]) {
                NSDictionary *response = [dic valueForKey:@"response"];
                if (response) {
                    dic = response;
                }
            }
            NSNumber *resultCode;
            if ([[dic valueForKey:@"resultCode"] isKindOfClass:NSString.class]) {
                resultCode = [[dic valueForKey:@"resultCode"] toNumber];
            } else {
                resultCode = (NSNumber *)[dic valueForKey:@"resultCode"];
            }
            if ([resultCode isEqual:@(0)]) {
                DDLogDebug(@"%@ HTTP Request SUCCESS, URL: %@, RESULT: %@", logName, strURL, dic);
                success(dic);
            } else {
                DDLogDebug(@"%@ HTTP Request FAILED, URL: %@, RESULT: %@", logName, strURL, dic);
                NSNumber * errorCode = (NSNumber *)[dic valueForKey:@"errorCode"];
                NSString * errorDesc = [dic valueForKey:@"errorDesc"];
                NSNumber *tokenErrorCode = (NSNumber *)[dic valueForKey:@"tokenErrorCode"];
                if (tokenErrorCode == nil) {
                    NSDictionary *code = [dic valueForKey:@"error"];
                    if ([code isKindOfClass:[NSDictionary class]]) {
                        NSNumber *roleCode = [code valueForKey:@"errorCode"];
                        if ([roleCode integerValue] == 40005) {
                            NSError *err = [NSError errorWithDomain:NSURLErrorDomain code:40005 userInfo:nil];
                            failure(err);
                            return;
                        }
                    }
                }
                
                if ([tokenErrorCode integerValue] >= 1) { // accessToken is illegal需要重新登录
                    [HICCommonUtils setRootViewToLoginVC];
                    [HICToast showWithText:NSLocalizableString(@"abnormalAccountPrompt", nil)];
                    return;
                }
                    if (!errorCode) {
                    errorCode = @(-1);
                }
                if (![NSString isValidStr:errorDesc]) {
                    errorDesc = @"Unknown error";
                }
                
                
                
                if ([errorCode integerValue] == HICAccSysError) {
                    errorDesc = NSLocalizableString(@"systemErrorPromot", nil);
                } else if ([errorCode integerValue]  == HICAccNoAccount) {
                    errorDesc = NSLocalizableString(@"accountNotExistPrompt", nil);
                } else if ([errorCode integerValue]  == HICAccPassWrong) {
                    NSDictionary *extraInfo = [dic valueForKey:@"extraInfo"];
                    NSNumber *leftTimes = (NSNumber *)[extraInfo valueForKey:@"leftTimes"];
                    if (leftTimes && [leftTimes integerValue] != -1) {
                        NSString *hintStr = [NSString stringWithFormat:@"%@%@%@", NSLocalizableString(@"passwordMistakePrompt", nil),leftTimes,NSLocalizableString(@"timeChance", nil)];
                        errorDesc = hintStr;
                    } else {
                        errorDesc = NSLocalizableString(@"passwordMistake", nil);
                    }
                } else if ([errorCode integerValue]  == HICAccAccountBanned) {
                    errorDesc = NSLocalizableString(@"accountDisabledPrompt", nil);
                } else if ([errorCode integerValue]  == HICAccAccountLocked) {
                    NSDictionary *extraInfo = [dic valueForKey:@"extraInfo"];
                    NSNumber *leftUnlockTime = (NSNumber *)[extraInfo valueForKey:@"leftUnlockTime"];
                    if (leftUnlockTime && [leftUnlockTime integerValue] != -1) {
                        NSString *hintStr = [NSString stringWithFormat:@"%@%@%@", NSLocalizableString(@"accountHasBeenLockedPrompt", nil),[HICCommonUtils getHmsFromSecond:leftUnlockTime],NSLocalizableString(@"retryAfter", nil)];
                        errorDesc = hintStr;
                    } else {
                        errorDesc = NSLocalizableString(@"accountHasBeenLocked", nil);
                    }
                } else if ([errorCode integerValue]  == HICAccInvalidParam) {
                    errorDesc = NSLocalizableString(@"requiredInputInformationMissingPrompt", nil);
                } else if ([errorCode integerValue]  == HICAccUseOA) {
                    errorDesc = NSLocalizableString(@"pleaseLoginUsingOAAccount", nil);
                } else if ([errorCode integerValue]  == HICAccIDExisted) {
                    errorDesc = NSLocalizableString(@"idNumberAlreadyExists", nil);
                } else if ([errorCode integerValue]  == HICAccDataExisted) {
                    errorDesc = NSLocalizableString(@"dataAlreadyExists", nil);
                } else if ([errorCode integerValue]  == HICAccAuthCodeWrong) {
                    errorDesc = NSLocalizableString(@"InvalidVerificationCode", nil);
                } else if ([errorCode integerValue]  == HICAccAuthCodeMoreThan5Times) {
                    errorDesc = NSLocalizableString(@"verificationCodeFailsMoreThanFiveTimes", nil);
                } else if ([errorCode integerValue]  == HICAccAuthCodeNotEqual) {
                    errorDesc = NSLocalizableString(@"verificationCodesAreInconsistent", nil);
                }

                NSError *error = [[NSError alloc] initWithDomain:model.url code:errorCode.integerValue userInfo:@{@"error_code":errorCode,@"error_desc":errorDesc}];
                [self reportExcLogWithErrorCode:errorCode errorDesc:errorDesc errorType:HIC_NET_ERROR_FROM_SERVER];
                failure(error);
            }
        } else {
            DDLogDebug(@"%@ HTTP Request FAILED, URL: %@, RESULT: %@", logName, strURL, result);
            NSError *error = result;
            if (error.code != 205001 && error.code) {//当前已经是最新版本，不上报异常日志
                [self reportExcLogWithErrorCode:@(error.code) errorDesc:error.description errorType:HIC_NET_ERROR_FROM_LOCAL];
                failure(result);
            }else{
                failure(result);
            }
            
        }
    }];
}

- (NSDictionary *)allParams:(NSDictionary *)dic needToken:(BOOL)needToken {
    NSMutableDictionary *muDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
    [muDic setValue:SystemManager.deviceID forKey:@"deviceId"];
    [muDic setValue:@1 forKey:@"terminalType"];
    [muDic setValue:SystemManager.appVersion forKey:@"appVersion"];
    [muDic setValue:SystemManager.appVersion forKey:@"appVersionName"];
    [muDic setValue:HICAPPVersionCode forKey:@"appVersionCode"];
    [muDic setValue:SystemManager.appBundle forKey:@"appPackageName"];
    [muDic setValue:[NSNumber numberWithInt:[[NSDate date] timeIntervalSince1970]] forKey:@"timeStamp"];
    
    [muDic setValue:SystemManager.randomStr forKey:@"randStr"];
    if ([NSString isValidStr:USER_TOKEN] && needToken) {
        [muDic setValue:USER_TOKEN forKey:@"accessToken"];
    }
    // 账号子系统需要
    //信天翁单独请求判断
    if (![dic objectForKey:@"version"]) {
        [muDic setValue:SystemManager.appVersion forKey:@"version"];
    }
    if (![dic valueForKey:@"sourceType"]){
       [muDic setValue:@(1) forKey:@"sourceType"];
    }
    if (![dic objectForKey:@"brandCode"]) {
    [muDic setValue:@"his" forKey:@"brandCode"];
    }
    return muDic;
}

- (void)reportExcLogWithErrorCode:(NSNumber *)errorCode errorDesc:(NSString *)errorDesc errorType:(HICNetErrorType)errorType {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setDictionary:[LogManager getExcLogEventDictWithType:HIC_EXCLOG_API_FAILED]];
    [params setValue:errorType == HIC_NET_ERROR_FROM_SERVER ? @"server error" : @"local error" forKey:@"operationname"];
    [params setValue:@"Network failed" forKey:@"exceptionmessage"];
    [params setValue:errorCode forKey:@"exceptionname"];
    [params setValue:errorDesc forKey:@"exceptioninfo"];
    DDLogDebug(@"%@ [Log]API failed: %@, because: %@",logName, params, errorType == HIC_NET_ERROR_FROM_SERVER ? @"server error" : @"local error");
    [LogManager reportExcLogWithDict:params];
}


@end
