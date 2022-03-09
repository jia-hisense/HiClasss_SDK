//
//  HICTrainDetailCell.h
//  HiClass
//
//  Created by WorkOffice on 2020/3/5.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HICTrainDetailListModel.h"
#import "HICTrainDetailStageActionsModel.h"
NS_ASSUME_NONNULL_BEGIN
@protocol HICTrainDetailDelegate <NSObject>
- (void)clickExtension:(CGFloat)cellHeight andIndex:(NSInteger)index andIsShowContent:(BOOL)isShowContent;
- (void)jumpKonwledge:(HICTrainDetailStageActionsModel *)model andSectionId:(NSNumber *)sectionId andIsEnd:(NSInteger)isEnd andIsStart:(NSInteger)isStart andIndx:(NSInteger)index;
///type=1,申请打分 type=2查看打分列表
- (void)clickScoreBtnWithType:(NSInteger)type andTaskId:(NSNumber *)taskId;
@end
@interface HICTrainDetailCell : UITableViewCell
@property (nonatomic ,assign)BOOL isFirst;
@property (nonatomic, assign)NSIndexPath *indexPath;
@property (nonatomic, strong)HICTrainDetailListModel *model;
@property(nonatomic,weak)id<HICTrainDetailDelegate>extensionDelegate;
@property (nonatomic ,assign)BOOL isShowContent;
@property (nonatomic, assign) BOOL isPushMap;
@end

NS_ASSUME_NONNULL_END
