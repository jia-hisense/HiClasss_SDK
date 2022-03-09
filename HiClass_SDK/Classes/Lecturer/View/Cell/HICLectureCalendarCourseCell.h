//
//  HICLectureCalendarCourseCell.h
//  HiClass
//
//  Created by hisense on 2020/5/15.
//  Copyright © 2020 haoqian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HICLectureCalendarCourseFrame.h"

NS_ASSUME_NONNULL_BEGIN

@interface HICLectureCalendarCourseCell : UITableViewCell

@property (nonatomic, weak) UIView *bgView;

@property (nonatomic, strong) HICLectureCalendarCourseFrame *courseFrame;

+(instancetype)cellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
