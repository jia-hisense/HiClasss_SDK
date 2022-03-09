//
//  HICSystemManager.m
//  HiClass
//
//  Created by Eddie Ma on 2020/1/15.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <HIClassSwift_SDK/HIClassSwift_SDK-Swift.h>
#import "HICSystemManager.h"
#import "HICUpgradeView.h"
#include <sys/sysctl.h>
#import <sys/socket.h>
#include <net/if_dl.h>
#import <net/if.h>

@implementation HICSystemManager

+ (instancetype)shared {
    static HICSystemManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (NSString *)deviceID {
    HICSDKHelper *helper = [[HICSDKHelper alloc] init];
    return [helper getDeviceID];
}

- (NSString *)randomStr {
    HICSDKHelper *helper = [[HICSDKHelper alloc] init];
    return [helper getRandomStrWithLength:32];
}

- (NSString *)appVersion {
    return HIC_Class_Version;
}

- (NSString *)appBuild {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

- (NSString *)appName {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
}

- (NSString *)appBundle {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
}

- (NSString *)appKey {
    return APP_KEY;
}

- (NSString *)appSecret {
    return APP_SECRET;
}

- (NSString *)macAddress {
    int mib[6];
    size_t len;
    char *buf;
    unsigned char *ptr;
    struct if_msghdr *ifm;
    struct sockaddr_dl *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        free(buf);
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    
    // MAC地址带冒号
    NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    
    //        // MAC地址不带冒号
    //        NSString *outstring = [NSString
    //            stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr + 1), *(ptr + 2), *(ptr + 3), *(ptr + 4), *(ptr + 5)];
    
    free(buf);
    
    return [outstring uppercaseString];
}
- (void)setDomainsFromSystem {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"HICCommentDomain"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"HICAccDomain"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"HICExamDomain"];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        HICNetModel *model = [[HICNetModel alloc] initWithURL:@"" params:nil];
        model.urlType = DefaultSystemConfigType;
        model.contentType = HTTPContentTypeWwwFormType;
        [NetManager sentHTTPRequest:model success:^(NSDictionary * _Nonnull responseObject) {
            NSDictionary *data = [responseObject valueForKey:@"data"];
            NSArray *allKey = [data allKeys];
            if ([allKey containsObject:@"commentDomain"]) {
                // 系统下发的评论域名
                NSString *url = (NSString *)[data valueForKey:@"commentDomain"];
                if ([NSString isValidStr:url]) {
                    [[NSUserDefaults standardUserDefaults] setValue:url forKey:@"HICCommentDomain"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
            }
            if ([allKey containsObject:@"loginDomain"]) {
                // 系统下发的登录域名
                NSString *url = (NSString *)[data valueForKey:@"loginDomain"];
                if ([NSString isValidStr:url]) {
                    [[NSUserDefaults standardUserDefaults] setValue:url forKey:@"HICAccDomain"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
            }
            if ([allKey containsObject:@"systemDomain"]) {
                // 系统下发的考试域名
                NSString *url = (NSString *)[data valueForKey:@"systemDomain"];
                if ([NSString isValidStr:url]) {
                    [[NSUserDefaults standardUserDefaults] setValue:url forKey:@"HICExamDomain"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
            }
        } failure:^(NSError * _Nonnull error) {
        }];
    });
}

- (void)checkAppUpdate {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [HICAPI checkAppUpdate:^(NSDictionary * _Nonnull responseObject) {
            NSInteger latestVersion = [[responseObject valueForKey:@"latestVersion"] integerValue];
            
            if ([responseObject valueForKey:@"updateFlag"] && [[responseObject valueForKey:@"updateFlag"] isKindOfClass:[NSNumber class]]) {
                SystemManager.updateFlag = [responseObject valueForKey:@"updateFlag"];
            }else if([responseObject valueForKey:@"updateFlag"] && [[responseObject valueForKey:@"updateFlag"] isKindOfClass:[NSString class]]){
                SystemManager.updateFlag = [[responseObject valueForKey:@"updateFlag"] toNumber] ;
            }else{
                SystemManager.updateFlag = @-1;
            }
            if ([[responseObject valueForKey:@"downloadUrl"] isKindOfClass:[NSString class]]) {
                if ([NSString isValidStr:[responseObject valueForKey:@"downloadUrl"]]) {
                    self.downloadUrl = [responseObject valueForKey:@"downloadUrl"];
                }
            }
            [[NSUserDefaults standardUserDefaults] setInteger:latestVersion forKey:@"sysAppVersion"];
            
            if (latestVersion > [HICAPPVersionCode integerValue] && ([SystemManager.updateFlag isEqualToNumber:@1] ||[SystemManager.updateFlag isEqualToNumber:@2])){
                // 更新
                NSString *latestVersionName = [responseObject valueForKey:@"latestVersionName"];
                NSString *content = [responseObject valueForKey:@"versionDesc"];
                NSString *fileSize = [NSString fileSizeWith:[[responseObject valueForKey:@"fileSize"] floatValue]];
                NSString *time = [HICCommonUtils timeStampToReadableDate:[NSNumber numberWithInt:[[NSDate date] timeIntervalSince1970]] isSecs:YES format:@"yyyy-MM-dd"];
                [self upgradeViewWithVersion:latestVersionName size:fileSize time:time content:content];
            }else {
                if (self.isShowToast) {
                    [HICToast showWithText:NSLocalizableString(@"latestVersion", nil)];
                    self.isShowToast = NO; // 重置一下状态
                }
            }
        } failure:^(NSError * _Nonnull error) {
            if (!error.code) {
                if (self.isShowToast) {
                    [HICToast showWithText:NSLocalizableString(@"latestVersion", nil)];
                    self.isShowToast = NO; // 重置一下状态
                }
            }else{
                if (self.isShowToast) {
                    if (error.code == 205001) {
                        [HICToast showWithText:NSLocalizableString(@"latestVersion", nil)];
                        self.isShowToast = NO; // 重置一下状态
                    }else{
                        [HICToast showWithText:error.userInfo[@"error_desc"]];
                        self.isShowToast = NO; // 重置一下状态
                    }
                }
            }
        }];
    });
}

- (void)upgradeViewWithVersion:(NSString *)version size:(NSString *)size time:(NSString *)time content:(NSString *)content{
//    HICUpgradeView *upView = [[HICUpgradeView alloc] initWithVersion:version size:size time:time content:content downloadUrl:self.downloadUrl ? self.downloadUrl:@""];
//    upView.frame = CGRectMake(0, 0, HICSDK_ScreenWidth, HICSDK_ScreenHeight);
//    [upView show];
//    UIViewController *currentVC = [HICSDKCommonUtils getViewController];
//    [currentVC.view addSubview:upView];
}

- (NSString *)getAESStringWithStrgetAESStringWithStr:(NSString *)str {
    HICSDKHelper *helper = [[HICSDKHelper alloc] init];
    return [helper getAESStringWithStr:str];
}

- (NSString *)getMD5AndBase64StringWithStrgetAESStringWithStr:(NSString *)str {
    HICSDKHelper *helper = [[HICSDKHelper alloc] init];
    return [helper getMD5AndBase64StringWithStr:str];
}
@end
