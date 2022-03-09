//
//  HICLessonIntroductCell.h
//  HiClass
//
//  Created by WorkOffice on 2020/2/4.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HICBaseInfoModel.h"
NS_ASSUME_NONNULL_BEGIN
@protocol HICLessonIntroductDelegate <NSObject>
- (void)jumpContributorList:(HICContributorModel *)model;
@end
@interface HICLessonIntroductCell : UITableViewCell
@property (nonatomic, strong)HICBaseInfoModel *baseModel;
@property (nonatomic, weak)id<HICLessonIntroductDelegate> lessonDelegate;
@end

NS_ASSUME_NONNULL_END
