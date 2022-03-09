//
//  HomeworkDetailBaseCell.h
//  HiClass
//
//  Created by 铁柱， on 2020/3/26.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HomeworkDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@class HomeworkDetailBaseCell;
@protocol HomeworkDetailBaseCellDelegate <NSObject>

-(void)detailBaseCell:(HomeworkDetailBaseCell *)cell didSelectIndex:(NSInteger)currentIndex withModel:(HomeworkDetailAttachmentModel *)attModel;

@end

@interface HomeworkDetailBaseCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *cellIndexPath;

@property (nonatomic, strong) HomeworkDetailModel *detailModel;
@property (nonatomic, copy) NSString *titleName;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic ,assign) NSInteger totalScore;
@property (nonatomic, weak) id <HomeworkDetailBaseCellDelegate>delegate;

/// 设置cell的标识信息
/// @param isPass 是否合格
/// @param score 分数
/// @param isShowScore 是否显示分数
-(void)setCellPassImage:(BOOL)isPass score:(NSInteger)score isShowScore:(BOOL)isShowScore;

@end

NS_ASSUME_NONNULL_END
