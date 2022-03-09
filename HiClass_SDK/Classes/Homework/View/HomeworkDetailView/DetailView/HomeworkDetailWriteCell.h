//
//  HomeworkDetailWriteCell.h
//  HiClass
//
//  Created by 铁柱， on 2020/3/26.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HomeworkDetailBaseCell.h"

#define HWD_WriteContentImageWidth ((HIC_ScreenWidth-16*2-16*2)-7*3)/4.0
#define HWD_WriteContentImageRowSepc 12

NS_ASSUME_NONNULL_BEGIN

/// 作业详情的您的作业内容   -- 固有高度 117  -- 需要计算内部作业的文字 和图片高度(两层之间需要有距离)
@interface HomeworkDetailWriteCell : HomeworkDetailBaseCell

+(CGFloat)getStringHeight:(NSString *)str;

@end

NS_ASSUME_NONNULL_END
