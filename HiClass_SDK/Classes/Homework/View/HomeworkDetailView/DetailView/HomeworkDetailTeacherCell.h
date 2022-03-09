//
//  HomeworkDetailTeacherCell.h
//  HiClass
//
//  Created by 铁柱， on 2020/3/26.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HomeworkDetailBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

/// 作业详情老师评语  -- 固有高度 117 -- 没有计算老师的评语高度需要计算
@interface HomeworkDetailTeacherCell : HomeworkDetailBaseCell

+(CGFloat)getStringHeight:(NSString *)str;

@end

NS_ASSUME_NONNULL_END
