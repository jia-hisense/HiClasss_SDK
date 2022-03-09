//
//  HICM3U8PlayListModel.h
//  HiClass
//
//  Created by Eddie_Ma on 16/2/20.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HICM3U8SegmentModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HICM3U8PlayListModel : NSObject

/// HICM3U8SegmentModel的数组
@property (nonatomic, strong) NSArray *segmentModelArr;

/// .ts的数量
@property (nonatomic, assign) NSInteger tsNum;

/// 根据uuid来拼接统一的缓存路径
@property (nonatomic, strong) NSNumber *uuid;

/// 存储原始的M3U8数据
@property (copy, nonatomic) NSString *m3u8IndexUrl;

@end

NS_ASSUME_NONNULL_END
