//
//  HsEnum.h
//  HsPushMsgSDK
//
//  Created by Mzd on 2018/11/14.
//  Copyright © 2018 Hisense. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, HsPushMsgLogEventCode) {
    /** 注册海信系统端结果 200000 */
    HS_LOGEVENTCODE_REGISTERSYSTEMRESULT,
    
    /** 阿里register接口错误 200001 */
    HS_LOGEVENTCODE_ALIREGISTERRESULT,
    
    /** 阿里绑定账号错误 200002 */
    HS_LOGEVENTCODE_ALIBINDACCOUNTRESULT,
    
    /** APNs注册错误 200003 */
    HS_LOGEVENTCODE_APNSFAILEDRESULT,
    
    /** Device Token 上传Ali失败 200004 */
    HS_LOGEVENTCODE_TOEKNPASSALIRESULT,
    
    /** 阿里通道收到消息 201000 */
    HS_LOGEVENTCODE_RECEIVEMSG,
    
    /** 阿里通道收到通知 201001 */
    HS_LOGEVENTCODE_RECEIVENOTIFICATION,
    
    /** 通知被点击 201002 */
    HS_LOGEVENTCODE_NOTIFICATIONCLICKED,
    
    /** 阿里通道消息被关闭 201003 */
    HS_LOGEVENTCODE_MSGCLOSED,
};

typedef NS_ENUM(NSInteger, HsPushType) {
    /** 通知 */
    HS_PUSH_NOTIFI,

    /** 消息 */
    HS_PUSH_MSG,
};

typedef NS_ENUM(NSInteger, JHKPushVendor) {
    /** 未知推送商 */
    JHK_PUSH_VENDOR_UNDEFINE = 0,

    /** 阿里推送 */
    JHK_PUSH_VENDOR_ALI,

    /** 个推推送 */
    JHK_PUSH_VENDOR_GT,

    /** VOIP推送 */
    JHK_PUSH_VENDOR_VOIP,
};

