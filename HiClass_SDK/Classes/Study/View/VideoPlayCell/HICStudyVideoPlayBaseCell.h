//
//  HICStudyVideoPlayBaseCell.h
//  iTest
//
//  Created by Sir_Jing on 2020/2/4.
//  Copyright © 2020 Sir_Jing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    StudyVideoPlayCellExercises = 1,    // 练习题
    StudyVideoPlayCellRelated,          // 相关推荐
    StudyVideoPlayCellComment,          // 评论
} StudyVideoPlayCellType;

NS_ASSUME_NONNULL_BEGIN

@class HICStudyVideoPlayBaseCell;
@protocol HICStudyVideoPlayBaseCellDelegate <NSObject>

@optional

/// 更多的点击事件回调
/// @param cell 当前回调的Cell
/// @param btn 当前点击的Btn
/// @param cellType 点击cell的类型
-(void)studyVideoPlayCell:(HICStudyVideoPlayBaseCell *)cell clickMoreBut:(UIButton *_Nullable)btn cellType:(StudyVideoPlayCellType)cellType;


/// 点击Item的事件回调
/// @param cell 当前回调Cell
/// @param btn 当前点击的Btn
/// @param cellType cell的类型
/// @param data 返回item对应的数据
-(void)studyVideoPlayCell:(HICStudyVideoPlayBaseCell *)cell clickItemBut:(UIButton *_Nullable)btn cellType:(StudyVideoPlayCellType)cellType itemModel:(id)data;

@end

@interface HICStudyVideoPlayBaseCell : UITableViewCell

@property (nonatomic, weak) id<HICStudyVideoPlayBaseCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
