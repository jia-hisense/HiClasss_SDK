//
//  HICLectureInductView.h
//  HiClass
//
//  Created by WorkOffice on 2020/3/12.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HICLectureDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HICLectureInductView : UIView
-(instancetype)initWithFrame:(CGRect)frame;
@property (nonatomic ,strong)HICLectureDetailModel *model;
@end

NS_ASSUME_NONNULL_END
