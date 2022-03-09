//
//  HICMixAllView.h
//  HiClass
//
//  Created by WorkOffice on 2020/6/22.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import "HICMixBaseView.h"
#import "HICMixTrainArrangeModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HICMixAllView : HICMixBaseView
@property (nonatomic, strong) HICMixTrainArrangeModel *arrangeModel;
@property (nonatomic ,strong) OfflineMixTrainCellModel *cellModel;
@end

NS_ASSUME_NONNULL_END
