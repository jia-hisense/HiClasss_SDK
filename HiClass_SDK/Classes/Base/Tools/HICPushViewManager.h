//
//  HICPushViewManager.h
//  HiClass
//
//  Created by wangggang on 2020/3/23.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface PushViewControllerModel : NSObject

/// 推出下一级页面的编码类型 -- 0-岗位/岗位目录 1-试卷/试卷目录 2-试题库/试题库目录 3-证书 4-考试 5-知识/课程 6-课程 7-知识 8-报名 9-请假 10-习题集 11-线下课 12-培训 13-问卷/评价 14-讲师 15-分类 30-排行榜 122-线下培训(childType:0培训详情页1培训安排) 1001-视频会议；1002-岗位地图，1003-考试中心，1004-培训管理，1005-问卷，1006-报名,1007-企业知识,1008-自定义URL，1009-自定义链接目录, 1010-仅展示图片
@property (nonatomic, assign) NSInteger pushType;

/// 跳转类型的URL
@property (nonatomic, copy) NSString *urlStr;

/// 跳转的详细ID
@property (nonatomic, assign) NSInteger detailID;

/// 知识的跳转类型
@property (nonatomic, assign) HICStudyResourceType studyResourceType;

/// 标题名称
@property (nonatomic, copy) NSString *titleName;

/// 下一页面的需要的ID字符串
@property (nonatomic, copy) NSString *pushId;

/// 如何推到下一级：默认push
@property (nonatomic, assign) NSInteger isPushType;

#pragma mark -混合培训需要
///workid
@property (nonatomic, assign) NSInteger workId;
#pragma mark -报名中心

#pragma mark - 企业知识特殊需要
/// 企业知识目录 -- 是否支持单视频
@property (nonatomic, copy) NSString *companyOnlyVideo;
@property (nonatomic, assign) NSInteger orderBy;

#pragma mark - 线下培训的特殊需要
/// 0:跳转到培训详情页 1:培训安排
@property (nonatomic, assign) NSInteger childType;
@property (nonatomic ,strong) NSString *mixTrainType;
@property (nonatomic ,assign) NSInteger registChannel;
// 构造方法
-(instancetype)initWithPushType:(NSInteger)pushType urlStr:(NSString *_Nullable)urlStr detailId:(NSInteger)detailId studyResourceType:(HICStudyResourceType)studyResourceType pushType:(NSInteger)isPush;

@end

@interface HICPushViewManager : NSObject

/// 统一的推送下一级页面方法
/// @param parentVC 当前父类VC
/// @param model 当前需要推送的下一级数据模型
+(void)parentVC:(UIViewController *)parentVC pushVCWithModel:(PushViewControllerModel *)model;

@end

NS_ASSUME_NONNULL_END
