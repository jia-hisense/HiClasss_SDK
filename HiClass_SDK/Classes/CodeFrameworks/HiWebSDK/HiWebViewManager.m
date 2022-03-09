//
//  HiWebViewManager.m
//  HiClass
//
//  Created by wangggang on 2020/1/13.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HiWebViewManager.h"

@implementation HiWebViewManager
// 1. 创建基本的VC
+(HomeWebViewVC *)createHomeWebViewVCWithUrl:(NSString *)urlStr hideCusNavi:(BOOL)hide hideCusTabBar:(BOOL)hideTabbar {

    HomeWebViewVC *vc = [self createHomeWebViewVC];
    if (urlStr && ![urlStr isEqualToString:@""]) {
        vc.urlStr = urlStr;
    }
    vc.hideNavi = hide;
    vc.hideBtmTab = hideTabbar;
    return vc;
}

// 2. 创建存在交互的VC
+(HomeWebViewVC *)createHomeWebViewVCWithUrl:(NSString *)urlStr delegate:(id<HomeWebViewVCDelegate>)delegate hideCusNavi:(BOOL)hide hideCusTabBar:(BOOL)hideTabbar {
    HomeWebViewVC *vc = [self createHomeWebViewVCWithUrl:urlStr hideCusNavi:hide hideCusTabBar:hideTabbar];
    vc.delegate = delegate;
    vc.hideNavi = hide;
    vc.hideBtmTab = hideTabbar;
    return vc;
}

// 3. 直接加载到父控制器上
+(void)addParentVC:(UIViewController<HomeWebViewVCDelegate> *)vc urlStr:(NSString *)urlStr isDelegate:(BOOL)isDelegate hideCusNavi:(BOOL)hide hideCusTabBar:(BOOL)hideTabbar {

    HomeWebViewVC *webVC;
    if (isDelegate) {
        webVC = [self createHomeWebViewVCWithUrl:urlStr delegate:vc hideCusNavi:hide hideCusTabBar:hideTabbar];
    }else {
        webVC = [self createHomeWebViewVCWithUrl:urlStr hideCusNavi:hide hideCusTabBar:hideTabbar];
    }
    [vc addChildViewController:webVC];
    [vc.view addSubview:webVC.view];
}

// 4. 创建的控制器携带如何进入
+(void)addParentVC:(UIViewController<HomeWebViewVCDelegate> *)vc urlStr:(NSString *)urlStr isDelegate:(BOOL)isDelegate isPush:(BOOL)isPush hideCusNavi:(BOOL)hide hideCusTabBar:(BOOL)hideTabbar {

    HomeWebViewVC *webVC;
    if (isDelegate) {
        webVC = [self createHomeWebViewVCWithUrl:urlStr delegate:vc hideCusNavi:hide hideCusTabBar:hideTabbar];
    }else {
        webVC = [self createHomeWebViewVCWithUrl:urlStr hideCusNavi:hide hideCusTabBar:hideTabbar];
    }
    webVC.isPush = isPush;
    [vc addChildViewController:webVC];
    [vc.view addSubview:webVC.view];

}

// 5. 创建的控制器携带如何进入 - 给定是否三方页面
+(void)addParentVC:(UIViewController<HomeWebViewVCDelegate> *)vc urlStr:(NSString *)urlStr isDelegate:(BOOL)isDelegate isPush:(BOOL)isPush hideCusNavi:(BOOL)hide isThirdUrl:(BOOL)isThirdUrl hideCusTabBar:(BOOL)hideTabbar {

    HomeWebViewVC *webVC;
    if (isDelegate) {
        webVC = [self createHomeWebViewVCWithUrl:urlStr delegate:vc hideCusNavi:hide hideCusTabBar:hideTabbar];
    }else {
        webVC = [self createHomeWebViewVCWithUrl:urlStr hideCusNavi:hide hideCusTabBar:hideTabbar];
    }
    webVC.isPush = isPush;
    webVC.isThirdUrl = isThirdUrl;
    [vc addChildViewController:webVC];
    [vc.view addSubview:webVC.view];

}

// FIXME: 产生统一的Web控制器的方法 ， 方便统一设置
+(HomeWebViewVC *)createHomeWebViewVC {

    HomeWebViewVC *vc = [[HomeWebViewVC alloc] init];

    
    return vc;
}

#pragma mark - 统一的实现Web共有方法

@end
