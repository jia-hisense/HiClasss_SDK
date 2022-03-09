//
//  HICMixTrainArrangeCell.h
//  HiClass
//
//  Created by WorkOffice on 2020/6/15.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OfflineTrainingListModel.h"
#import "HICMixTrainArrangeModel.h"
NS_ASSUME_NONNULL_BEGIN
@protocol HICMixTrainArrangeDelegate <NSObject>
- (void)clickExtension:(CGFloat)cellHeight andIndex:(NSInteger)index andIsShowContent:(BOOL)isShowContent;
- (void)refreshData;
@end
@interface HICMixTrainArrangeCell : UITableViewCell
@property (nonatomic ,assign)BOOL isFirst;
@property (nonatomic ,strong)NSIndexPath *indexPath;
@property (nonatomic ,strong)HICMixTrainArrangeModel *model;
@property (nonatomic, weak)id<HICMixTrainArrangeDelegate>extensionDelegate;
@property (nonatomic ,assign)BOOL isShowContent;
@property (nonatomic,strong)OfflineMixTrainCellModel *cellModel;
@property (nonatomic ,assign)NSInteger trainId;
@property (nonatomic ,assign)NSInteger trainTerminated;
@end
NS_ASSUME_NONNULL_END
