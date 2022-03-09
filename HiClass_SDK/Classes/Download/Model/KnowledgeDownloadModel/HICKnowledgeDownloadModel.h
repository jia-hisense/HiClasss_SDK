//
//  HICKnowledgeDownloadModel.h
//  HiClass
//
//  Created by Eddie Ma on 2020/2/13.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HICKnowledgeDownloadModel : NSObject

/// 媒资id
@property (nonatomic, strong) NSString *fileId;

/// 媒资ids, 作为展示顺序用
@property (nonatomic, strong) NSString *fileIds;

/// 媒资章节
@property (nonatomic, strong) NSNumber *sectionId;

/// 媒资-知识id
@property (nonatomic, strong) NSNumber *mediaId;

/// 如果媒资是m3u8格式，该字段存的是在一个mediaId下的第几个ts文件, 如果不是m3u8格式，则为-2 (暂时不用)
@property (nonatomic, strong) NSNumber *mediaTsId;

/// 媒资类型：0-图片，1-视频，2-音频，3-文档，4-压缩包，5-scrom，6-html
@property (nonatomic, strong) NSNumber *mediaType;

/// 该媒资（知识）所属的课程所有可下载媒资（知识）数
@property (nonatomic, assign) NSInteger mediaCount;

/// 媒资（课程）下媒资（知识）的下载数
@property (nonatomic, assign) NSInteger mediaDownloadCount;

/// 媒资-课程id
@property (nonatomic, strong) NSNumber *cMediaId;

/// 媒资-课程名称
@property (nonatomic, strong) NSString *cMediaName;

/// 下载总大小
@property (nonatomic, strong) NSNumber *mediaSize;

/// 已经下载的大小
@property (nonatomic, strong) NSNumber *mediaDownloadSize;

/// 下载名字
@property (nonatomic, strong) NSString *mediaName;

@property (nonatomic, strong) NSString *coverPic;

/// 下载URL
@property (nonatomic, strong) NSString *mediaURL;

/// 媒资下载存储路径
@property (nonatomic, strong) NSString *mediaPath;

/// 媒资下载暂停点
@property (nonatomic, strong) NSString *mediaStopPoint;

/// 单独知识下载标识， 0-不是，1-是
@property (nonatomic, assign) NSInteger mediaSingle;

/// 下载状态
@property (nonatomic, assign) HICDownloadStatus mediaStatus;

/// 清晰度类型
@property (nonatomic, assign) HICVideoDefinition definition;

/// 是否原文件：0-否  1-是
@property (nonatomic, strong) NSNumber *fileType;

/// 文件后缀名（fileType=1适用）
@property (nonatomic, strong) NSString *suffixName;

@property (nonatomic, strong) NSString *cCoverPic;
///培训id
@property (nonatomic ,strong)NSNumber *trainID;

@end

NS_ASSUME_NONNULL_END
