//
//  JLogSDKInterfaceBase.h
//  iOSDataSDK
//
//  Created by keep on 2018/1/8.
//  Copyright © 2018年 keep. All rights reserved.
//

#import "JLogSDKEnum.h"
#import <Foundation/Foundation.h>

@interface JLogSDKInterfaceBase : NSObject

/** url */
@property (nonatomic, copy) NSString *url;

/** 参数字典 */
@property (nonatomic, strong) id dicParam;

/** 创建interface */
- (id)initWithType:(JLogSDKInterfaceType)type andURL:(NSString *)url;

/** 打包 */
- (void)packageMessage;

/** 异步请求 post */
- (void)startPostASync;

/** 异步请求 get */
- (void)startGetASync;

/** 异步请求 上报日志 */
- (void)startReportLogASync;

/** 解析数据 */
- (void)decodeMessage:(id)data;

/** 处理日志上报 请求失败 */
- (void)decodeFail;

@end
