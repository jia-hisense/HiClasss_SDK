//
//  HICPostMapLineModel.h
//  HiClass
//
//  Created by Sir_Jing on 2020/3/19.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 单个地图的 每个点的详细信息
@interface MapLineInfoModel : NSObject

/// 节点ID
@property (nonatomic, assign) NSInteger nodeId;

/// 层级ID
@property (nonatomic, assign) NSInteger levelId;

/// 层级名称
@property (nonatomic, copy) NSString * levelName;

/// 培训岗位ID
@property (nonatomic, assign) NSInteger trainPostId;

/// 岗位ID
@property (nonatomic, strong) NSNumber *postId;
/// 岗位名称
@property (nonatomic, copy) NSString * postName;

/// 是否有更多岗位 1:是 0:否
@property (nonatomic, assign) NSInteger hasMore;

/// 岗位分组ID
@property (nonatomic, assign) NSInteger groupId;

/// 任务进度
@property (nonatomic, assign) double taskProgress;

/// 是否当前用户岗位节点 1:是；0:否
@property (nonatomic, assign) NSInteger isCurrentNode;



@end

/// 岗位地图 路线图Model -- （一共有多少条路线）
@interface HICPostMapLineModel : NSObject

/// 路线ID
@property (nonatomic, assign) NSInteger wayId;

/// 路线名称
@property (nonatomic, copy) NSString *wayName;

/// 是否显示全部 1:仅展示当前岗位和下一级两个岗位，其他岗位灰置不可点击；0:全部显示
@property (nonatomic, assign) NSInteger isShowAll;

/// 节点详情数组
@property (nonatomic, strong) NSArray<MapLineInfoModel *> *wayDetail;



/// 网络数据转成数据模型数组
/// @param dic 网络数据字典
+(NSArray *)getMapLineDataWith:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
