//
//  HICForgetInputView.h
//  HiClass
//
//  Created by wangggang on 2019/12/31.
//  Copyright © 2019 jingxianglong. All rights reserved.
//

#import <UIKit/UIKit.h>

// 网络请求
#import "HICNetManager.h"

typedef void(^ClickNextButBlock)(NSString * _Nonnull phone, NSString * _Nonnull authCode, NSString *_Nonnull pass, NSString *_Nonnull confirmPass);

NS_ASSUME_NONNULL_BEGIN

@interface HICForgetInputView : UIView

// 定时器 -- 对外部开放，用来做定时器
@property (nonatomic, strong) NSTimer *__nullable timer;

/// 清空页面缓存数据的，主要是防止 页面复用是退出返回后 信息照常存在
-(void)cleanDataInput;

/// 初始化时设置回调，此回调调用Controller的下一步操作
-(void)clickNextButBlock:(ClickNextButBlock)block;

@end

NS_ASSUME_NONNULL_END
