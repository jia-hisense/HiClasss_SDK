//
//  HICVideoModel.h
//  HiClass
//
//  Created by WorkOffice on 2020/2/26.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HICVideoModel : NSObject

/// 媒资-知识id
@property (nonatomic, strong) NSNumber *fileId;

/// integer,是否原文件：0-否  1-是
@property (nonatomic, assign) NSInteger fileType;

/// 媒资类型：0-图片，1-视频，2-音频，3-文档，4-压缩包，5-scrom，6-html
@property (nonatomic, assign) NSInteger type;

/// 该媒资（知识）所属的课程下所有可下载的媒资（知识）数
@property (nonatomic, assign) NSInteger mediaCount;

/// integer,清晰度类型：11-标清 21-高清 31-超清 41-4K",
@property (nonatomic, assign) NSInteger definition;

/// tring,文件后缀名（fileType=1适用））"
@property (nonatomic, strong) NSString *suffixName;

/// 下载总大小
@property (nonatomic, strong) NSNumber *mediaSize;

/// 已经下载的大小
@property (nonatomic, strong) NSNumber *mediaDownloadSize;

/// "string,具体URL",
@property (nonatomic, strong) NSString *url;

/// 下载URL
@property (nonatomic, strong) NSString *mediaURL;

/// "long,文件大小（单位：byte）",
@property (nonatomic, strong) NSNumber *size;

/// "long,总时长/总页数（时长单位：ms）
@property (nonatomic, strong) NSNumber *totalNumber;

@end

NS_ASSUME_NONNULL_END
