//
//  HiWebViewManager.h
//  HiClass
//
//  Created by wangggang on 2020/1/13.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

#import "HomeWebViewVC.h"

NS_ASSUME_NONNULL_BEGIN


/// 统一的WebView管理类
@interface HiWebViewManager : NSObject

///  创建默认的浏览器 --- 没有交互的
+(HomeWebViewVC *)createHomeWebViewVCWithUrl:(NSString *_Nullable) urlStr hideCusNavi:(BOOL)hide hideCusTabBar:(BOOL)hideTabbar;

/// 创建一个浏览器 --- 存在交互
+(HomeWebViewVC *)createHomeWebViewVCWithUrl:(NSString *_Nullable) urlStr delegate:(id<HomeWebViewVCDelegate>)delegate hideCusNavi:(BOOL)hide hideCusTabBar:(BOOL)hideTabbar;


/// 加载webView到父视图控制器
/// @param vc 俯视图控制器
/// @param urlStr 加载URL地址
/// @param isDelegate 是否添加协议
+(void)addParentVC:(UIViewController *)vc urlStr:(NSString *)urlStr isDelegate:(BOOL)isDelegate hideCusNavi:(BOOL)hide hideCusTabBar:(BOOL)hide;
/// 加载webView到父视图控制器
/// @param vc 父视图控制器
/// @param urlStr 加载地址
/// @param isDelegate 是否实现交互协议
/// @param isPush 是否加载的页面为push来的(默认为Present)
+(void)addParentVC:(UIViewController *)vc urlStr:(NSString *)urlStr isDelegate:(BOOL)isDelegate isPush:(BOOL)isPush hideCusNavi:(BOOL)hide hideCusTabBar:(BOOL)hide;

// 5. 创建的控制器携带如何进入 - 给定是否三方页面
+(void)addParentVC:(UIViewController<HomeWebViewVCDelegate> *)vc urlStr:(NSString *)urlStr isDelegate:(BOOL)isDelegate isPush:(BOOL)isPush hideCusNavi:(BOOL)hide isThirdUrl:(BOOL)isThirdUrl hideCusTabBar:(BOOL)hideTabbar;

@end

NS_ASSUME_NONNULL_END
