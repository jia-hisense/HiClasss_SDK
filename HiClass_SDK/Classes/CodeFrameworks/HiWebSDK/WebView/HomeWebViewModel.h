//
//  HomeWebViewModel.h
//  HiClass
//
//  Created by wangggang on 2020/1/13.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


/// 提供浏览器使用的数据内容
@interface HomeWebViewModel : NSObject

@property (nonatomic, strong) NSMutableArray *userConfigNames;

/// 设置默认的js交互
-(void)setDefaultConfigNames;

/// 网络请求 - 发送图片文件到服务器
/// @param parames 请求参数
/// @param data 图片数据
/// @param success 成功返回(首参：是否成功，二参：返回服务器返回参数，三参：返回H5调用接口)
-(void)sendH5SaveImageToSeverWith:(NSDictionary *)parames data:(id)data success:(void(^)(BOOL success, id _Nullable data, NSDictionary *param))success;


@end

NS_ASSUME_NONNULL_END
