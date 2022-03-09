//
//  HICStudyDocPhotoListItemCell.h
//  HiClass
//
//  Created by Sir_Jing on 2020/2/10.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HICMediaInfoModel.h"
#import "HICControlInfoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HICStudyDocPhotoListItemCell : UITableViewCell
@property (nonatomic ,strong)HICMediaInfoModel *model;
@property (nonatomic ,strong)HICControlInfoModel *controlModel;
@end

NS_ASSUME_NONNULL_END
