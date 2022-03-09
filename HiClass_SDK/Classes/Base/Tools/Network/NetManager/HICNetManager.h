//
//  HICNetManager.h
//  HiClass
//
//  Created by Eddie Ma on 2020/1/2.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HICNetModel.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 请求成功的block
typedef void(^Success)( NSDictionary * responseObject);

/// 请求失败的block
typedef void(^Failure)( NSError *error);

@interface HICNetManager : NSObject

@property (nonatomic, assign) HICNetStatus netStatus;

+ (instancetype)shared;

/// HTTP 请求
/// @param model 请求的所有参数(接口参数+验签参数)
/// @param success 成功回调
/// @param failure 失败回调
- (void)sentHTTPRequest:(HICNetModel *)model success:(Success)success failure:(Failure)failure;

@end

NS_ASSUME_NONNULL_END
