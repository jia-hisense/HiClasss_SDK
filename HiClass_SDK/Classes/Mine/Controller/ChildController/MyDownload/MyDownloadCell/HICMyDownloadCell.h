//
//  HICMyDownloadCell.h
//  HiClass
//
//  Created by Eddie_Ma on 23/2/20.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HICMyDownloadCellDelegate <NSObject>
@optional
/// 下载
- (void)downloadBtnClicked:(HICKnowledgeDownloadModel *)kModel;
@end

@interface HICMyDownloadCell : UITableViewCell

@property (nonatomic, weak) id<HICMyDownloadCellDelegate>delegate;

- (void)setData:(HICKnowledgeDownloadModel *)kModel index:(NSInteger)index isPureKnowledge:(BOOL)isPureKnowledge isEditing:(BOOL)isEditing checked:(NSArray *)checkArr ;

- (void)setProcessUIWith:(HICKnowledgeDownloadModel *)kModel percent:(CGFloat)percent;

@end

NS_ASSUME_NONNULL_END
