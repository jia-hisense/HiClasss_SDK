//
//  HICHomeStudyModel.h
//  iTest
//
//  Created by Sir_Jing on 2020/3/13.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HICHomeTaskCenterModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ResourceListItem : NSObject

/// 分类类型 -- 0-知识分类，1-首页，默认是0
@property (nonatomic, assign)   NSInteger pageType;

/// 资源ID
@property (nonatomic, assign)   NSInteger resourceId;

/// 资源类型 ----  0-岗位/岗位目录 1-试卷/试卷目录 2-试题库/试题库目录 3-证书 4-考试 5-知识/课程 6-课程 7-知识 8-报名 9-请假 10-习题集 11-线下课 12-培训 13-问卷/评价 14-讲师 15-分类 30-排行榜 1001-视频会议；1002-岗位地图，1003-考试中心，1004-培训管理，1005-问卷，1006-报名,1007-企业知识,1008-自定义URL，1009-自定义链接目录 1012-直播
@property (nonatomic, assign)   NSInteger resourceType;

/// 资源名称/标题
@property (nonatomic, copy)     NSString *name;

/// 展示顺序
@property (nonatomic, assign)   NSInteger displayOrder;

/// 图片地址
@property (nonatomic, copy)     NSString *picPath;

/// 跳转链接
@property (nonatomic, copy)     NSString *linkUrl;

/// 公告内容/描述
@property (nonatomic, copy)     NSString *text;

/// 用户信息  -- 字典   ---  "customerId": "long,用户ID" -- "name": "string,用户名称"  --  "headPic": "string,头像url，空终端用默认头像"  --  "score": "float,获得学时/学分"  --  "orderNum": "integer,排名"
@property (nonatomic, strong)   NSDictionary *user;

/// 字典类型  ---  "studiedNum": "integer,已学习人数"  --  "ratedNum": "integer,评价人数"  --  "fileType": "integer,知识类型:0-图片，1-视频，2-音频，3-文档，4-压缩包，5-scrom,6-html"
@property (nonatomic, strong)   NSDictionary *courseInfo;

/// 按照类型过滤知识目录，类型间逗号隔开，例如 1,2 暂时只有1
@property (nonatomic, copy) NSString *dirTypeFilter;

@end

@interface HICHomeStudyModel : NSObject

/// 栏目ID
@property (nonatomic, assign)   NSInteger columnId;

/// 栏目类型 --  1-顶部导航，2-banner图，3-功能区，4-公告，5-专题栏目，6-猜你喜欢
@property (nonatomic, assign)   NSInteger columnType;

/// 展示顺序
@property (nonatomic, assign)   NSInteger displayOrder;

/// 栏目名称
@property (nonatomic, copy)     NSString *name;

/// 专题类型  --  1-app模板1，2-app模板2，3-app模板3，4-app模板4，5-app模板5，6-app模板-排行,7-web模板1,8-web模板2,9-web模板3,10-web模板4,11-web模板排行
@property (nonatomic, assign)   NSInteger templateType;

/// 数据来源  0-oss编排，1-知识课程目录，2-排行榜，默认0
@property (nonatomic, assign)   NSInteger source;

/// 来源目录
@property (nonatomic, copy)     NSString *sourceDir;

/// 1-最新   2 - 最热
@property (nonatomic, assign) NSInteger courseKldOrderBy;

/// 字典类型 --  "countTime": "0-本周，1-本月，2-今年"  --  "countType": "0-学分，1-学时"
@property (nonatomic, strong)   NSDictionary *boardParam;

/// 内容数据
@property (nonatomic, strong)   NSArray <ResourceListItem*> *resourceList;


//FIXME: 私有属性，非服务器传递

/// 监测当前的数据模型是否为cell方便以后获取使用
@property (nonatomic, assign) BOOL isCell;

/// 如果不是固定的则可以使用cellID来创建
@property (nonatomic, copy) NSString *cellID;
/// 标志出cell的高度
@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, strong) NSArray<HICHomeTaskCenterModel *> * taskCenters;


/// 创建含有此模型的数组方法
/// @param data 网络请求数据 -- 原始数据
+(NSArray *)createModelWithSourceData:(NSDictionary *)data;


/// 将多组数据转化成自己需要的数组 -- 对应不同的cell的
/// @param array 服务器直接返回转化的数组
+(NSArray *)getHomeDataWithModels:(NSArray *)array;

/// 将多组数据转化成自己需要的数组 -- 对应不同的cell的另一个借口添加center数据
/// @param array 首页服务器直接转化数组
/// @param centers 任务中心获取数据
+(NSArray *)getHomeDataWithModels:(NSArray *)array addTaskCenters:(NSArray *)centers;

/// 获取得到顶部菜单栏的方法 -- 仅仅只有一个
/// @param array 服务器直反转化数组
+(HICHomeStudyModel *)getMenuDataWithModels:(NSArray *)array;

@end

NS_ASSUME_NONNULL_END
