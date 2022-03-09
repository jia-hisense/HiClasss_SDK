//
//  JHKPush.h
//  JHKPushSDK
//
//  Created by Eddie_Ma on 12/6/19.
//

#import "HsEnum.h"
#import <Foundation/Foundation.h>
#import <UserNotifications/UserNotifications.h>// iOS 10 notification

NS_ASSUME_NONNULL_BEGIN

@protocol JHKPushDelegate <NSObject>
@required

/*
 *  接收到通知回调
 *  @返回值: (NSString)noticeDate; (NSString)sound; (NSString)content; (NSString)title; (NSString)subtitle; (NSString)body; (NSString)badge; (NSString)extras
 */
-(void)pushNotificationValues:(NSDictionary *)dic;

/* 接受到消息回调
 * @返回值: (NSString)title; (NSString)body; (NSNumber)isOffline: isOffline = @(1)为YES，@(0)为NO; (NSNumber)isFrom: JHKPushVendor类
 */
-(void)pushMsgValues:(NSDictionary *)dic;

/* 各个推送供应商提供的ID，例如：阿里id，个推clienId(cid) */
- (void)vendorID:(NSDictionary *)vid;

/* 账号绑定成功与否的回调 */
- (void)bindOrUnbindAccountSuccess:(BOOL)success isBind:(BOOL)isbind;

/* 标签绑定成功与否的回调 */
- (void)bindOrUnbindTagSuccess:(BOOL)success isBind:(BOOL)isbind;

/* (个推)别名绑定成功与否的回调 */
- (void)bindOrUnbindAliasSuccess:(BOOL)success isBind:(BOOL)isbind;

@end

@interface JHKPush : NSObject

@property (nonatomic,weak) id<JHKPushDelegate> jhkPushDelegate;

+ (JHKPush *)shared;

- (void)setVendors:(NSArray *)vendors;

- (NSArray *)getVendors;

/*
 *  Log Report初始化
 *  @param: deviceId(海信设备Id), appId(app id), urlType(海外写：overseas，国内写：domestic), bundleId, appVersionCode(App版本号),
 *          osVersion(操作系统版本号), model(终端机型信息), manufacturer(终端制造商信息), brand(终端品牌信息)
 */
- (void)logReportInit:(NSDictionary *)dic;

- (void)sdkInitWithAppId:(NSString *)appId appKey:(NSString *)appKey appSecret:(NSString *)appSecret vendorType:(JHKPushVendor)vt;

/* APNs注册 IOS >= 10 */
- (void)registerAPNs API_AVAILABLE(ios(10.0));

/* APNs注册 IOS < 10 */
- (void)registereAPNsIOSLessThan10;

// APNs注册成功回调，将返回的deviceToken上传到CloudPush服务器。在 -(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken调用
- (void)registerDevice:(NSData *)deviceToken vendorType:(JHKPushVendor)vendor;

// APNs注册失败，在 -(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error调用
- (void)didFailToRegisterAPNs:(NSError *)error vendorType:(JHKPushVendor)vendor;

/* APP处于关闭状态时候，通知被点击 IOS < 10, IOS >=10 该方法被覆盖 */
- (void)sendNotificationAck:(NSDictionary *)launchOptions;

/*  App处于启动状态(后台和前台)时，通知打开回调(IOS < 10), 在 -(void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo调用 */
- (void)didReceiveRemoteNotificationForOldIOSVersion:(NSDictionary*)userInfo;

/*
 *  系统端注册失败，上报日志
 *  @param: aliDeviceId(阿里Device Id/个推client Id), resultCode(返回码), errorDesc(错误描述)
 */
- (void)systemRegisterFaild:(NSDictionary *)faildInfo vendorType:(JHKPushVendor)vendor;

// 账号绑定或解绑，目前只支持阿里
- (void)account:(NSString *)account isBind:(BOOL)isBind vendorType:(JHKPushVendor)vendor;

// 设置标签，如果传空则将对应cid下面的标签清空
- (void)tag:(NSString *)tagStr isBind:(BOOL)isBind vendorType:(JHKPushVendor)vendor;

// 设置别名，sequenceNum用来标记绑定次数，建议每次使用唯一不同的值；isSelf 字段为标识是否只对当前 cid 生效，如果是 true，只对当前 cid 做解绑；如果是 false，对所有绑定该别名的 cid 列表做解绑
- (void)alias:(NSString *)alias isBind:(BOOL)isBind vendorType:(JHKPushVendor)vendor sequenceNum:(NSString *)sn andIsSelf:(BOOL)isSelf;

@end

NS_ASSUME_NONNULL_END
