//
//  JLogSDKEnum.h
//  iOSDataSDK
//
//  Created by keep on 2018/1/8.
//  Copyright © 2018年 keep. All rights reserved.
//

#ifndef JLogSDKEnum_h
#define JLogSDKEnum_h
#import <Foundation/Foundation.h>

/**
 * 网络接口类型
 *
 */
typedef NS_ENUM(NSInteger, JLogSDKInterfaceType) {
    /**
     * unkown
     */
    JLOGSDK_INTERFACE_UNKOWN_TYPE,
    
    /**
     * 上报业务日志请求
     */
    JLOGSDK_INTERFACE_SER_TYPE,
    
    /**
     * 上报打点日志请求
     */
    JLOGSDK_INTERFACE_DOT_TYPE,
    
    /**
     * 上报异常日志请求
     */
    JLOGSDK_INTERFACE_EXC_TYPE,
    
    /**
     * 获得日志上报策略请求
     */
    JLOGSDK_INTERFACE_STR_TYPE,
};

/**
 * 日志上报类型
 *
 */
typedef NS_ENUM(NSInteger, JLogSDKLogEventType) {
    /**
     * unkown
     */
    JLOGSDK_LOGEVENT_UNKOWN_TYPE,
    
    /**
     * 异常日志
     */
    JLOGSDK_LOGEVENT_EXC_TYPE,
    
    /**
     * 打点日志
     */
    JLOGSDK_LOGEVENT_DOT_TYPE,
    
    /**
     * 业务日志
     */
    JLOGSDK_LOGEVENT_SER_TYPE,
};

typedef NS_ENUM(NSInteger, JLogSDKStrUrlType) {
    /**
     * 国内
     * Url : "http://api-gps.hismarttv.com/log/get_dotexception_strategy"
     */
    JLOGSDK_STRURL_DOMESTIC_TYPE,
    
    /**
     * 海外
     * Url : "http://api-gps-na.hismarttv.com/log/get_dotexception_strategy"
     */
    JLOGSDK_STRURL_OVERSEAS_TYPE,
};


#endif /* JLogSDKEnum_h */
