//
//  HICCheckNoteCell.h
//  HiClass
//
//  Created by Eddie Ma on 2020/2/11.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HICCheckNoteModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HICCheckNoteCellDelegate <NSObject>
@optional
/// 笔记复制按钮点击
- (void)copyClicked:(NSInteger)index;

/// 笔记删除按钮点击
- (void)deleteClicked:(NSInteger)index;

/// 笔记设置重要按钮点击
- (void)setToImportantClicked:(NSInteger)index;

- (void)showMoreBtnClicked:(NSInteger)index eachBtnCanEdit:(BOOL)canEdit;

@end

@interface HICCheckNoteCell : UITableViewCell

@property (nonatomic, weak) id<HICCheckNoteCellDelegate>delegate;

- (void)setData:(HICCheckNoteModel *)model index:(NSInteger)index isLastOne:(BOOL)isLast moreBtnCanEdit:(BOOL)can eachMoteBtnCanEdit:(BOOL)eachMoteBtnCanEdit;

//- (void)showMoreBtnsUpdate;

@end

NS_ASSUME_NONNULL_END
