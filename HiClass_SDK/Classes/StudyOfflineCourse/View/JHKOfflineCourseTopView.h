//
//  JHKOfflineCourseTopView.h
//  JHKOffLineViewDemo
//
//  Created by wangggang on 2020/4/20.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HICOfflineCourseModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHKOfflineCourseTopView : UIView
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *navTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *stateImageV;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navTop;
@property (nonatomic, strong) HICOfflineCourseModel *model;
+(instancetype)getTopView;
@end

NS_ASSUME_NONNULL_END
