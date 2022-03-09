//
//  HICDBManager.h
//  HiClass
//
//  Created by Eddie Ma on 2020/2/20.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HICKnowledgeDownloadModel.h"
#import <sqlite3.h>

NS_ASSUME_NONNULL_BEGIN

@interface HICDBManager : NSObject

+ (instancetype)shared;

/// 获取数据库queue
- (dispatch_queue_t)database_queue;

/// 更新数据库所有表
- (void)updataDB;

/// 向下载媒资表中插入数据
/// @param kModel HICKnowledgeDownloadModel
- (void)insertToDownloadMediaTable:(HICKnowledgeDownloadModel *)kModel;

/// 下载中更新
/// @param kModel HICKnowledgeDownloadModel
- (void)updateDownloadMediaWithDownloading:(HICKnowledgeDownloadModel *)kModel;

/// 下载暂停时更新
/// @param kModel HICKnowledgeDownloadModel
- (void)updateDownloadMediaWithStop:(HICKnowledgeDownloadModel *)kModel;

/// 恢复下载后更新
/// @param kModel HICKnowledgeDownloadModel
- (void)updateDownloadMediaWithResume:(HICKnowledgeDownloadModel *)kModel;

/// 下载结束时更新
/// @param kModel HICKnowledgeDownloadModel
- (void)updateDownloadMediaWithFinish:(HICKnowledgeDownloadModel *)kModel;

- (NSArray *)selectAllDownloadMedia;

- (NSArray *)selectMediasByMediaId:(NSNumber *)mediaId isCourseId:(BOOL)isCourseid;

- (NSArray *)selectMediasByMediaSectionId:(NSNumber *)mediaSectionId;

/// 删除某些媒资
/// @param arr HICKnowledgeDownloadModel的数组
- (void)deleteMediaWith:(NSArray *)arr;

@end

NS_ASSUME_NONNULL_END
