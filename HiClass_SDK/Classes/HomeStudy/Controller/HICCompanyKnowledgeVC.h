//
//  HICCompanyKnowledgeVC.h
//  iTest
//
//  Created by Sir_Jing on 2020/3/11.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 企业知识页面
@interface HICCompanyKnowledgeVC : UIViewController

/// 筛选条件的课程分类ID
@property (nonatomic, copy) NSString  *dirId; // 目录ID

@property (nonatomic, assign) NSInteger orderBy; // 0-发布时间，1-更新时间，2-学习人数，倒序排序

/// 是否仅支持视频 -- 为空时和不为1时为否 为1时是
@property (nonatomic, copy) NSString *isOnleVideo;

@property (nonatomic, assign) BOOL isHiddenNav;

@end

NS_ASSUME_NONNULL_END
