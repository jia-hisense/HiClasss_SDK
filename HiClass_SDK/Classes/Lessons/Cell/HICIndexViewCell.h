//
//  HICIndexViewCell.h
//  HiClass
//
//  Created by WorkOffice on 2020/2/4.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HICIndexViewCell.h"
#import "HICKldSectionLIstModel.h"
#import "HICBaseInfoModel.h"
NS_ASSUME_NONNULL_BEGIN
@protocol HICIndexCellDelegate <NSObject>
- (void)clickExtension:(CGFloat)cellHeight andIndex:(NSIndexPath *)indexPath andShowContent:(BOOL)isShowContent;
- (void)jumpKnowledge:(HICBaseInfoModel *)baseModel andSectionId:(NSNumber *)sectionId andIndexPath:(NSIndexPath *)indexPath andIndex:(NSInteger)index;
- (void)jumpExam:(NSNumber *)examId andStatus:(NSInteger)status andIndexPath:(NSIndexPath *)indexPath andIndex:(NSInteger)index;
@end
@interface HICIndexViewCell : UITableViewCell
@property(nonatomic,weak)id<HICIndexCellDelegate>extensionDelegate;
@property (nonatomic ,strong)HICKldSectionLIstModel *kldModel;
//- (void)setIsfirst:(BOOL)isFirst andCellIndex:(NSIndexPath *)indexPath andModel:(HICKldSectionLIstModel *)kldModel;
- (void)setIsfirst:(BOOL)isFirst andCellIndex:(NSIndexPath *)indexPath andModel:(HICKldSectionLIstModel *)kldModel andShowContent:(BOOL)isShowContent;
@end

NS_ASSUME_NONNULL_END
