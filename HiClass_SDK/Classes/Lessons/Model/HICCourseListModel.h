//
//  HICCourseListModel.h
//  HiClass
//
//  Created by WorkOffice on 2020/2/17.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HICCourseListModel : NSObject
@property (nonatomic ,strong)NSNumber *chapterDetailId;//章节ID
@property (nonatomic ,assign)NSInteger type;//:"integer,资源类型  4-考试，7-知识",
@property (nonatomic ,assign)NSInteger displayOrder;//展示顺序
@property (nonatomic ,strong)NSDictionary *courseInfo;
@property (nonatomic ,strong)NSDictionary *examInfo;
@property (nonatomic ,strong)NSString *learningRate;//"string,学习进度，例如：60%"

@end

NS_ASSUME_NONNULL_END
