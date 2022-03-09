//
//  HICMixTrainArrangeVC.h
//  HiClass
//
//  Created by WorkOffice on 2020/6/15.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HICMixTrainArrangeVC : UIViewController
@property (nonatomic ,strong)NSNumber *trainId;
@property (nonatomic ,strong)NSNumber *registerId;
@property (nonatomic ,assign)BOOL isReload;
@property (nonatomic ,assign)BOOL isDesc;
@end

NS_ASSUME_NONNULL_END
