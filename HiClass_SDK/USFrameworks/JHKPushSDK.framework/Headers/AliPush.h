//
//  HsPushMsg.h
//  HsPushMsgSDK
//  version: 1.0.8
//  Created by Eddie_Ma on 5/11/18.
//

#import <Foundation/Foundation.h>

@protocol AliPushDelegate <NSObject>
@required
- (void)aliVendorID:(NSDictionary *)vID;
//返回值: (NSString)title; (NSString)body
- (void)aliPushMsgValues:(NSMutableDictionary *)dic;
@end
typedef void(^AliDeviceIdBlock)(NSString *aliDeviceId);
typedef void(^BindAccountBlock)(Boolean result);
typedef void(^UnBindAccountBlock)(Boolean result);
typedef void(^BindTagBlock)(Boolean result);
typedef void(^UnBindTagBlock)(Boolean result);
typedef void(^BindAliasBlock)(Boolean result);
typedef void(^UnBindAliasBlock)(Boolean result);
@interface AliPush : NSObject
@property (nonatomic,weak) id<AliPushDelegate> aliPushDelegate;
@property (nonatomic, strong) BindAccountBlock callbackForBindAccount;
@property (nonatomic, strong) UnBindAccountBlock callbackForUnBindAccount;
@property (nonatomic, strong) BindTagBlock callbackForBindTagBlock;
@property (nonatomic, strong) UnBindTagBlock callbackForUnBindTagBlock;
@property (nonatomic, strong) BindAliasBlock callbackForBindAliasBlock;
@property (nonatomic, strong) UnBindAliasBlock callbackForUnBindAliasBlock;
+ (AliPush *)shared;

// 阿里CloudPushSDK初始化，异步返回Ali Device ID
- (void)sdkInitWithAppKey:(NSString *)appKey withAppSecret:(NSString *)appSecret;

// 监听消息通道
- (void)aliListenerOnChannelOpened;

// 注册推送消息到来监听
- (void)aliRegisterMessageReceive;

// 账号绑定
- (void)bindAccount:(NSString *)account withCallBack:(BindAccountBlock) bindAccountBlock;

// 账号解绑
- (void)unbindAccountWithCallBack:(UnBindAccountBlock) unBindAccountBlock;

// tag绑定
- (void)bindTagForDevice:(NSString *)tagStr withCallBack:(BindTagBlock) bindTagBlock;

// tag解绑
- (void)unbindTagForDevice:(NSString *)tagStr withCallBack:(UnBindTagBlock) unBindTagBlock;

// 别名绑定
- (void)addAlias:(NSString *)alias withCallBack:(BindAliasBlock) bindAliasBlock;

// 别名解绑
- (void)removeAlias:(NSString *)alias withCallBack:(UnBindAliasBlock) unBindAliasBlock;

// 获取Ali SDK版本
- (NSString *)aliSDKVersion;

//推送SDK初始化结束后调用有效，否则为空
- (NSString *)aliDeviceId;

- (void)setBadge:(NSUInteger)badge;
@end


