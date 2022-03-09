//
//  HICCourseDownloadModel.h
//  HiClass
//
//  Created by Eddie Ma on 2020/2/13.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HICCourseDownloadModel : NSObject

/// 媒资id
@property (nonatomic, strong) NSNumber *mediaId;

/// 下载总大小
@property (nonatomic, strong) NSNumber *mediaSize;

/// 下载名字
@property (nonatomic, strong) NSString *mediaName;

/// 知识数组
@property (nonatomic, strong) NSArray *knowledgeArr;



@end

NS_ASSUME_NONNULL_END
