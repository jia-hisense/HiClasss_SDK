//
//  HICM3U8Manager.h
//  HiClass
//
//  Created by Eddie_Ma on 16/2/20.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HICM3U8PlayListModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HICM3U8ManagerDelegate <NSObject>

/// 解析m3u8结果
/// @param success 成功/失败
/// @param reason 成功/失败的原因
- (void)praseM3U8Result:(BOOL)success reason:(NSString *)reason;

@end

@interface HICM3U8Manager : NSObject

+ (instancetype)shared;

@property (weak, nonatomic)id <HICM3U8ManagerDelegate> delegate;

/// 存储TS片段的数组
@property (strong, nonatomic) NSMutableArray *segmentArray;

/// 存储原始的M3U8数据
@property (copy, nonatomic) NSString *oriM3U8Str;

/// 打包获取的TS片段
@property (strong, nonatomic) HICM3U8PlayListModel *playList;

/// 下载的m3u8媒资的mediaId
@property (strong, nonatomic) NSNumber *mediaId;

/// 解析URL
/// @param urlStr string URL
- (void)praseUrl:(NSString *)urlStr;

@end

NS_ASSUME_NONNULL_END
