//
//  HICCompanyMenuModel.h
//  HiClass
//
//  Created by Sir_Jing on 2020/3/20.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HICCompanyMenuModel : NSObject

/// 目录ID
@property (nonatomic, copy) NSString * catalogId;

/// 目录名称
@property (nonatomic, copy) NSString * catalogName;

/// 目录子信息
@property (nonatomic, strong) NSArray<HICCompanyMenuModel *> *children;


/// 创建含有此模型的数组方法
/// @param data 网络请求数据 -- 原始数据
+(NSArray *)createModelWithSourceData:(NSDictionary *)data;

@end

NS_ASSUME_NONNULL_END
