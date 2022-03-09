//
//  SearchTeacherInfoCell.h
//  iTest
//
//  Created by Sir_Jing on 2020/3/18.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HICSearchDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 搜索教师简介cell   -- 固定高度 -- 106 -- 暂时去掉教师简介 88的高度即可
@interface SearchTeacherInfoCell : UITableViewCell

@property (nonatomic, strong) SearchDetailInfoModel *infoModel;

@end

NS_ASSUME_NONNULL_END
