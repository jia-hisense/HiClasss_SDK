//
//  HomeworkImageViewCell.h
//  HiClass
//
//  Created by 铁柱， on 2020/3/27.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HICHomeWorkWriteVC.h"

NS_ASSUME_NONNULL_BEGIN
@class HomeworkImageViewCell;
@protocol HomeworkImageViewCellDelegate <NSObject>

-(void)imageViewCell:(HomeworkImageViewCell *)cell clickDeleateBut:(UIButton *)but model:(HomeworkImageModel *)model;

@end

@interface HomeworkImageViewCell : UICollectionViewCell

@property (nonatomic, strong) HomeworkImageModel *model;
@property (nonatomic, weak) id <HomeworkImageViewCellDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
