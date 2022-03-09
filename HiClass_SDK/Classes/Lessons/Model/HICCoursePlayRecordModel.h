//
//  HICCoursePlayRecordModel.h
//  HiClass
//
//  Created by WorkOffice on 2020/2/17.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/**
 courseId = 1157;
 courseKLDId = 1168;
 currentPageNum = 0;
 fileType = 3;
 id = 1145;
 sectionId = 1033;
 totalPageNum = 55;
 */
@interface HICCoursePlayRecordModel : NSObject
@property (nonatomic ,strong)NSNumber *recordId;//播放记录ID
@property (nonatomic ,strong)NSNumber *courseKLDId;//long,知识/课程ID
@property (nonatomic ,strong)NSNumber *sectionId;//章节ID，适用于课程类型
@property (nonatomic ,strong)NSNumber *courseId;//知识ID，适用于课程类型"
@property (nonatomic ,assign)NSInteger fileType;//integer,文件类型  1-视频，2-音频，3-文档"
@property (nonatomic ,strong)NSNumber *currentDuration;//long,音视频已播放时长，单位ms，默认0",
@property (nonatomic ,assign)NSInteger totalDuration;//音视频总时长，单位ms，默认0
@property (nonatomic ,assign)NSInteger currentPageNum;//文档图片已播放到第n页，默认0
@property (nonatomic ,assign)NSInteger totalPageNumber;//文档图片总页数，默认0
@end

NS_ASSUME_NONNULL_END
