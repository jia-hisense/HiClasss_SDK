//
//  HICLectureCalendarTrainCell.h
//  HiClass
//
//  Created by hisense on 2020/5/15.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HICLectureCalendarTrainFrame.h"

NS_ASSUME_NONNULL_BEGIN

@interface HICLectureCalendarTrainCell : UITableViewCell
@property (nonatomic, weak) UIView *bgView;

@property (nonatomic, strong) HICLectureCalendarTrainFrame *trainFrame;

+(instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
