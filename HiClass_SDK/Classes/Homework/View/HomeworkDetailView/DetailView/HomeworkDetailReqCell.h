//
//  HomeworkDetailReqCell.h
//  HiClass
//
//  Created by 铁柱， on 2020/3/26.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HomeworkDetailBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

/// 作业详情要求  -- 固有高度 107 -- 不包含奖励内容和作业要求的需要单独计算
@interface HomeworkDetailReqCell : HomeworkDetailBaseCell

+(CGFloat)getStringHeight:(NSString *)str;

@end

NS_ASSUME_NONNULL_END
