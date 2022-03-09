//
//  HICTabMenuModel.h
//  HiClass
//
//  Created by 铁柱， on 2020/3/24.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HICTabMenuModel : NSObject

/// 导航编码 - SY:学习；XX任务；LX:岗位地图；WD:我的
@property (nonatomic, copy) NSString *navCode;

/// 功能名称
@property(nonatomic, copy) NSString * name;

/// 图标地址
@property(nonatomic, copy) NSString * navIcon;

/// 展示顺序
@property(nonatomic, assign) NSInteger displayOrder;


/// 创建含有此模型的数组方法 -- 底部导航栏
/// @param data 网络请求数据 -- 原始数据
+(NSArray *)createModelWithSourceData:(NSDictionary *)data;

@end

NS_ASSUME_NONNULL_END
