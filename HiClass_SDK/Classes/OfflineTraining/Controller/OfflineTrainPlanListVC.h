//
//  OfflineTrainPlanListVC.h
//  HiClass
//
//  Created by 铁柱， on 2020/4/15.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import "DCPagerController.h"

NS_ASSUME_NONNULL_BEGIN

@interface OfflineTrainPlanListVC : DCPagerController

@property (nonatomic, assign) NSInteger trainId;

@property (nonatomic, assign) BOOL isShowRightMore;

@property (nonatomic, assign) NSInteger webSelectIndex;

@property (nonatomic, strong) NSNumber *registerId;
//@property (nonatomic, strong) NSMutableArray<NSDictionary *> *signBackSources; // 早退原因 -- 不需要存储

@end

NS_ASSUME_NONNULL_END
