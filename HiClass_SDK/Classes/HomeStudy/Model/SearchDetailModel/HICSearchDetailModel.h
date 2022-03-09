//
//  HICSearchDetailModel.h
//  HiClass
//
//  Created by Sir_Jing on 2020/3/20.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchDetailInfoModel : NSObject

/// 课程知识ID/讲师表ID
@property (nonatomic, assign) NSInteger  infoId;

/// 课程知识标题/讲师名称
@property (nonatomic, copy) NSString * title;

/// 描述/讲师简述
@property (nonatomic, copy) NSString * infoDescription;

/// 公司名称-部门-职位
@property (nonatomic, copy) NSString * dept;

/// 知识封面图/讲师头像URL
@property (nonatomic, copy) NSString * coverPic;

/// 资源类型（针对知识）  0-图片，1-视频，2-音频，3-文档，4-压缩包，5-scrom,6-html
@property (nonatomic, assign) NSInteger resourceType;
@property (nonatomic, copy) NSString *partnerCode;
/// 评分
@property (nonatomic, assign) double  score;

/// 学习人数，默认0
@property (nonatomic, assign) NSInteger learnersNum;

/// 是否最新发布（3天内发布）0-否，1-是
@property (nonatomic, assign) NSInteger isNew;

/// 课程知识类型：6-课程，7-知识
@property (nonatomic, assign) NSInteger kldType;

@end

@interface HICSearchDetailModel : NSObject

@property (nonatomic, assign) NSInteger  pageNum;

@property (nonatomic, assign) NSInteger  pageSize;

@property (nonatomic, assign) NSInteger  totalNum;

@property (nonatomic, strong) NSArray<SearchDetailInfoModel *>  *content;

/// 创建含有此模型的方法
/// @param data 网络请求数据 -- 原始数据
+(HICSearchDetailModel *)createModelWithSourceData:(NSDictionary *)data;

@end

NS_ASSUME_NONNULL_END
