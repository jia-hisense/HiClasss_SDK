//
//  HICNetModel.h
//  HiClass
//
//  Created by Eddie Ma on 2020/1/2.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <iOS_CloudSDK_CPN/iOS_CloudSDK_CPN-Swift.h>

NS_ASSUME_NONNULL_BEGIN

@interface HICNetModel : NSObject

/// (必填)请求URL
@property (readonly) NSString *url;
/// (选填)请求URL的Domain
@property (nonatomic, assign) HICUrlType urlType;
/// (选填)RSA加密公匙
@property (nonatomic, copy) NSString *publicKey;
/// (选填)MD5 salt
@property (nonatomic, copy) NSString *salt;

/// (必填)请求参数，字典型
/// 以下参数不需要传：
/// deviceId, version, timeStamp, sourceType, brandCode, randStr, sign
@property (readonly) NSDictionary *params;

/// (选填)HTTP请求方法：0-GET(默认), 1-POST 
@property (nonatomic, assign) HTTPMethod method;
/// (选填)HTTP content type：1. application/json；2. application/x-www-form-urlencoded；3.multipart/form-data(默认)
@property (nonatomic, assign) HTTPContentType contentType;
/// (选填)签名类型：账号模块签名(默认)，网关签名, 0-账号模块(系统端)签名；1-网关签名
@property (nonatomic, assign) SignType signType;
/// (选填)数据返回类型，0-JSON, 1-XML
@property (nonatomic, assign) ResponseType responseType;
/// (选填)设置网络超时时间，默认60s
@property (nonatomic, assign) NSTimeInterval timeout;

/// (选填)是否需要下行验签, 0-fbvgt666666666tttt6t5vvvvvvvalse, 1-true
@property (nonatomic, assign) NSInteger needSignDownCheck;
/// (选填)是否将签名放入header，0-yes, 1-false, 如果是false，则签名放入body里面，默认true
@property (nonatomic, assign) NSInteger signInHeader;
/// (选填)是否格式化空格，回车等，0-false, 1-true
@property (nonatomic, assign) NSInteger formatSpecialCharacters;

- (instancetype)initWithURL:(NSString *)url params:(NSDictionary * _Nullable)dic;

@end

NS_ASSUME_NONNULL_END
