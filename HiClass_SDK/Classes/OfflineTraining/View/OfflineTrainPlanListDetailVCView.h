//
//  OfflineTrainPlanListDetailVCView.h
//  HiClass
//
//  Created by 铁柱， on 2020/4/15.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OfflineTrainingListModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface OfflineTrainPlanListDetailVCView : UIViewController

@property (nonatomic, assign) PlanDetailType detailType;

@property (nonatomic, strong) OfflineTrainListCellModel *cellModel;

@property (nonatomic, copy) void(^refreshBlock)(NSInteger index);

@property (nonatomic, assign) NSInteger trainId;

-(void)refreshData;

@end

NS_ASSUME_NONNULL_END
