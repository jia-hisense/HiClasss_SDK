//
//  JHKOfflineCourseScoreSectionView.h
//  JHKOffLineViewDemo
//
//  Created by wangggang on 2020/4/20.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HICOfflineCourseModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHKOfflineCourseScoreSectionView : UIView
@property (weak, nonatomic) IBOutlet UILabel *resultScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
+(instancetype)getScoreSectionView;
@property (nonatomic, strong) HICOfflineCourseModel *model;
@end

NS_ASSUME_NONNULL_END
