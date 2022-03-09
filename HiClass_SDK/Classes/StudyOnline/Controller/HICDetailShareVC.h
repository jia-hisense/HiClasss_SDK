//
//  HICDetailShareVC.h
//  HiClass
//
//  Created by WorkOffice on 2020/3/5.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HICTrainDetailBaseModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HICDetailShareVC : UIViewController
@property (nonatomic ,strong)HICTrainDetailBaseModel *model;
@property (nonatomic ,strong)NSNumber *rankNum;
@end

NS_ASSUME_NONNULL_END
