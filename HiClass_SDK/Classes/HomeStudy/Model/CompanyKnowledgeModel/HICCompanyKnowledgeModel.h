//
//  HICCompanyKnowledgeModel.h
//  HiClass
//
//  Created by Sir_Jing on 2020/3/20.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HICHomeStudyClassModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 企业知识数据模型
@interface HICCompanyKnowledgeModel : NSObject

/// 页码
@property (nonatomic, assign) NSInteger  pageNum;

/// 单页数量
@property (nonatomic, assign) NSInteger  pageSize;

/// 总数
@property (nonatomic, assign) NSInteger  totalNum;

/// 关联课程列表数组
@property (nonatomic, strong) NSArray<HSCourseKLD *> *content;


/// 数据转模型
/// @param data 服务器数据
+(HICCompanyKnowledgeModel *)createModelWithSourceData:(NSDictionary *)data;

@end

NS_ASSUME_NONNULL_END
