//
//  HICCourseDownloadCell.h
//  HiClass
//
//  Created by Eddie Ma on 2020/2/13.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HICCourseDownloadModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HICCourseDownloadCellDelegate <NSObject>
@optional
/// 展开按钮点击
- (void)actionClicked:(NSInteger)index extraViewHeight:(CGFloat)height;

/// 展开的各个项目按钮点击
- (void)subItemClicked:(NSInteger)tag;


@end

@interface HICCourseDownloadCell : UITableViewCell

@property (nonatomic, weak) id<HICCourseDownloadCellDelegate>delegate;

- (void)setData:(HICCourseDownloadModel *)model index:(NSInteger)index showExtraView:(BOOL)showExtraView subItemChecked:(NSArray *)arr checkedItems:(NSArray *)checkedItems;

@end

NS_ASSUME_NONNULL_END
