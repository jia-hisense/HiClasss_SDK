//
//  HiClass_SDKHeader.h
//  Pods
//
//  Created by 聚好看 on 2021/12/9.
//

#ifndef HiClass_SDKHeader_h
#define HiClass_SDKHeader_h
// 设置颜色的扩展
#import "UIColor+OtherCreateColor.h"
// 代码约束库
#import <Masonry/Masonry.h>
// 网络请求库
#import <AFNetworking/AFNetworking.h>
// 统一设置头文件
#import "HICHeader.h"

#import "HICEnum.h"

#import "HICCommonUtils.h"

#import "HICBaseViewController.h"

#import "NSString+HICUtilities.h"
#import "NSString+String.h"
#import "NSNumber+HICExtension.h"

#import "UIImage+HICExtension.h"

#import "NSAttributedString+HICAttributedStr.h"

#import "NSObject+DicTransModel.h"

#import "UIButton+HICExtendClickFrame.h"
#import "UIViewController+HICExtension.h"

#import "HICNetManager.h"
#import "HICAPI.h"

#import "HICLoginManager.h"

#import "HICToast.h"

#import "HICSystemManager.h"

#import "HICLogManager.h"
#import "HICDBManager.h"
#import "HICTrainManager.h"
#import "HiWebViewManager.h"
#import "HICEnrollManager.h"
#import "HICQuestionManager.h"
#import "HICLiveManager.h"
#import "HICDownloadManager.h"
#import "HICM3U8Manager.h"
#import "HICNetModel.h"

#import "HICExamManager.h"

#import "HICCustomNaviView.h"

#import "HICPushViewManager.h"
#import "HICRoleManager.h"

#import <SDWebImage/SDWebImage.h>
#import <MJExtension/MJExtension.h>
#import <MJRefresh/MJRefresh.h>

#import "UIView+Extension.h"
#import "HICCustomLoadingView.h"
#import "HICCustomerNetErrorView.h"
#import "HICStudyLogReportModel.h"
#import "EMVoiceConverter.h"
#import "UIView+Gradient.h"

#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "OTPSignManager.h"
#import "HICAPI.h"
#import "HICCommonUtils.h"
#import "HICSDKManager.h"

#ifdef __OBJC__
#import <CocoaLumberjack/CocoaLumberjack.h>
#ifdef DEBUG
static const DDLogLevel ddLogLevel = DDLogLevelVerbose;
#else
static const DDLogLevel ddLogLevel = DDLogLevelVerbose;
#endif  /* DEBUG */
#endif /* HiClass_SDKHeader_h */
#endif
