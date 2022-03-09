//
//  HICStudyDocPhotoDetailCell.h
//  HiClass
//
//  Created by Sir_Jing on 2020/2/10.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HICMediaInfoModel.h"
#import "HICControlInfoModel.h"
NS_ASSUME_NONNULL_BEGIN
@protocol HICStudyDocPhotoDetailCellDelegate <NSObject>

- (void)clickPic;

@end
@interface HICStudyDocPhotoDetailCell : UICollectionViewCell
@property (nonatomic,strong)HICMediaInfoModel *model;
@property (nonatomic, strong)HICControlInfoModel *controlModel;
@property (nonatomic, weak)id <HICStudyDocPhotoDetailCellDelegate>docDelegate;

- (void)resumeScale;
@end

NS_ASSUME_NONNULL_END
