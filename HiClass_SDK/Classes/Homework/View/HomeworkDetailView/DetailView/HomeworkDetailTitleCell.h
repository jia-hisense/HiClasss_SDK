//
//  HomeworkDetailTitleCell.h
//  HiClass
//
//  Created by 铁柱， on 2020/3/26.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "HomeworkDetailBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

/// 作业详情页面的标题cell -- 固有高度  104  - 包含标题两行的高度 - 45 计算时需要去掉
@interface HomeworkDetailTitleCell : HomeworkDetailBaseCell

+(CGFloat)getStringHeight:(NSString *)str;

@end

NS_ASSUME_NONNULL_END
