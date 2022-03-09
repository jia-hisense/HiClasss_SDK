//
//  HICContributorListVC.h
//  HiClass
//
//  Created by WorkOffice on 2020/2/5.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HICContributorModel.h"
#import "HICAuthorModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HICContributorListVC : UIViewController
@property (nonatomic ,strong)HICAuthorModel *authorModel;
@property (nonatomic ,strong)HICContributorModel *contributor;
@property (nonatomic ,assign)NSInteger type;
@end

NS_ASSUME_NONNULL_END
