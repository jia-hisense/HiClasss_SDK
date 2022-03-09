//
//  HomeWebViewVC.h
//  HiClass
//
//  Created by wangggang on 2020/1/13.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HomeWebViewModel.h"
#import "HiWebViewPerson.h"

NS_ASSUME_NONNULL_BEGIN
@class HomeWebViewVC;
@protocol HomeWebViewVCDelegate <NSObject>

@optional

/// 获取用户信息的基本方法 - 必须实现的
/// @param webVC web控制器
/// @param type 消息类型
/// @param dic 参数字典
/// @param block 返回数据(首参：返回获取的数据，二参：返回H5参数， 三参：获取当前的值的类型)
-(void)homeWebView:(HomeWebViewVC *)webVC type:(WebGetUserInfoType)type getUserInfoWith:(NSDictionary *)dic block:(void(^)(id data, id paramers, WebGetUserInfoType type))block;

/// 文件上传接口 - 图片
/// @param webVC web控制器
/// @param dic 参数字典
/// @param block 返回数据(首参：图片数据，二参：返回H5参数)
-(void)homeWebView:(HomeWebViewVC *)webVC clickH5SaveImageWith:(NSDictionary *)dic block:(void(^)(id data, id paramers))block;


@end



/// WebView的主页面控制器
@interface HomeWebViewVC : UIViewController

@property (nonatomic, weak) id<HomeWebViewVCDelegate> delegate;

/// WebView的加载网络地址
@property (nonatomic, copy) NSString *urlStr;

/// 页面是否为push进入的，默认为NO - Finish时dismiss掉
@property (nonatomic, assign) BOOL isPush;

/// 页面是否隐藏自定义导航栏
@property (nonatomic, assign) BOOL hideNavi;

/// 页面是否隐藏自定义tab
@property (nonatomic, assign) BOOL hideBtmTab;

/// 是否是三方的URL
@property (nonatomic, assign) BOOL isThirdUrl;

/// web的数处理模型
@property (nonatomic, strong) HomeWebViewModel *webViewModel;

-(void)sendMsgToH5WithString:(NSString * _Nullable)str funName:(NSString *)name;


@end

NS_ASSUME_NONNULL_END
