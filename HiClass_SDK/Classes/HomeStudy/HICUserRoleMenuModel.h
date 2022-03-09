//
//  HICUserRoleModel.h
//  HiClass
//
//  Created by Sir_Jing on 2020/3/21.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HICUserRoleMenuModel : NSObject

/// 用户角色菜单ID
@property (nonatomic, assign) NSInteger  roleMenuID;

/// 菜单名称
@property (nonatomic, copy) NSString *name;

/// 菜单编码
@property (nonatomic, copy) NSString *menuCode;

/// 上级目录编码
@property (nonatomic, copy) NSString *parentCode;

/// 子目录
@property (nonatomic, strong) NSArray<HICUserRoleMenuModel *> *children;

/// 是否是权限，默认0，0为菜单，1为权限
@property (nonatomic, assign) NSInteger  isAuthority;


/// 创建含有此模型的数组方法 -- 用户角色菜单
/// @param data 网络请求数据 -- 原始数据
+(NSArray *)createModelWithSourceData:(NSDictionary *)data;

@end

NS_ASSUME_NONNULL_END
