//
//  HICChildMineDetailVC.h
//  HiClass
//
//  Created by WorkOffice on 2020/2/24.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HICCourseModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HICChildMineDetailVC : UIViewController
@property (nonatomic ,strong) NSNumber *noteId;
@property (nonatomic ,assign) NSInteger objectType;
@property (nonatomic ,strong) NSNumber *objectId;
@property (nonatomic ,strong)HICCourseModel *model;
@end

NS_ASSUME_NONNULL_END
