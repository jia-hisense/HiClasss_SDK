//
//  GTPush.h
//  GTPushSDK
//
//  Created by Eddie_Ma on 10/6/19.
//

#import <Foundation/Foundation.h>

@protocol GTPushDelegate <NSObject>
@required
- (void)gtVendorID:(NSDictionary *)vID;
//返回值: (NSString)title; (NSString)body
- (void)gtPushMsgValues:(NSDictionary *)dic;
- (void)gtBindOrUnbindSuccess:(BOOL)success isBind:(BOOL)isbind;
@end
typedef void(^BindTagBlock)(Boolean result);

@interface GTPush : NSObject

@property (nonatomic, strong) BindTagBlock callbackForBindTagBlock;

@property (nonatomic,weak) id<GTPushDelegate> gtPushDelegate;

@property (nonatomic, strong) NSString *clientID;

+ (GTPush *)shared;

// 初始化SDK，该方法需要在主线程进行
- (void)sdkInitWithAppId:(NSString *)appId appKey:(NSString *)appKey appSecret:(NSString *)appSecret;

// tag绑定，如果传空则将对应cid下面的标签清空
- (void)bindTagForDevice:(NSString *)tagStr withCallBack:(BindTagBlock) bindTagBlock;

// 别名绑定, sequenceNum用来标记绑定次数，建议每次使用唯一不同的值
- (void)addAlias:(NSString *)alias sequenceNum:(NSString*)sn;

// 别名解绑，isSelf 字段为标识是否只对当前 cid 生效，如果是 true，只对当前 cid 做解绑；如果是 false，对所有绑定该别名的 cid 列表做解绑
- (void)removeAlias:(NSString *)alias andSequenceNum:(NSString *)sn andIsSelf:(BOOL)isSelf;

- (void)setBadge:(NSUInteger)badge;

- (void)resetBadge;
@end

