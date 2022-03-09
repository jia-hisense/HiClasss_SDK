//
//  HICPostMapMoreModel.h
//  HiClass
//
//  Created by Sir_Jing on 2020/3/19.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MapMoreInfoModel : NSObject

/// 岗位ID
@property (nonatomic, assign) NSInteger  trainPostId;

/// 岗位名称
@property (nonatomic, copy) NSString * postName;

/// 任务进度
@property (nonatomic, assign) double  taskProgress;

/// 是否当前用户上次岗位 0:否 1:是
@property (nonatomic, assign) NSInteger  isPrePost;
///岗位id
@property (nonatomic ,strong) NSNumber *postId;

@end

@interface HICPostMapMoreModel : NSObject

/// 分组名称
@property (nonatomic, copy) NSString * groupName;


/// 分组ID
@property (nonatomic, assign) NSInteger  groupId;

/// 岗位列表
@property (nonatomic, strong) NSArray *postList;


/// 网络数据转成数据模型数组
/// @param dic 网络数据字典
+(NSArray *)getMapMoreDataWith:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
