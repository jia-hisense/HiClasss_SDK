//
//  HICLectureTeachCalendarView.h
//  HiClass
//
//  Created by WorkOffice on 2020/4/1.
//  Copyright © 2020 jingxianglong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HICLectureCalendarTrainFrame.h"
#import "HICLectureCourseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HICLectureTeachCalendarView : UITableView
-(instancetype)initWithFrame:(CGRect)frame;

@property (nonatomic, assign) BOOL isDataOnceSuccess;

@property (nonatomic, assign) NSInteger lecturerId;

@property (nonatomic, copy) NetError netErrorBlock;

- (void)topRefresh;
- (void)bottomRefresh;
@end

NS_ASSUME_NONNULL_END
