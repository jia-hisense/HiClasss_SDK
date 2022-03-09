//
//  HICDownloadManager.h
//  HiClass
//
//  Created by Eddie_Ma on 15/2/20.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HICKnowledgeDownloadModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HICDownloadManagerDelegate <NSObject>
@optional

- (void)downloadProcess:(CGFloat)percent kModel:(HICKnowledgeDownloadModel *)kModel;

@end

@interface HICDownloadManager : NSObject

@property (nonatomic, weak) id<HICDownloadManagerDelegate>delegate;
@property (nonatomic, strong) NSArray *downloadMediaArr;
@property (nonatomic, strong) NSMutableArray *readyForDownloadArr;

+ (instancetype)shared;

/// 从0开始下载
/// @param arr 下载媒资数组
- (void)startDownloadWith:(NSArray *)arr;

/// 恢复下载
- (void)resumeWith:(NSNumber *)mediaId;

/// 暂停
- (void)pauseWith:(NSNumber *)mediaId;

/// 取消下载
- (void)cancelWith:(NSNumber *)mediaId;

@end

NS_ASSUME_NONNULL_END
