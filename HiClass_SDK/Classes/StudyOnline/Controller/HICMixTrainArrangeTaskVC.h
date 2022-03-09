//
//  HICMixTrainArrangeTaskVC.h
//  HiClass
//
//  Created by WorkOffice on 2020/6/16.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HICMixTrainArrangeModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HICMixTrainArrangeTaskVC : UIViewController
@property (nonatomic ,strong)NSMutableArray *dataArr;
@property (nonatomic ,strong)NSNumber *trainId;
@property (nonatomic ,strong)NSString *name;
///培训是否已结束
@property (nonatomic ,assign)NSInteger trainTerminated;
@end

NS_ASSUME_NONNULL_END
